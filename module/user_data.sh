#!/bin/bash
dnf update -y
dnf install docker -y
systemctl enable docker
systemctl start docker

echo "[INFO] Trying to login to ECR..." >> /var/log/user_data.log
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267414915135.dkr.ecr.us-east-1.amazonaws.com >> /var/log/user_data.log 2>&1

echo "[INFO] Trying to run the container..." >> /var/log/user_data.log
docker run -d -p 80:80 267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest >> /var/log/user_data.log 2>&1

echo "[DONE] Finished user data script." >> /var/log/user_data.log
