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
# #echo $(( ($(date --date="031122" +%s) - $(date --date="031120" +%s) )/(60*60*24) ))
# #date -d @$(date +%s -d "221122 10:59")
#
# Script: Run command at the timer ends
#
# Last update: 12/12/2022
#
echo -e "\\n # Timer countdown until a end time/date #"

echo -e  "\\nSupport:"
echo -e "    Date   : \"%y%m%d %H%M\" or %H:M"
echo -e "    Command: \"command file\" or command"

echo -e "\\nExamples:"
echo -e "   $(basename "$0") \"230113 12:00\" \"vlc music.mp3\""
echo -e "   $(basename "$0") 12:00 vlc"

# Format "%y%m%d %H%M"
date_now=$(date "+%y%m%d %H:%M")

date_end=$1
echo -e "\\nInput date: \"$1\" _ command: \"$2\""

if [ "$date_end" == '' ]; then
    echo -en "\\nInsert the date/time to timer ends: "
    read -r date_end
fi

if ! echo -e "$date_end" | grep -q " "; then # Add %y%m%d to date_end with only %H%M
    date_tmp=$(date +%y%m%d)
    date_end="$date_tmp $date_end"
fi
echo -e "\\ndate_end   : \"$date_end\""

command_run=$2
if [ "$command_run" == '' ]; then
    echo -en "\\nInsert the command to run after timer ends: "
    read -r command_run
fi
echo "command_run: \"$command_run\""

date_now_sec=$(date +%s -d "$date_now")
date_end_sec=$(date +%s -d "$date_end")

date_diff_sec=$(echo "$date_end_sec - $date_now_sec" | bc)
date_diff_min=$(echo "scale=2; $date_diff_sec/60" | bc)
date_diff_hour=$(echo "scale=2; $date_diff_sec/3600" | bc)

if [ "$date_diff_sec" -lt '0' ]; then
    echo -e "\\n    Error: \$date_end ($date_end) is greater than \$date_now ($date_now)\\n"
else
    echo -e "\\n # date_diff_sec: ${date_diff_sec}s _ ${date_diff_min}m _ ${date_diff_hour}h #"

    notify-send "$(basename "$0")" "\\n-\\ndate_end: $date_end\\ncommand_run: $command_run\\n-
    \\ndate_diff_sec: ${date_diff_sec}s _ ${date_diff_min}m _ ${date_diff_hour}h" -i "clock"

    echo -en "\\nsleep ${date_diff_sec}s..."
    sleep "${date_diff_sec}"s # sleep $date_diff seconds

    $command_run # run the command
fi
