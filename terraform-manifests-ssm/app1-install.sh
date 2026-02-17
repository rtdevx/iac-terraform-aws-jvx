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

nohup java -jar /opt/jvx.jar --server.port=8080 > /var/log/jvx.log 2>&1 &