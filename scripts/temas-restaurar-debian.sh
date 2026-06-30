#!/bin/bash

# Interrompe o script se houver qualquer erro
set -e

PASTA_TMP=$(mktemp -d)
PASTA_ICONS="$HOME/.icons"
PASTA_THEMES="$HOME/.themes"

echo "===================================================="
echo "  Restaurador de Temas e Ícones Customizados        "
echo "===================================================="

# 1. Localizar o arquivo de backup mais recente na pasta Downloads
echo "🔍 Procurando o backup mais recente em ~/Downloads..."
ARQUIVO_BACKUP=$(ls -t $HOME/Downloads/backup_temas_icones_*.zip 2>/dev/null | head -n 1)

if [ -z "$ARQUIVO_BACKUP" ]; then
    echo "❌ Erro: Nenhum arquivo de backup encontrado em ~/Downloads."
    echo "Certifique-se de que o arquivo segue o padrão: backup_temas_icones_AAAA-MM-DD.zip"
    exit 1
fi

echo "📦 Backup encontrado: $(basename "$ARQUIVO_BACKUP")"

# Garantir que o comando 'unzip' está instalado
if ! command -v unzip &> /dev/null; then
    echo "🔧 O comando 'unzip' não foi encontrado. Instalando..."
    sudo apt update && sudo apt install unzip -y
fi

# 2. Extrair o backup na pasta temporária
echo "📦 Extraindo arquivos temporariamente..."
unzip -q "$ARQUIVO_BACKUP" -d "$PASTA_TMP"

# 3. Garantir que as pastas de destino do usuário existam
mkdir -p "$PASTA_ICONS"
mkdir -p "$PASTA_THEMES"

# 4. Restaurar os Ícones (Sobrescrevendo por padrão)
if [ -d "$PASTA_TMP/icones" ] && [ "$(ls -A "$PASTA_TMP/icones")" ]; then
    echo "🚚 Restaurando e sobrescrevendo ícones em $PASTA_ICONS..."
    # O 'cp -rf' força a cópia e o sobrescrevimento
    cp -rf "$PASTA_TMP/icones"/* "$PASTA_ICONS/"
else
    echo "ℹ️  Nenhum ícone customizado encontrado no backup para restaurar."
fi

# 5. Restaurar os Temas (Sobrescrevendo por padrão)
if [ -d "$PASTA_TMP/temas" ] && [ "$(ls -A "$PASTA_TMP/temas")" ]; then
    echo "🚚 Restaurando e sobrescrevendo temas em $PASTA_THEMES..."
    cp -rf "$PASTA_TMP/temas"/* "$PASTA_THEMES/"
else
    echo "ℹ️  Nenhum tema customizado encontrado no backup para restaurar."
fi

# Limpeza da pasta temporária
rm -rf "$PASTA_TMP"

echo "===================================================="
echo "✅ Restauração concluída com sucesso!"
echo "✨ Os arquivos foram sobrescritos nos diretórios originais."
echo "   Se os temas não atualizarem na hora, feche e abra"
echo "   a tela de Configurações de Temas do Cinnamon novamente."
echo "===================================================="