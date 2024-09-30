#!/bin/bash

# Atualiza os repositórios e instala os pacotes necessários
sudo apt update
sudo wget -qO- https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo apt install -y unzip

cd /tmp
sudo wget https://github.com/OpsXandao/ansible-pritunl/raw/refs/heads/main/pritunl.zip
sudo unzip pritunl.zip -d /tmp
cd /tmp/pritunl/

sudo docker-compose up -d


cd.. 

sudo docker-compose up -d