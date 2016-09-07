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
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: limpa o swap de tempo em tempos ($timeToClean), padrão é 50 segundos
#
# Última atualização: 07/09/2016
#
timeToClean=50 # Em segundos

testSwap=`free -m | grep Swap | awk '{print $2}'`
if [ $testSwap -eq 0 ]; then
    echo -e "\n\n\tError: Swap is not configured in this computer!\n"
    exit 1
fi

while true; do
    echo -e "\n\tCleaning the Swap\n"

    memoryFree=`free -m | grep Mem | awk '{print ($4/$2) * 100}' | cut -d"." -f1`
    swapFree=`free -m | grep Swap | awk '{print ($4/$2) * 100}' | cut -d"." -f1`
    swapUse=$((100 - $swapFree))

    echo "Memory free: $memoryFree %"
    echo "Swap use: $swapUse %"
    echo "Date: `date`"

    if [ $memoryFree -gt 20 ]; then
        if [ $swapUse -gt 0 ]; then
            echo
            su - root -c 'echo "...please wait..."
            swapoff -a
            swapon -a'
        fi
    fi

    sleep "$timeToClean"s;
done
#