#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
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
# Script: aplicativo de pomodoro para terminal
#
# Last update: 28/08/2017
#
# Dica: Adicione um atalho para este script
#
echo -e "\\n # Pomodoro app #"

workTime="25" # Time in minutes
shortBreak='5'
longBreak="15"

startEnter() {
    echo -n "Press enter to start..."
    read -r
}

waitTime() {
    startEnter
    sleep "$1"m
}

messageShow() {
    echo -e "\\n$1 - $2"
    notify-send "$1" "$2" -i "clock"

    waitTime $workTime
}

countPomodoro='1'
while [ "$countPomodoro" -lt '6' ]; do
    messageShow "Work $countPomodoro - Pomodoro" "Start to work ($workTime min)"

    if [ "$countPomodoro" != '5' ]; then
        messageShow "Break $countPomodoro - Pomodoro" "short break ($shortBreak min)"
    else
        messageShow "Break $countPomodoro - Pomodoro" "long break ($longBreak min)"
    fi

    ((countPomodoro++))
done

echo -e "\\n # Good work - Pomodoro End #\\n"
notify-send "Pomodoro End" "Good Work" -i "clock"
