#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Script: limpa o swap de tempos em tempos ($timeToClean), padrão é 50 segundos
# Se memória livre maior que 20 % e swap em uso maior que 5 % => limpar swap
#
# Última atualização: 17/09/2016
#
timeToClean=50 # Em segundos

testSwap=`free -m | grep Swap | awk '{print $2}'`
if [ $testSwap -eq 0 ]; then
    echo -e "\n\n\tError: Swap is not configured in this computer!\n"
else
    while true; do
        echo -e "\n\tCleaning the Swap\n"

        memTotal=`free -m | grep Mem | awk '{print $2}'` # Get total of memory RAM
        memUsed=`free -m | grep Mem | awk '{print $3}'` # Get total of used memory RAM
        memUsedPercentage=`echo "scale=0; ($memUsed*100)/$memTotal" | bc` # Get the percentage "used/total", |valueI*100/valueF|
        echo "Memory used: ~ $memUsedPercentage % ($memUsed/$memTotal MiB)"

        swapTotal=`free -m | grep Swap | awk '{print $2}'`
        swapUsed=`free -m | grep Swap | awk '{print $3}'`
        swapUsedPercentage=`echo "scale=0; ($swapUsed*100)/$swapTotal" | bc`
        echo "Swap used: ~ $swapUsedPercentage % ($swapUsed/$swapTotal MiB)"

        echo -e "Date: `date`"
        if [ $memUsedPercentage -lt 80 ]; then
            if [ $swapUsed -gt 0 ]; then
                su - root -c 'echo -e "\nCleanning swap\nPlease wait..."
                swapoff -a
                swapon -a'
            fi
        fi
        echo -e "\nWaiting $timeToClean s to try again\n"
        sleep "$timeToClean"s;
    done
fi
