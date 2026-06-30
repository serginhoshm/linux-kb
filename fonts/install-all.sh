#!/usr/bin/env bash
set -euo pipefail

# Diretório onde as fontes serão instaladas
FONT_DIR="${HOME}/.local/share/fonts/macfonts"

# Diretório base do script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verifica se fc-cache está disponível (fontconfig)
if ! command -v fc-cache &>/dev/null; then
    echo "Instalando fontconfig..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y fontconfig
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y fontconfig
    else
        echo "Gerenciador de pacotes não suportado. Instale o fontconfig manualmente." >&2
        exit 1
    fi
fi

echo "Criando diretório de fontes: ${FONT_DIR}"
mkdir -p "${FONT_DIR}"

echo "Copiando fontes..."
find "${SCRIPT_DIR}" \( -name "*.otf" -o -name "*.ttf" \) \
    ! -path "${FONT_DIR}/*" \
    -exec cp -v {} "${FONT_DIR}/" \;

echo "Atualizando cache de fontes..."
fc-cache -fv "${FONT_DIR}"

echo ""
echo "Instalação concluída! Todas as fontes foram instaladas em: ${FONT_DIR}"
