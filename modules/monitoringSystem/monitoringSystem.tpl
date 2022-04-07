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
export MY_Url=$(curl http://checkip.amazonaws.com)
sudo -E sed -i "s/<url>/$DB_Url/" /opt/TMCS-PT-Monitoring/modules/monitoringSystem/myDataSource.json
sudo -E sed -i "s/<password>/$DB_Password/" /opt/TMCS-PT-Monitoring/modules/monitoringSystem/myDataSource.json
sleep 120
#import datasource
export Grafana_Password=${grafanaPassword}
sudo -E curl -X "POST" "http://localhost:3000/api/datasources" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @myDataSource.json
sudo -E curl -X "POST" "http://localhost:3000/api/dashboards/db" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @homeDashboard.json
sudo -E curl -X "POST" "http://localhost:3000/api/dashboards/db" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @opcuaDashboard.json
sudo -E curl -X "POST" "http://localhost:3000/api/dashboards/db" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @winccoaDashboard.json
#install loki
sudo docker run -d --name=loki -p 3100:3100 grafana/loki
sudo -E sed -i "s/<url>/$MY_Url/" /opt/TMCS-PT-Monitoring/modules/monitoringSystem/lokiDatasource.json
sudo -E curl -X "POST" "http://localhost:3000/api/datasources" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @lokiDatasource.json
sudo -E curl -X "POST" "http://localhost:3000/api/dashboards/db" -H "Content-Type: application/json" --user admin:$Grafana_Password --data-binary @winccoaLogDashboard.json
