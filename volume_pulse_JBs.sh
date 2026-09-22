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
# Script: Change the volume percentage and send notification (if wanted)
#
# Last update: 19/06/2023
#
help() {
    echo -e "\nHelp message:\nUsage: $0 \"soundDevice\" [up|down|min|max|overmax]"
    echo -e "You can add 0 (zero) at the end the command to not send notification\n"
    echo -e "If not pass the \"soundDevice\", the script will try find to device in use\n"
    exit 0
}

if [ "$#" -lt 1 ]; then
    help
fi

soundDevice=$1 # Device number - Check with: aplay -l or pacmd list-sinks
optionValue=$2 # Option wanted - [up|down|min|max|overmax]
notification=$3 # Send notification? - If 0 will no send

volStepChange=5
maxVol=100
volCurrentPerc=$(pacmd list-sinks | grep "volume" | head -n 1 | cut -d '/' -f2 | cut -d '%' -f1 | tr -d "[:space:]")

if echo "$soundDevice" | grep -vq "[[:digit:]]"; then # Shift the value if soundDevice is not inserted
    soundDevice=$(pacmd list-sinks | grep "index" | cut -d ':' -f2 | tr -d "[:space:]")
    optionValue=$1
    notification=$2
fi

# If muted, unmute and finish
if pacmd list-sinks | grep -q "muted: yes"; then
    pactl set-sink-mute "$soundDevice" 0 > /dev/null # Unmute

    if [ "$notification" != 0 ]; then
        notify-send "Volume unmuted" "Volume value: $volCurrentPerc%" -i "audio-volume-medium"
    fi
    exit 0
fi

case $optionValue in
    "up" )
        volCurrentPerc=$((volCurrentPerc + volStepChange)) ;;
    "down" )
        skipOverCheck=1

        if [ "$volCurrentPerc" -gt "$volStepChange" ]; then
            volCurrentPerc=$((volCurrentPerc - volStepChange))
        else
            volCurrentPerc=0
        fi
        ;;
    "max" )
        volCurrentPerc=$maxVol ;;
    "min" )
        volCurrentPerc=0 ;;
    "overmax" )
        skipOverCheck=1

        if [ "$volCurrentPerc" -lt 100 ]; then
            volCurrentPerc=$maxVol
        else
            volCurrentPerc=$((volCurrentPerc + volStepChange))
        fi
        ;;
    * )
        help ;;
esac

if [ -z "$skipOverCheck" ]; then
    if [ "$volCurrentPerc" -gt "$maxVol" ]; then
        volCurrentPerc=$maxVol
    elif [ "$volCurrentPerc" -lt 0 ]; then
        volCurrentPerc=0
    fi
fi

pactl set-sink-volume "$soundDevice" "${volCurrentPerc}%" > /dev/null

if [ "$notification" != 0 ]; then
    if [ "$volCurrentPerc" == 0 ]; then
        iconName="audio-volume-muted"
    else
        if [ "$volCurrentPerc" -lt 33 ]; then
            iconName="audio-volume-low"
        else
            if [ "$volCurrentPerc" -lt 67 ]; then
                iconName="audio-volume-medium"
            else
                iconName="audio-volume-high"
            fi
        fi
    fi

    notify-send "Volume percentage change" "Final value: $volCurrentPerc %" -i $iconName
fi
