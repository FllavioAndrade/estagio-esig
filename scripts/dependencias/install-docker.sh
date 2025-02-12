#!/bin/bash

# Atualizar o sistema
sudo apt-get update

# Instalar dependências necessárias
sudo apt-get install -y ca-certificates curl

# Criar diretório para as chaves GPG do Docker
sudo install -m 0755 -d /etc/apt/keyrings

# Baixar e adicionar a chave GPG oficial do Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adicionar o repositório do Docker às fontes do Apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizar novamente o sistema
sudo apt-get update

# Instalar o Docker e seus componentes
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionar o usuário atual ao grupo docker (para evitar usar sudo com docker)
sudo usermod -aG docker $USER

# Reiniciar o serviço do Docker
sudo systemctl restart docker

echo "Instalação do Docker concluída!"