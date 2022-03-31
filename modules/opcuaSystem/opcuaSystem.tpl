#!/bin/bash
sudo yum update -y
#install git
sudo yum install git -y
sudo mkdir /opt/winccoa/
cd /opt/winccoa/
#download wincc oa 3.15 base
sudo wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=199hz9z1-Vhbc_FziDi0Gb7Ulmie5zTNZ" -O WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm && rm -rf /tmp/cookies.txt
#install wincc oa 3.15 base
sudo yum -y install /opt/winccoa/WinCC_OA_3.15-base-rhel-0-37.x86_64.rpm
#clone git repo
sudo git clone https://github.com/2110781006/TMCS-PT-Monitoring.git
cd TMCS-PT-Monitoring/modules/opcuaSystem/OPCUA_Server
#wincc database unzip
sudo unzip -ou db.zip