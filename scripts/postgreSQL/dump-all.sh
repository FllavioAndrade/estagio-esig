#!/bin/bash

# Configurações
BACKUP_BASE_DIR="/var/backups/pgsql"  # Diretório base para backups
PGMAJOR=12
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")  # Timestamp para evitar sobrescrita de backups

# Diretório de backup para a instância completa
BACKUP_DIR_ALL="$BACKUP_BASE_DIR/$PGMAJOR/dumpall/$TIMESTAMP"

# Criar diretório de backup
mkdir -p "$BACKUP_DIR_ALL"

# Backup de toda a instância PostgreSQL
echo "Criando backup completo da instância PostgreSQL..."
pg_dumpall > "$BACKUP_DIR_ALL/cluster.dump.sql"
echo "Backup completo da instância salvo em: $BACKUP_DIR_ALL/cluster.dump.sql"
