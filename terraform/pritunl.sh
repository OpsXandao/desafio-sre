#!/bin/bash

# Atualiza os repositórios e instala os pacotes necessários
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt install -y unzip

# Download e extração dos arquivos
cd /tmp
sudo wget https://github.com/OpsXandao/ansible-pritunl/raw/refs/heads/main/ansible.zip
sudo unzip ansible.zip -d /tmp
cd /tmp/ansible-pritunl/

# Executa o playbook do Ansible com as variáveis especificadas
sudo ansible-playbook pritunl.yml
