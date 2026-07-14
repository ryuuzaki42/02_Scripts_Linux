#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Script: If lost connection, close some program
#
# Last update: 14/07/2026

time_sleep="5m" #5m # Time to sleep and test again
website_ping="google.com" # google.com # Website to test ping
program_kill=$1 # Program to close when lost connection

RED='\e[1;31m'
NC='\033[0m' # reset/no color

echo -e "\n # Script to test if has connection, if not, close some program #"

if [ "$program_kill" == '' ]; then
    echo -e "\nError: not passed the program to kill! Exiting...\n"
    exit 1
fi

while true; do
    ping_result=$(ping -c 10 "$website_ping" 2>&1)
    grep_failure=$(echo "$ping_result" | grep -E "Temporary failure in name resolution|100% packet loss")

    echo -e "\n Ping result: $ping_result\n"

    if [ "$grep_failure" != '' ]; then
        echo " $RED - Website unreachable - killall \"$program_kill\" -$NC\n"
        killall "$program_kill" # killall send by default SIGTERM - graceful shutdown
    fi

    echo -n " - Sleep time - ${time_sleep} - "
    date
    sleep ${time_sleep}
done
