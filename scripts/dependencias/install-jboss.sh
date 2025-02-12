#!/bin/bash

# Atualizar o sistema
sudo apt update
sudo apt upgrade -y

# Instalar o JDK 17
sudo apt install -y openjdk-17-jdk

# Instalar curl e wget
sudo apt install -y curl wget

# Baixar a última versão do WildFly
WILDFLY_RELEASE=$(curl -s https://api.github.com/repos/wildfly/wildfly/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/wildfly/wildfly/releases/download/${WILDFLY_RELEASE}/wildfly-${WILDFLY_RELEASE}.tar.gz

# Extrair o WildFly
tar xvf wildfly-${WILDFLY_RELEASE}.tar.gz

# Mover o WildFly para /opt
sudo mv wildfly-${WILDFLY_RELEASE} /opt/wildfly

# Criar grupo e usuário para o WildFly
sudo groupadd --system wildfly
sudo useradd -s /sbin/nologin --system -d /opt/wildfly -g wildfly wildfly

# Criar diretório de configuração do WildFly
sudo mkdir /etc/wildfly

# Copiar arquivos de configuração
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

# Dar permissões adequadas
sudo chmod +x /opt/wildfly/bin/launch.sh
sudo chown -R wildfly:wildfly /opt/wildfly

# Recarregar systemd e iniciar o WildFly
sudo systemctl daemon-reload
sudo systemctl start wildfly
sudo systemctl enable wildfly

echo "Instalação do JDK 17 e WildFly concluída!"