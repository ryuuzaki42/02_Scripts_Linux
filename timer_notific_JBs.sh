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
# Script: Run notification or command at the timer ends
#
# Last update: 10/04/2026
#
echo -e "\n # Timer countdown until a end time/date #"
script_name=$(basename "$0")
date_now=$(date)

# Need sox and notify-send
default_notification="notify-send '$script_name' --expire-time=0 'Timer completed';
play -n synth -j 3 sin %3 sin %-2 sin %-5 sin %-9 sin %-14 sin %-21 fade h .01 2 1.5 \
delay 1.3 1 .76 .54 .27 remix - fade h 0 2.7 2.5 norm -1 2> /dev/null"

date_end=$1
command_run=$2
#test=1 # Only to test the code

help(){
    echo -e "\nSupport:
        Future date: \"%y%m%d %H%M:%S\", \"%H:%M:%S\", \"%H:%M\" or \"%H\"
        Now + time: + \"X hour Y min Z sec\" or: + \"Xh Ymin Zs\"
        default notification: d
        Or wit a command as 'notification': \"command file\" or: \"command\"

    Default notification:\n$default_notification

    Examples:
        $script_name \"20260413 12:21:45\" \"vlc music.mp3\"
            - run vlc with music.mp3 at 12:21:45 of day 13 month 01 year 2026\n
        $script_name 22:42 d
            - run 22:42 of today using default notification\n
        $script_name 12 ark
            - run ark at 12 hours of today - midday\n
        $script_name + \"2 hour 7 min 3 sec\" d
            - run in 2 hour 7 minutes 3 seconds using default notification\n
        $script_name + \"2h 7m 3s\" vlc
            - run vlc in 2 hour 7 minutes 3 seconds\n
        $script_name + \"10 min 30 sec\" firefox
            - run firefox in 10 minutes and 30 seconds\n
        $script_name + \"20m\" d
            - run in 20 minutes using default notification\n
        test=\"1\" $script_name + \"45 sec\" d
            - run using test (print more information) in 45 seconds using default notification\n"
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
        command_run=$(echo "$command_run" | sed 's/s$/sec/; s/m /min /; s/m$/min/; s/h /hour /; s/h$/hour/')
        echo -e "\nNow + time: \"$command_run\""

        date_end=$(date -d "$command_run")
        command_run=$3
    ;;
esac

if ! echo -e "$date_end" | grep -q " "; then # Add %y%m%d to $date_end with only %H%M
    date_end="$(date +%y%m%d) $date_end"
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

echo -e "\ndate_now: $date_now"
echo "date_end: $date_end"

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
    notify-send "$script_name" "\n-\nTimer: $date_diff_sec s - $date_diff_min m - $date_diff_hour h" -i "clock"

    echo -en "\nsleep $date_diff_sec s ..."
    sleep "$date_diff_sec"s # sleep $date_diff seconds

    echo -e "\n\ncommand_run: $command_run"
    eval "$command_run" # run the command
fi
echo
