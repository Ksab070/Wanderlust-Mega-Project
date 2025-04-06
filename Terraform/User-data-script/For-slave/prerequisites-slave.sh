#!/bin/bash 

set -euo pipefail

#Install other pre-reqs
yum install java-17-amazon-corretto docker nano git -y

systemctl start docker.service && systemctl enable docker.service

#Give permission to ec2-user for using docker 
usermod -a -G docker ec2-user

#Installing docker compose (steps taken from docker documentation)

#This step is added by me as sometimes cloud-init may not always set the HOME variable properly, causing the script to fail at line 16.

DOCKER_PLUGIN_DIR="/usr/libexec/docker/cli-plugins"
#Using the above path as docker plugin directory because the user-data script runs with root, and the plugin directory will be created in /root/.docker and ec2-user will not be able to access it because docker does not know if the plugin is even available

mkdir -p $DOCKER_PLUGIN_DIR

curl -SL https://github.com/docker/compose/releases/download/v2.34.0/docker-compose-linux-x86_64 -o $DOCKER_PLUGIN_DIR/docker-compose

#Give everyone permission to 
chmod 777 $DOCKER_PLUGIN_DIR/docker-compose