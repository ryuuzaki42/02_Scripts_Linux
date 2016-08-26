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
# Script: aplicativo de pomodoro para terminal
#
# Última atualização: 06/06/2016
#
# Dica: Adicione um atalho para este script
#
workTime=25 # Time in minutes
shortBreak=5
LongBreak=15
i=1

while [ $i -lt 5 ]; do
    if [ $i == 1 ]; then
        notify-send "Pomodoro $i" "Start to work ($workTime min)"
    else
        notify-send "Pomodoro $i" "Back to work (workTime min)"
    fi
    sleep $workTime\m

    if [ $i != 4 ]; then
        notify-send "Pomodoro $i" "short break (shortBreak min)"
        sleep shortBreak\m
    else
        notify-send "Pomodoro $i" "long break (LongBreak min)"
        sleep LongBreak\m
    fi

    ((i++))
done

notify-send "Good work" "Pomodoro End"
#