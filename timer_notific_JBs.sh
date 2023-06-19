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
# Last update: 19/06/2023
#
echo -e "\n # Timer countdown until a end time/date #"
script_name=$(basename "$0")

# Need sox and notify-send
default_notification="notify-send '$script_name' --expire-time=0 'Timer completed';
play -n synth 0.3 pluck A3 repeat 6 2> /dev/null"

date_end=$1
command_run=$2
#test=1 # Only to test the code

help(){
    echo -e "\nSupport:"
    echo -e "    Date: \"%y%m%d %H%M:%S\", \"%H:%M:%S\", \"%H:%M\" or \"%H\""
    echo -e "    Now + time: + \"X hour Y min Z sec\""
    echo -e "    Now + time: + \"Xh Ymin Zs\""
    echo -e "    Command: \"command file\" or command"
    echo -e "    d to default notification"

    echo -e "\nExamples:"
    echo -e "    $script_name \"230113 12:21:45\" \"vlc music.mp3\""
    echo -e "    $script_name 22:42 d"
    echo -e "    $script_name 12 ark"
    echo -e "    $script_name + \"2 hour 7 min 3 sec\" d"
    echo -e "    $script_name + \"2h 7min 3s\" vlc"
    echo -e "    $script_name + \"10 min 30 sec\" firefox"
    echo -e "    $script_name + \"10m\" d"
    echo -e "    test=\"1\" $script_name + \"45 sec\" d"

    echo -e "\ndefault_notification: $default_notification\n"
    exit 0
}

if [ "$test" == 1 ]; then # To test
    echo -e "\n - Test -"
    echo -e "Input date_end: \"$date_end\" - command_run: \"$command_run\""
    echo "\$1 \"$1\" \$2 \"$2\" \$3 \"$3\""
fi

input=$1
case $input in
    "--help" | "-h" | '' )
        help
    ;;

    '+') # of plus
        # Change s to sec, m to min, h to hour
        command_run=$(echo $command_run | sed 's/s$/sec/; s/m /min /; s/m$/min/; s/h /hour /; s/h$/hour/')
        echo -e "\nNow + time: \"$command_run\""

        date_end=$(date -d "$command_run")
        command_run=$3
    ;;
esac

date_now=$(date)

if [ "$date_end" == '' ]; then
    echo -en "\nInsert the date/time to timer ends: "
    read -r date_end
fi

if ! echo -e "$date_end" | grep -q " "; then # Add %y%m%d to date_end with only %H%M
    date_tmp=$(date +%y%m%d)
    date_end="$date_tmp $date_end"
    echo -e "\ndate_end: \"$date_end\""
fi

if [ "$command_run" == '' ]; then
    echo -en "\nInsert the command to run after timer ends (d or hit enter to \$default_notification): "
    read -r command_run

    if [ "$command_run" == '' ]; then
        command_run='d'
    fi
    echo -e "\ncommand_run: \"$command_run\""
fi

if [ "$command_run" == 'd' ]; then
    command_run=$default_notification
fi

date_now_sec=$(date +%s -d "$date_now")
date_end_sec=$(date +%s -d "$date_end")

date_diff_sec=$(echo "$date_end_sec - $date_now_sec" | bc)
date_diff_min=$(echo "scale=2; $date_diff_sec/60" | bc)
date_diff_hour=$(echo "scale=2; $date_diff_sec/3600" | bc)

if echo "$date_diff_hour > 1" | bc -l > /dev/null; then
    date_diff_hour="0$date_diff_hour" # Add 0 to begin of float number, like .1 to 0.1
fi

if [ "$date_diff_sec" -lt 0 ]; then
    echo -e "\n    # Error: \$date_end ($date_end) is greater than \$date_now ($date_now) #\n"
else
    echo -e "\n # Timer: $date_diff_sec s - $date_diff_min m - $date_diff_hour h #"

#     notify-send "$script_name" "\n-\ndate_end: $date_end\ncommand_run: $command_run\n-
#     \ndate_diff_sec: $date_diff_sec s - $date_diff_min m - $date_diff_hour h" -i "clock"

    notify-send "$script_name" "\n-\nTimer: $date_diff_sec s - $date_diff_min m - $date_diff_hour h" -i "clock"

    echo -en "\nsleep $date_diff_sec s ..."
    sleep "$date_diff_sec"s # sleep $date_diff seconds

    echo -e "\n\ncommand_run: $command_run"
    eval "$command_run" # run the command
fi
