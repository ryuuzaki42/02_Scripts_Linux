#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Com contibuições de Rumbler Soppa (github.com/rumbler)
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
# Script: stopwatch and countdown function
# https://superuser.com/questions/611538
#
# Last update: 11/08/2023
#
stopwatch() {
    start=$(date +%s)
    while true; do
        time="$(( $(date +%s) - $start))"
        printf '   %s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 1s
    done
}

countdown() {
    time_value=$1
    start="$(( $(date '+%s') + $time_value))"
    while [ $start -ge $(date +%s) ]; do
        time="$(( $start - $(date +%s) ))"
        printf '   %s\r' "$(date -u -d "@$time" +%H:%M:%S)"
        sleep 1s
    done
}

help() {
    echo -e "\nHelp message:\nUsage: $0 [option]"
    echo -e " s        - Stopwatch"
    echo -e " c \"time\" - Countdown with \"time\" in seconds"
    echo -e " h        - Show this help message\n"
    exit 0
}

if [ "$#" -lt 1 ]; then
    echo -e "\n$(basename "$0"): Error - need the pass option"
    help
fi

option_value=$1
time_value=$2
case $option_value in
    's' )
        echo -e "\n   Stopwatch - Ctrl + C to terminate"
        stopwatch ;;
    'c' )
        echo -e "\n   Countdown of \"$time_value\" seconds"
        countdown "$time_value"
        echo -e "\n\n   End of countdown\n" ;;
    "h" )
        help ;;
    * )
        echo "Error: Not recognized option \"$option_value\"" ;;
esac
