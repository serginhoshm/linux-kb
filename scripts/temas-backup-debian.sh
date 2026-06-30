#!/bin/bash

# Define o nome do arquivo de backup com a data atual
DATA=$(date +%Y-%m-%d)
ARQUIVO_BACKUP="$HOME/Downloads/backup_temas_icones_$DATA.zip"
PASTA_TMP=$(mktemp -d)

echo "===================================================="
echo "  Criador de Backup: Temas e Ícones Customizados    "
echo "===================================================="

# Função para copiar itens se a pasta existir e não estiver vazia
copiar_para_backup() {
    local pasta_origem="$1"
    local nome_destino="$2"
    
    if [ -d "$pasta_origem" ] && [ "$(ls -A "$pasta_origem")" ]; then
        echo "📂 Coletando arquivos de: $pasta_origem..."
        mkdir -p "$PASTA_TMP/$nome_destino"
        cp -r "$pasta_origem"/* "$PASTA_TMP/$nome_destino/"
    else
        echo "⚠️  Aviso: Pasta $pasta_origem não encontrada ou vazia. Pulando..."
    fi
}

# 1. Coleta de Ícones (Locais do usuário)
copiar_para_backup "$HOME/.icons" "icones"
copiar_para_backup "$HOME/.local/share/icons" "icones"

# 2. Coleta de Temas de Janela e Área de Trabalho (Locais do usuário)
copiar_para_backup "$HOME/.themes" "temas"
copiar_para_backup "$HOME/.local/share/themes" "temas"

# 3. Verificar se algo foi coletado antes de compactar
if [ -d "$PASTA_TMP/icones" ] || [ -d "$PASTA_TMP/temas" ]; then
    echo "🤐 Compactando arquivos em um arquivo ZIP..."
    
    # Garante que temos o 'zip' instalado no Debian
    if ! command -v zip &> /dev/null; then
        echo "🔧 O comando 'zip' não foi encontrado. Instalando via apt (pode pedir sua senha do sudo)..."
        sudo apt update && sudo apt install zip -y
    fi
    
    # Entra na pasta temporária para o ZIP não herdar caminhos absolutos longos
    cd "$PASTA_TMP"
    zip -r "$ARQUIVO_BACKUP" icones temas > /dev/null
    
    echo "===================================================="
    echo "✅ Backup criado com sucesso!"
    echo "📦 Salvo em: $ARQUIVO_BACKUP"
    echo "===================================================="
else
    echo "❌ Erro: Nenhuma pasta de temas ou ícones customizados continha arquivos."
    echo "O backup não foi gerado."
fi

# Limpeza da pasta temporária
rm -rf "$PASTA_TMP"