#!/bin/bash

# Nome do contêiner do Tomcat
NOME_DO_CONTEINER="tomcat-server"

# Verificar o status do contêiner e reiniciar se estiver parado por mais de 1 minuto
STATUS=$(docker inspect -f '{{.State.Status}}' $NOME_DO_CONTEINER)

#
if [ "$STATUS" == "running" ]; then
  TEMPO_ATIVO=$(docker inspect -f '{{.State.StartedAt}}' $NOME_DO_CONTEINER)
  SEGUNDOS_ATIVO=$(( $(date +%s) - $(date -d "$TEMPO_ATIVO" +%s) ))
  echo "A instância do Tomcat está em execução." 
  echo "Tempo de atividade: $((SEGUNDOS_ATIVO / 60)) min $((SEGUNDOS_ATIVO % 60)) seg."
else
  HORA_PARADA=$(docker inspect -f '{{.State.FinishedAt}}' $NOME_DO_CONTEINER)
  TEMPO_PARADO=$(( $(date +%s) - $(date -d "$HORA_PARADA" +%s) ))

  if [ $TEMPO_PARADO -gt 60 ]; then
    echo "A instância está INATIVA"
    echo "Tempo de inatividade $((TEMPO_PARADO / 60)) min $((TEMPO_PARADO % 60)) seg"
    docker start $NOME_DO_CONTEINER
    sleep 5
    echo "Instância reiniciada com sucesso."
  else
    echo "A instância do Tomcat está INATIVA."
    echo "Tempo de inatividade: $((TEMPO_PARADO / 60)) min $((TEMPO_PARADO % 60)) seg"
  fi
fi
