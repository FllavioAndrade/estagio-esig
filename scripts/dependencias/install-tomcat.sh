#!/bin/bash

#instalar o Unzip
sudo apt install unzip -y

# Mover para a Home
cd /home/vagrant/tomcat/

# baixar website 
mkdir webserver
cd webserver
wget https://html5up.net/massively/download
mv download download.zip
unzip download.zip
cd ..

# subir o docker-compose
sudo docker compose --compatibility up -d

