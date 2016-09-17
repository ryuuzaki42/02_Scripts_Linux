#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para mais detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
#