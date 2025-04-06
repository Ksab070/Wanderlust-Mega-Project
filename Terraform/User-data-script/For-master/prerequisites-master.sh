#!/bin/bash 

set -euo pipefail

#Using no sudo, as user-data script already runs on root privileges

#Downlaod jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

#Import jenkins key 
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#Update & Upgrade
yum update -y && yum upgrade -y 

#Install Pre-reqs
yum install java-17-amazon-corretto jenkins nano git -y

#Start Jenkins 
systemctl enable jenkins && systemctl start jenkins

#Pass the initial admin password to terraform 
cat /var/lib/jenkins/secrets/initialAdminPassword > /tmp/password.txt

