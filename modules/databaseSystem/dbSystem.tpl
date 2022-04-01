#!/bin/bash
sudo yum update -y
sudo yum install -y yum-utils
#install docker
sudo amazon-linux-extras install docker -y
#start docker
sudo service docker start
#download docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#fick permissions
sudo chmod +x /usr/local/bin/docker-compose
#install git
sudo yum install git -y
echo ${dbPassword} >> dbPassword.txt
export DB_Password=${dbPassword}
cd /opt
#clone git repo
sudo git clone https://github.com/2110781006/TMCS-PT-Monitoring.git
cd TMCS-PT-Monitoring/modules/databaseSystem
docker stack deploy -c docker-compose.yml mariadb

