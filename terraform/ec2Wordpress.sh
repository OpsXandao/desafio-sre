#!/bin/bash

# Atualiza os repositórios e instala os pacotes necessários
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

sudo apt install -y unzip

# Download e extração dos arquivos
cd /tmp
sudo wget https://github.com/OpsXandao/ansible-wordpress/raw/refs/heads/main/ansible.zip
sudo unzip ansible.zip -d /tmp
cd /tmp/ansible-wordpress/

# Executa o playbook do Ansible com as variáveis especificadas
sudo ansible-playbook playbook.yml \
--extra-vars "wp_db_name=${wp_db_name} wp_username=${wp_username} wp_user_password=${wp_user_password} wp_db_host=${wp_db_host}"

# Download e execução do script node_exporter.sh
cd /tmp
wget https://projetoformacaosrelumr921298290312.s3.us-west-1.amazonaws.com/node_exporter.sh
sudo unzip node_exporter-main.zip -d /tmp
sudo sh node_exporter.sh