#!/bin/bash
# Atualiza a lista de pacotes e instala as atualizações
sudo apt update -y && sudo apt upgrade -y

# Instala dependências necessárias
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Adiciona a chave GPG do repositório do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Adiciona o repositório do Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Atualiza a lista de pacotes novamente
sudo apt update -y

# Instala o Docker
sudo apt install -y docker-ce

# Baixa a versão mais recente do Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Torna o Docker Compose executável
sudo chmod +x /usr/local/bin/docker-compose

# Verifica se o Docker e Docker Compose foram instalados corretamente
sudo docker --version
sudo docker-compose --version

# Download e extração dos arquivos
cd /tmp
sudo wget https://github.com/OpsXandao/docker/raw/refs/heads/main/docker.zip
sudo unzip docker.zip -d /tmp
cd /tmp/docker/docker

# Inicialização dos contêineres do Docker com Docker Compose
sudo docker-compose up -d