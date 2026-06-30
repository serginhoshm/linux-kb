#!/bin/bash
echo "Aplicando configurações de fontes para o Cinnamon..."
echo "--------------------------------------------------------"
# 1. Configuração das Famílias de Fontes
# Default font
gsettings set org.cinnamon.desktop.interface font-name "SF Pro Display Regular 11"

# Desktop font
gsettings set org.cinnamon.desktop.interface desktop-font-name "SF Pro Display Regular 11"

# Document font
gsettings set org.cinnamon.desktop.interface document-font-name "New York Regular 11"

# Monospace font (A que altera o Nemo)
gsettings set org.cinnamon.desktop.interface monospace-font-name "SF Mono Regular 11"

# Window title font
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "SF Pro Display Bold 11"

# 2. Configurações de Renderização (Font Settings)
# Text scaling factor
gsettings set org.cinnamon.desktop.interface text-scaling-factor 1.0

# Hinting (Slight)
gsettings set org.cinnamon.desktop.interface font-hinting 'slight'

# Antialiasing (Rgba)
gsettings set org.cinnamon.desktop.interface font-antialiasing 'rgba'

# RGBA Order (RGB)
gsettings set org.cinnamon.desktop.interface font-rgba-order 'rgb'

echo "Configurações aplicadas com sucesso!"
echo "Caso as mudanças não apareçam imediatamente, pressione Ctrl+Alt+Esc para recarregar o Cinnamon."
