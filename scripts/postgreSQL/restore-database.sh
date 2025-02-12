#!/bin/bash

# Configurações
DB_NOME="educacional"  # Nome do banco de dados a ser restaurado
BACKUP_BASE_DIR="/var/backups/pgsql"  # Diretório base dos backups
PGMAJOR=12

# Diretório de backups
BACKUP_DIR="$BACKUP_BASE_DIR/$PGMAJOR/dump"

# Função para verificar erros
verificar_erro() {
  if [ $? -ne 0 ]; then
    echo "Erro: $1 falhou."
    exit 1
  fi
}

# Listar backups disponíveis
echo "Backups disponíveis:"
BACKUP_FOLDERS=($(ls -d $BACKUP_DIR/*/ | xargs -n 1 basename))
for i in "${!BACKUP_FOLDERS[@]}"; do
  echo "$((i+1)). ${BACKUP_FOLDERS[$i]}"
done

# Solicitar escolha do usuário
read -p "Escolha o número do backup que deseja restaurar: " BACKUP_CHOICE

# Validar escolha do usuário
if [[ ! $BACKUP_CHOICE =~ ^[0-9]+$ ]] || [ $BACKUP_CHOICE -lt 1 ] || [ $BACKUP_CHOICE -gt ${#BACKUP_FOLDERS[@]} ]; then
  echo "Escolha inválida. Saindo."
  exit 1
fi

# Definir a pasta de backup escolhida
BACKUP_FOLDER="${BACKUP_FOLDERS[$((BACKUP_CHOICE-1))]}"
BACKUP_DIR_DIR="$BACKUP_DIR/$BACKUP_FOLDER/dir"

# Criar o banco de dados (se não existir)
echo "Criando banco de dados '$DB_NOME'..."
createdb -U postgres "$DB_NOME"
verificar_erro "Criação do banco de dados"

# Restaurar backup em formato de diretório
echo "Restaurando backup em formato de diretório..."
echo "Usando backup da pasta: $BACKUP_DIR_DIR"
pg_restore -d "$DB_NOME" -j7 -Fd "$BACKUP_DIR_DIR"
verificar_erro "Restauração em formato de diretório"

echo "Restauração concluída com sucesso!"