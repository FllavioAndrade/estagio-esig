#!/bin/bash

# Nome do contêiner do Tomcat
NOME_DO_CONTEINER="tomcat-server"

# Verificar o status do contêiner e reiniciar se estiver parado por mais de 1 minuto
STATUS=$(docker inspect -f '{{.State.Status}}' $NOME_DO_CONTEINER)

#
if [ "$STATUS" == "running" ]; then
  TEMPO_ATIVO=$(docker inspect -f '{{.State.StartedAt}}' $NOME_DO_CONTEINER)
  SEGUNDOS_ATIVO=$(( $(date +%s) - $(date -d "$TEMPO_ATIVO" +%s) ))
  HORA=$((SEGUNDOS_ATIVO / 3600))
  MIN=$(((SEGUNDOS_ATIVO % 3600)/60)) 
  SEG=$((SEGUNDOS_ATIVO % 60))
  echo "A instância do Tomcat está em execução. $SEG" 
  echo "Tempo de atividade: $((HORA)) h   $((MIN)) min $((SEG)) seg."
else
    ./start-tomcat.sh
fi
