#!/bin/bash

# Instalação do PostgreSQL
sudo apt update
sudo apt install postgresql -y

#Criar repositório para armazenar os dumps
sudo mkdir -p /var/backups/pgsql/12/dump/
sudo mkdir -p /var/backups/pgsql/12/dumpall/

#mudar o proprietário e o grupo dos diretórios para  postgres
sudo chown -R postgres:postgres /var/backups/pgsql


# Criação do banco de dados e tabelas (executado como o usuário postgres)
sudo -u postgres psql -c "CREATE DATABASE educacional;"
sudo -u postgres psql -d educacional -c "
CREATE TABLE Aluno (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(100),
    Matricula VARCHAR(20) UNIQUE
);

CREATE TABLE Curso (
    ID SERIAL PRIMARY KEY,
    Nome VARCHAR(100)
);

INSERT INTO Aluno (Nome, Matricula) VALUES ('João Silva', '2023001');
INSERT INTO Aluno (Nome, Matricula) VALUES ('Maria Oliveira', '2023002');
INSERT INTO Aluno (Nome, Matricula) VALUES ('Carlos Souza', '2023003');
INSERT INTO Aluno (Nome, Matricula) VALUES ('Ana Costa', '2023004');
INSERT INTO Aluno (Nome, Matricula) VALUES ('Paulo Mendes', '2023005');

INSERT INTO Curso (Nome) VALUES ('Engenharia de Software');
INSERT INTO Curso (Nome) VALUES ('Administração');
INSERT INTO Curso (Nome) VALUES ('Direito');
INSERT INTO Curso (Nome) VALUES ('Medicina');
INSERT INTO Curso (Nome) VALUES ('Arquitetura');
"

# Voltar para o usuário padrão após a execução
exit
