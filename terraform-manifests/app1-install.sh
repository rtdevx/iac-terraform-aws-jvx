#!/bin/bash
set -e

yum update -y
yum install -y java-17-amazon-corretto-headless awscli

APP_VERSION=$(aws ssm get-parameter --name "/java-app1/version" --query "Parameter.Value" --output text)
aws s3 cp s3://my-app-artifacts/java-app1-$APP_VERSION.jar /opt/java-app1.jar

nohup java -jar /opt/java-app1.jar > /var/log/java-app1.log 2>&1 &
