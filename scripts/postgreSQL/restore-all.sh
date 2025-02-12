#!/bin/bash

# Configurações
BACKUP_BASE_DIR="/var/backups/pgsql"  # Diretório base dos backups
PGMAJOR=12

# Função para verificar erros
verificar_erro() {
  if [ $? -ne 0 ]; then
    echo "Erro: $1 falhou."
    exit 1
  fi
}

# Diretório de backups completos
BACKUP_DIR_ALL="$BACKUP_BASE_DIR/$PGMAJOR/dumpall"

# Listar backups completos disponíveis
echo "Backups completos da instância disponíveis:"
DUMPALL_FILES=($(ls $BACKUP_DIR_ALL/*/cluster.dump.sql | xargs -n 1 dirname | xargs -n 1 basename))
for i in "${!DUMPALL_FILES[@]}"; do
  echo "$((i+1)). ${DUMPALL_FILES[$i]}"
done

# Solicitar escolha do usuário
read -p "Escolha o número do backup completo que deseja restaurar: " DUMPALL_CHOICE

# Validar escolha do usuário
if [[ ! $DUMPALL_CHOICE =~ ^[0-9]+$ ]] || [ $DUMPALL_CHOICE -lt 1 ] || [ $DUMPALL_CHOICE -gt ${#DUMPALL_FILES[@]} ]; then
  echo "Escolha inválida. Saindo."
  exit 1
fi

# Definir o arquivo de dumpall escolhido
DUMPALL_FOLDER="${DUMPALL_FILES[$((DUMPALL_CHOICE-1))]}"
DUMPALL_FILE="$BACKUP_DIR_ALL/$DUMPALL_FOLDER/cluster.dump.sql"

# Restaurar o dumpall
echo "Restaurando backup completo da instância PostgreSQL..."
psql -U postgres -f "$DUMPALL_FILE"
verificar_erro "Restauração completa da instância"

echo "Restauração completa da instância concluída com sucesso!"