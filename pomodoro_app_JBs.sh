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
# Script: aplicativo de pomodoro para terminal
#
# Last update: 19/06/2023
#
# Tip: Add a shortcut to this script
#
echo -e "\n # Pomodoro app #"

workTime=25 # Time in minutes
shortBreak=5
longBreak=15

startEnter() {
    echo -n "Press enter to start..."
    read -r
}

waitTime() {
    startEnter
    sleep "$1"m
}

messageShow() {
    echo -e "\n$1 - $2"
    notify-send "$1" "$2" -i "clock"

    waitTime $workTime
}

countPomodoro=1
while [ "$countPomodoro" -lt 6 ]; do
    messageShow "Work $countPomodoro - Pomodoro" "Start to work ($workTime min)"

    if [ "$countPomodoro" != 5 ]; then
        messageShow "Break $countPomodoro - Pomodoro" "short break ($shortBreak min)"
    else
        messageShow "Break $countPomodoro - Pomodoro" "long break ($longBreak min)"
    fi

    ((countPomodoro++))
done

echo -e "\n # Good work - Pomodoro End #\n"
notify-send "Pomodoro End" "Good Work" -i "clock"
