#!/bin/bash

# Diretórios conforme seu workflow de portabilidade
LIB_DIR="$HOME/temas-biblioteca"
THEME_DIR="$HOME/.themes"

# Garante que a pasta de destino exista
mkdir -p "$THEME_DIR"

echo "Iniciando a instalação local dos temas..."
echo "--------------------------------------------------------"

cd "$LIB_DIR" || { echo "Erro: Pasta $LIB_DIR não encontrada."; exit 1; }

# 1. WhiteSur Dark (Requer execução do script interno para variantes)
if [ -d "WhiteSur-gtk-theme" ]; then
    echo "Instalando WhiteSur (Estética macOS)..."
    cd WhiteSur-gtk-theme
    # -d aponta para sua pasta local; -c Dark define o modo escuro
    ./install.sh -d "$THEME_DIR" -c Dark -i apple -t all
    cd ..
fi

# 2. Graphite Dark (Requer script interno)
if [ -d "Graphite-gtk-theme" ]; then
    echo "Instalando Graphite Dark..."
    cd Graphite-gtk-theme
    ./install.sh -d "$THEME_DIR" -c dark
    cd ..
fi

# 3. Nordic (Instalação via cópia direta da pasta)
if [ -d "Nordic" ]; then
    echo "Instalando Nordic..."
    cp -rf Nordic "$THEME_DIR/"
fi

# 4. Arc Theme
if [ -d "arc-theme" ]; then
    echo "Instalando Arc Dark..."
    # Nota: Se o git clone trouxer apenas o source, a cópia manual funciona para os assets básicos
    cp -rf arc-theme "$THEME_DIR/"
fi

# 5. Catppuccin
if [ -d "Catppuccin" ]; then
    echo "Instalando Catppuccin..."
    cp -rf Catppuccin "$THEME_DIR/"
fi

echo "--------------------------------------------------------"
echo "Instalação concluída!"
echo "Agora você pode selecionar os temas em: Configurações do Sistema -> Temas."