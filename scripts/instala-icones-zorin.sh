#!/bin/bash

# Para o script se encontrar qualquer erro
set -e

PASTA_TMP=$(mktemp -d)
PASTA_ICONS="$HOME/.icons"

echo "===================================================="
echo "  Instalador de Ícones do Zorin OS para Debian       "
echo "===================================================="

# 1. Baixar o arquivo tarball do repositório oficial de ícones do Zorin
echo "📥 Baixando os ícones diretamente do repositório do Zorin OS..."
cd "$PASTA_TMP"

# Usando o espelho estável do GitHub/Launchpad para os pacotes de ícones do Zorin
curl -L -o zorin-icon-themes.tar.gz "https://github.com/ZorinOS/zorin-icon-themes/archive/refs/heads/master.tar.gz"

# 2. Extrair os arquivos
echo "📦 Extraindo arquivos..."
tar -xf zorin-icon-themes.tar.gz
cd zorin-icon-themes-master

# 3. Criar a pasta de destino se não existir
if [ ! -d "$PASTA_ICONS" ]; then
    echo "📂 Criando a pasta $PASTA_ICONS..."
    mkdir -p "$PASTA_ICONS"
fi

# 4. Mover as pastas de ícones para o diretório do usuário
echo "🚚 Instalando os temas de ícones..."
# O repositório armazena os ícones diretamente na raiz ou em pastas específicas. 
# Vamos mover apenas o diretório de ícones real.
cp -r Zorin* "$PASTA_ICONS/"

# Limpeza
echo "🧹 Limpando arquivos temporários..."
rm -rf "$PASTA_TMP"

echo "===================================================="
echo "✅ Ícones instalados com sucesso!"
echo "✨ Agora abra: Configurações do Sistema -> Temas -> Ícones"
echo "===================================================="
