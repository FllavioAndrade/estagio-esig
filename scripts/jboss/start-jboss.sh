#!/bin/bash

# Nome do serviço (no caso, WildFly)
NOME_SERVICO="wildfly"

# Tenta iniciar o serviço
systemctl start "$NOME_SERVICO"

# Verifica se o serviço foi iniciado com sucesso
if [ $? -eq 0 ]; then
    echo "Serviço $NOME_SERVICO iniciado com sucesso."
else
    echo "Falha ao iniciar o serviço $NOME_SERVICO."
fi