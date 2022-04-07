#!/bin/bash
sudo yum update -y
#install docker
sudo amazon-linux-extras install docker -y
#start docker
sudo service docker start
#install git
sudo yum install git -y
sudo mkdir /opt/winccoa/
cd /opt/winccoa/
#install java
sudo yum install java -y
#download wincc oa 3.15 base
sudo wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ" -O WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm && rm -rf /tmp/cookies.txt
#install wincc oa 3.15 base
sudo yum -y install /opt/winccoa/WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm
#download wincc oa 3.15 sql
sudo wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=19Jr-cEEyXFTmHqxEl-FZAARjMUEedRzx' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=19Jr-cEEyXFTmHqxEl-FZAARjMUEedRzx" -O WinCC_OA_3.15-sqldrivers-rhel-0-37.x86_64.rpm && rm -rf /tmp/cookies.txt
#install wincc oa 3.15 sql
sudo yum -y install /opt/winccoa/WinCC_OA_3.15-sqldrivers-rhel-0-37.x86_64.rpm
echo ${connectToOpcUaServers} >> servers.txt
export OPCUA_Servers=${connectToOpcUaServers}
echo ${dbHost} >> dbhost.txt
export DB_Host=${dbHost}
echo ${dbUser} >> dbUser.txt
export DB_User=${dbUser}
echo ${dbPassword} >> dbPassword.txt
export DB_Password=${dbPassword}
echo ${monitoringHost} >> monitoringHost.txt
export monitoringHost=${monitoringHost}
#clone git repo
sudo git clone https://github.com/2110781006/TMCS-PT-Monitoring.git
#install fluentd
sudo curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh
#replace config
sudo cp /opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/fluent.conf /etc/td-agent/td-agent.conf
sudo -E sed -i "s/<monitoringHost>/$monitoringHost/" /etc/td-agent/td-agent.conf
#replace service file
sudo cp /opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/td-agent.service /lib/systemd/system/td-agent.service
#reload service
sudo systemctl daemon-reload
#install loki plugin
sudo /usr/sbin/td-agent-gem install fluent-plugin-grafana-loki
#start fluentd
sudo systemctl start td-agent.service
sleep 5
cd /opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/OPCUA_Client
#wincc database unzip
sudo unzip -ou db.zip
#wincc oa  starten
sudo -E /opt/WinCC_OA/3.15/bin/WCCILpmon -autofreg -config /opt/winccoa/TMCS-PT-Monitoring/modules/winccoaSystem/OPCUA_Client/config/config
