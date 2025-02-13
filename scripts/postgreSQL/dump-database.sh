#!/bin/bash

# Configurações
DB_NAME="educacional"  # Nome do banco de dados
BACKUP_BASE_DIR="/var/backups/pgsql"  # Diretório base para backups
PGMAJOR=12
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")  # Timestamp para evitar sobrescrita de backups

# Diretório de backup
BACKUP_DIR="$BACKUP_BASE_DIR/$PGMAJOR/dump/$TIMESTAMP"
BACKUP_DIR_DIR="$BACKUP_DIR/dir"

# Criar diretório de backup
mkdir -p "$BACKUP_DIR_DIR"

# Backup em formato de diretório (parallel)
echo "Criando backup do banco de dados '$DB_NAME' em formato de diretório..."
pg_dump -j7 -Fd "$DB_NAME" -f "$BACKUP_DIR_DIR"
echo "Backup do banco '$DB_NAME' salvo em: $BACKUP_DIR_DIR"
