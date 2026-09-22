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
# Script: If lost connection, close some program
#
# Last update: 16/07/2026
#
time_sleep="5m" #5m # Time to sleep and test again
website_ping="google.com" # google.com # Website to test ping
program_kill=$1 # Program to close when lost connection
count_ping_send=3 #3 # Count of packets of ping to send

RED='\e[1;31m'
NC='\033[0m' # reset/no color

echo -e "\n # Script to test if has connection, if not, close some program #"

if [ "$program_kill" == '' ]; then
    echo -e "\nError: not passed the program to kill! Exiting...\n"
    exit 1
fi

while true; do
    ping_result=$(ping -c "$count_ping_send" "$website_ping" 2>&1)
    grep_failure=$(echo "$ping_result" | grep -E "Temporary failure in name resolution|100% packet loss")

    echo -e "\n Ping result: $ping_result\n"

    if [ "$grep_failure" != '' ]; then
        echo -e " $RED - Website unreachable - killall \"$program_kill\" -$NC\n"
        killall "$program_kill" # killall send by default SIGTERM - graceful shutdown
    fi

    echo -n " - Sleep time - ${time_sleep} - "
    date
    sleep ${time_sleep}
done
