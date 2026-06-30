#!/usr/bin/env bash

# --- Verificação de Dependências ---
# Verifica se o ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "Erro: 'ffmpeg' não está instalado."
    echo "Para instalar no Debian/Ubuntu: sudo apt install ffmpeg"
    echo "Para instalar no Fedora: sudo dnf install ffmpeg"
    exit 1
fi

# Verifica se o bc (calculadora) está instalado
if ! command -v bc &> /dev/null; then
    echo "Erro: 'bc' não está instalado."
    echo "Para instalar no Debian/Ubuntu: sudo apt install bc"
    echo "Para instalar no Fedora: sudo dnf install bc"
    exit 1
fi

# --- Entrada de Arquivo ---
# Verifica se o arquivo foi passado como argumento ou pede ao usuário
if [ -z "$1" ]; then
    read -p "Digite ou arraste o caminho do arquivo MKV de entrada: " -r ENTRADA
else
    ENTRADA="$1"
fi

# Remove aspas simples ou duplas que sobram ao arrastar o arquivo para o terminal
ENTRADA=$(echo "$ENTRADA" | sed -e "s/^'//" -e "s/'$//" -e 's/^"//' -e 's/"$//')

if [ ! -f "$ENTRADA" ]; then
    echo "Erro: Arquivo não encontrado!"
    exit 1
fi

# Extrai o nome base e a extensão
DIRETORIO=$(dirname "$ENTRADA")
NOME_COMPLETO=$(basename "$ENTRADA")
NOME_BASE="${NOME_COMPLETO%.*}"
EXTENSAO="${NOME_COMPLETO##*.}"

# --- Entrada do Tempo de Divisão ---
read -p "Dividir a cada quantos minutos? " MINUTOS

# Validação simples se é um número
if ! [[ "$MINUTOS" =~ ^[0-9]+$ ]] || [ "$MINUTOS" -le 0 ]; then
    echo "Erro: Por favor, insira um número inteiro válido maior que zero."
    exit 1
fi

# Converte minutos para segundos
TEMPO_SEG=$(($MINUTOS * 60))

# --- Cálculos de Duração ---
# Obtém a duração total do vídeo em segundos usando o ffprobe
DURACAO_TOTAL=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$ENTRADA")

# Arredonda a duração para cima usando o bc
DURACAO_TOTAL_INT=$(echo "$DURACAO_TOTAL / 1" | bc)

# Calcula o total de partes (Y)
TOTAL_PARTES=$(echo "$DURACAO_TOTAL_INT / $TEMPO_SEG" | bc)
SOBRA=$(echo "$DURACAO_TOTAL_INT % $TEMPO_SEG" | bc)

if [ "$SOBRA" -gt 0 ]; then
    TOTAL_PARTES=$((TOTAL_PARTES + 1))
fi

echo "---"
echo "Duração total do vídeo: ${DURACAO_TOTAL_INT}s"
echo "O vídeo será dividido em $TOTAL_PARTES parte(s) de até ${MINUTOS} minuto(s)."
echo "---"

# --- Processo de Divisão ---
PARTE=1
INICIO=0

while [ $PARTE -le $TOTAL_PARTES ]; do
    # Formata o nome de saída conforme solicitado: NomeOriginal-parteXdeY.mkv
    ARQUIVO_SAIDA="${DIRETORIO}/${NOME_BASE}-parte${PARTE}de${TOTAL_PARTES}.${EXTENSAO}"
    
    echo "Processando a parte $PARTE de $TOTAL_PARTES..."
    
    # Executa o FFmpeg usando stream copy (-c copy) para velocidade máxima
    ffmpeg -v warning -ss "$INICIO" -i "$ENTRADA" -t "$TEMPO_SEG" -c copy -map 0 "$ARQUIVO_SAIDA"
    
    # Incrementa para a próxima parte
    INICIO=$((INICIO + TEMPO_SEG))
    PARTE=$((PARTE + 1))
done

echo "---"
echo "Processo concluído com sucesso!"

