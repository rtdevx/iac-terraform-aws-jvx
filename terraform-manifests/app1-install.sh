#!/bin/bash
set -e

yum update -y
yum install -y java-17-amazon-corretto-headless awscli amazon-ssm-agent

# Enable ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Ensure AWS CLI uses the configured region
export AWS_DEFAULT_REGION="${aws_region}"

# Retrieve keystore password from Secrets Manager
KEYSTORE_PW=$(aws secretsmanager get-secret-value \
  --secret-id "${jvx_tls_keystore_secret_arn}" \
  --query SecretString \
  --output text)

# Install jvx java application
APP_VERSION=$(aws ssm get-parameter --name "/jvx/version" --query "Parameter.Value" --output text)
aws s3 cp s3://rk-artifact/jvx-$APP_VERSION.jar /opt/jvx.jar
chmod 644 /opt/jvx.jar

# Create directory for certs
mkdir -p /opt/jvx
chmod 700 /opt/jvx

# Generate self-signed certificate and keystore
keytool -genkeypair \
  -alias jvx \
  -keyalg RSA \
  -keysize 2048 \
  -validity 365 \
  -keystore /opt/jvx/keystore.p12 \
  -storetype PKCS12 \
  -storepass "$${KEYSTORE_PW}" \
  -keypass "$${KEYSTORE_PW}" \
  -dname "CN=jvx.internal"

# Create systemd unit file for jvx app
cat <<EOF >/etc/systemd/system/jvx.service
[Unit]
Description=JVX Java Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt
Environment="JAVA_OPTS=-Xms256m -Xmx512m"
ExecStart=/usr/bin/java \$JAVA_OPTS -jar /opt/jvx.jar \
  --server.port=8443 \
  --server.ssl.enabled=true \
  --server.ssl.key-store=/opt/jvx/keystore.p12 \
  --server.ssl.key-store-password=$${KEYSTORE_PW} \
  --server.ssl.key-store-type=PKCS12 \
  --server.ssl.key-alias=jvx
SuccessExitStatus=143
Restart=on-failure
RestartSec=5
StandardOutput=append:/var/log/jvx.log
StandardError=append:/var/log/jvx.log
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable jvx
systemctl start jvx