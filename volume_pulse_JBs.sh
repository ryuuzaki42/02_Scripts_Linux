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
# Script: Change the volume percentage and send notification (if wanted)
#
# Last update: 22/04/2018
#
help() {
    echo -e "\\nHelp message:\\nUsage: $0 \"soundDevice\" [up|down|min|max|overmax]"
    echo -e "You can add '0' (zero) at the end the command to not send notification\\n"
    echo -e "If not pass the \"soundDevice\", the script will try find to device in use\\n"
    exit 0
}

if [ "$#" -lt '1' ]; then
    help
fi

soundDevice=$1 # Device number - Check with: aplay -l or pacmd list-sinks
optionValue=$2 # Option wanted - [up|down|min|max|overmax]
notification=$3 # Send notification? - If 0 will no send

volStepChange='5'
maxVol="100"
volCurrentPerc=$(pacmd list-sinks | grep "volume" | head -n 1 | cut -d '/' -f2 | cut -d '%' -f1 | tr -d "[:space:]")

if echo "$soundDevice" | grep -vq "[[:digit:]]"; then # Shift the value if soundDevice is not inserted
    soundDevice=$(pacmd list-sinks | grep "index" | cut -d ':' -f2 | tr -d "[:space:]")
    optionValue=$1
    notification=$2
fi

# If muted, unmute and finish
if pacmd list-sinks | grep -q "muted: yes"; then
    pactl set-sink-mute "$soundDevice" 0 > /dev/null # Unmute

    if [ "$notification" != '0' ]; then
        notify-send "Volume unmuted" "Volume value: $volCurrentPerc%" -i "audio-volume-medium"
    fi
    exit 0
fi

case $optionValue in
    "up" )
        volCurrentPerc=$((volCurrentPerc + volStepChange)) ;;
    "down" )
        skipOverCheck='1'

        if [ "$volCurrentPerc" -gt "$volStepChange" ]; then
            volCurrentPerc=$((volCurrentPerc - volStepChange))
        else
            volCurrentPerc='0'
        fi
        ;;
    "max" )
        volCurrentPerc=$maxVol ;;
    "min" )
        volCurrentPerc='0' ;;
    "overmax" )
        skipOverCheck='1'

        if [ "$volCurrentPerc" -lt "100" ]; then
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
    elif [ "$volCurrentPerc" -lt '0' ]; then
        volCurrentPerc='0'
    fi
fi

pactl set-sink-volume "$soundDevice" "${volCurrentPerc}%" > /dev/null

if [ "$notification" != '0' ]; then
    if [ "$volCurrentPerc" == '0' ]; then
        iconName="audio-volume-muted"
    else
        if [ "$volCurrentPerc" -lt "33" ]; then
            iconName="audio-volume-low"
        else
            if [ "$volCurrentPerc" -lt "67" ]; then
                iconName="audio-volume-medium"
            else
                iconName="audio-volume-high"
            fi
        fi
    fi

    notify-send "Volume percentage change" "Final value: $volCurrentPerc%" -i $iconName
fi
