# Autor: Vinicius Freire
# Função: soma 2 + 2 até chegar em 30

#!/bin/bash

echo 'Deseja realizar uma operação de loop finita?[s / n]' #Aqui, use aspas simples ''
read resposta

if [ $resposta = s ]; then # Início do comando IF
    soma=0
    while [ $soma -le 30 ]; do # Início do comando WHILE, use aspas duplas ""
        echo "$soma" # Também aspas duplas, escreva exatamente como está, senão ocorrerá erro
        soma=`expr $soma + 2` # Aqui, use o crase(`), senão ocorrerá erro
    done # Fim do while
else
    if [ $resposta != s ]; then
        echo 'Que pena! Fim do script.' # Aspas simples
    fi
fi
echo "Fim do scritp." # Aspas duplas
