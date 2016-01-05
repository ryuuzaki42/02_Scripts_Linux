# Autor: Vinicius Freire
# Função: soma 2 + 2 até chegar em 30

#!/bin/bash

echo 'Deseja realizar uma operação de loop finita?[s / n]' #Aqui, use aspas simples ''
read resposta

if [ $resposta = s ] #Inicio do comando IF
then
soma=0
while [ $soma -le 30 ] #Inicio do comando WHILE, use aspas duplas ""
do
echo "$soma" #também aspas duplas, escreva exatamente como está, senão ocorrerá erro
soma=`expr $soma + 2` #aqui, use o crase(`), senão ocorrerá erro
done #Fim do comando WHILE
echo "Fim do scritp." #aspas duplas

else
if [ $resposta != s ]
then
echo 'Que pena! Fim do script.' #aspas simples 
fi
fi #Fim do comando IF e do script
#