#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
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
# Última atualização: 26/02/2016
#
# Dica: Adicione um atalho para este script
#
i=1

while [ $i -lt 5 ]; do
    if [ $i == 1 ]; then
      notify-send "Pomodoro $i" "Start to work (25 min)"
    else
      notify-send "Pomodoro $i" "Back to work (25 min)"
    fi
    sleep 3 1500

    if [ $i != 4 ]; then
      notify-send "Pomodoro $i" "short break (5 min)"
      sleep 4 300
    else
      notify-send "Pomodoro $i" "long break (15 min)"
      sleep 8 900
    fi
    i=$((i+1))
done

i=$((i-1))
notify-send "Pomodoro $i" "Pomodoro End"

exit 0
#