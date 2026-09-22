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
# Script: stopwatch and countdown function
# https://superuser.com/questions/611538
#
# Last update: 08/03/2026
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
        if [ "$time_value" == '' ]; then
            echo -e "\n$(basename "$0") c : Error - need the \"time\" value in seconds"
            help
        else
            countdown "$time_value"
            echo -e "\n\n   End of countdown\n"
        fi ;;
    "h" )
        help ;;
    * )
        echo "Error: Not recognized option \"$option_value\"" ;;
esac
