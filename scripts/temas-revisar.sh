#!/bin/bash

# Definindo o diretório da biblioteca no seu porto seguro (~/)
LIB_DIR="$HOME/temas-biblioteca"

# Criando a pasta se ela não existir
mkdir -p "$LIB_DIR"
cd "$LIB_DIR" || exit

echo "Iniciando o download dos temas para a biblioteca: $LIB_DIR"
echo "--------------------------------------------------------"

# 1. WhiteSur Dark (Estética macOS/Cupertino)
echo "Baixando WhiteSur..."
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git

# 2. Nordic (Paleta profissional Nord)
echo "Baixando Nordic..."
git clone https://github.com/EliverLara/Nordic.git

# 3. Arc Dark (Clássico e estável)
echo "Baixando Arc Theme..."
git clone https://github.com/jnsh/arc-theme.git

# 4. Catppuccin (Mocha/Macchiato)
echo "Baixando Catppuccin..."
git clone https://github.com/catppuccin/gtk.git Catppuccin

# 5. Graphite Dark (Elegante e sóbrio)
echo "Baixando Graphite..."
git clone https://github.com/vinceliuice/Graphite-gtk-theme.git

echo "--------------------------------------------------------"
echo "Downloads concluídos com sucesso em $LIB_DIR."
echo "Agora você pode revisar os arquivos antes de prosseguirmos com a instalação local."

