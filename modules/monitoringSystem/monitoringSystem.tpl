#!/bin/bash
sudo yum update -y
sudo yum install -y yum-utils
#install docker
sudo amazon-linux-extras install docker -y
#start docker
sudo service docker start
#download docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#fix permissions
sudo chmod +x /usr/local/bin/docker-compose
cd /opt
#install git
sudo yum install git -y
#clone git repo
sudo git clone https://github.com/2110781006/TMCS-PT-Monitoring.git
cd /opt/TMCS-PT-Monitoring/modules/monitoringSystem
sudo docker volume create --name grafana-data
sudo -E /usr/local/bin/docker-compose up -d
sudo yum install jq -y
export DB_Url=${dbUrl}
export DB_Password=${dbPassword}
sudo -E sed -i "s/<url>/$DB_Url/" /opt/TMCS-PT-Monitoring/modules/monitoringSystem/myDataSource.json
sudo -E sed -i "s/<password>/$DB_Password/" /opt/TMCS-PT-Monitoring/modules/monitoringSystem/myDataSource.json
#import datasource
export Grafana_Admin=${grafanaPassword}
sudo curl -X "POST" "http://54.152.220.39:3000/api/datasources" -H "Content-Type: application/json" --user admin:$Grafana_Admin --data-binary @myDataSource.json
