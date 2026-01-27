#!/bin/bash
set -euo pipefail

yum update -y
yum install -y java-17-amazon-corretto-headless awscli nginx
# Update packages and install runtime
yum update -y
yum install -y java-17-amazon-corretto-headless awscli

# Create a dedicated user to run the JVM
if ! id -u jvx >/dev/null 2>&1; then
  useradd -r -s /sbin/nologin jvx
fi

APP_VERSION=$(aws ssm get-parameter --name "/jvx/version" --query "Parameter.Value" --output text)
aws s3 cp s3://rk-artifact/jvx-$APP_VERSION.jar /opt/jvx.jar
chown jvx:jvx /opt/jvx.jar
chmod 644 /opt/jvx.jar

# Create systemd service to run the app on port 8080 (non-privileged)
cat >/etc/systemd/system/jvx.service <<'EOF'
[Unit]
Description=JVX Java Application
After=network.target

[Service]
WorkingDirectory=/opt
ExecStart=/usr/bin/java -jar /opt/jvx.jar --server.port=80
SuccessExitStatus=143
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now jvx.service

touch /var/log/jvx.log
chown jvx:jvx /var/log/jvx.log || true

echo "JVX installed and running (java -> :80)"
echo "JVX installed and running (java -> 127.0.0.1:8080, nginx -> :80)"
