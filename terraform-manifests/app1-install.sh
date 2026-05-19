#!/bin/bash
set -e

yum update -y
yum install -y java-17-amazon-corretto-headless awscli amazon-ssm-agent

# NOTE: Enable ssm-agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# NOTE: Install jvx java application
APP_VERSION=$(aws ssm get-parameter --name "/jvx/version" --query "Parameter.Value" --output text)
aws s3 cp s3://rk-artifact/jvx-$APP_VERSION.jar /opt/jvx.jar

# NOTE: Create a systemd unit file for jvx app

#nohup java -jar /opt/jvx.jar --server.port=8080 > /var/log/jvx.log 2>&1 &

cat <<EOF >/etc/systemd/system/jvx.service
[Unit]
Description=JVX Java Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt
Environment="JAVA_OPTS=-Xms256m -Xmx512m"
ExecStart=/usr/bin/java \$JAVA_OPTS -jar /opt/jvx.jar --server.port=8080
SuccessExitStatus=143
Restart=on-failure
RestartSec=5
StandardOutput=append:/var/log/jvx.log
StandardError=append:/var/log/jvx.log
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable jvx
sudo systemctl start jvx