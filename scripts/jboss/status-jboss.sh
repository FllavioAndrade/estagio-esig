#!/bin/bash

# Nome do serviço (no caso, WildFly)
NOME_SERVICO="wildfly"

# Verifica o status do serviço
STATUS=$(systemctl is-active "$NOME_SERVICO")

# Função para calcular o tempo decorrido em formato legível
calcular_tempo_atividade() {
    local tempo_inicio=$1
    local tempo_atual=$(date +%s)
    local segundos_atividade=$((tempo_atual - tempo_inicio))
    echo $(printf "%dd %dh %dm %ds" $((segundos_atividade/86400)) $((segundos_atividade%86400/3600)) $((segundos_atividade%3600/60)) $((segundos_atividade%60)))
}

# Se o serviço estiver rodando
if [ "$STATUS" = "active" ]; then
    # Obtém o timestamp de quando o serviço foi iniciado
    TEMPO_INICIO=$(systemctl show -p ActiveEnterTimestamp --value "$NOME_SERVICO")

    # Converte o timestamp para segundos
    TEMPO_INICIO_SEGUNDOS=$(date -d "$TEMPO_INICIO" +%s)

    # Calcula o tempo de atividade
    TEMPO_ATIVIDADE=$(calcular_tempo_atividade "$TEMPO_INICIO_SEGUNDOS")

    echo "O serviço $NOME_SERVICO está rodando."
    echo "Tempo de atividade: $TEMPO_ATIVIDADE"

# Se o serviço estiver parado
elif [ "$STATUS" = "inactive" ]; then
    # Obtém o timestamp de quando o serviço foi parado
    TEMPO_PARADA=$(systemctl show -p InactiveEnterTimestamp --value "$NOME_SERVICO")

    # Converte o timestamp para segundos
    TEMPO_PARADA_SEGUNDOS=$(date -d "$TEMPO_PARADA" +%s)

    # Calcula há quanto tempo o serviço está parado
    TEMPO_ATUAL=$(date +%s)
    TEMPO_DESDE_PARADA=$((TEMPO_ATUAL - TEMPO_PARADA_SEGUNDOS))

    echo "O serviço $NOME_SERVICO está parado."
    echo "Tempo desde que foi parado: $(calcular_tempo_atividade "$TEMPO_PARADA_SEGUNDOS")"

    # Chama o script de inicialização se o serviço estiver parado há mais de 1 minuto
    if [ "$TEMPO_DESDE_PARADA" -gt 60 ]; then
        echo "O serviço está parado há mais de 1 minuto. Iniciando o serviço..."
        ./start-jboss.sh
    fi

# Se o serviço estiver em outro estado (ex.: falhou)
else
    echo "O serviço $NOME_SERVICO está em estado desconhecido: $STATUS"
fi