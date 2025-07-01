#!/bin/bash

# Verifica se dois argumentos foram passados
if [ "$#" -lt 3 ]; then
    echo "Uso: $0 <variavel_antiga> <nova_variavel> <arquivo1>"
    exit 1
fi

antigo="$1"
novo="$2"
arquivo1="$3"

# Lista de arquivos a alterar — você pode adaptar isso
arquivos=("tomasulo.v" "$arquivo1")

# Loop pelos arquivos
for arq in "${arquivos[@]}"; do
    if [ -f "$arq" ]; then
        sed -i "s/\b$antigo\b/$novo/g" "$arq"
        echo "Alterado em: $arq"
    else
        echo "Arquivo não encontrado: $arq"
    fi
done
