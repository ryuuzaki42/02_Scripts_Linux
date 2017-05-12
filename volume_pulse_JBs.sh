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
# Script: Change the volume percentage
#
# Last update: 12/05/2017
#

help () {
    echo "Usage: $0 \"soundDevice\" [up|down|min|max|overmax]"
    exit 1
}

if [ "$#" -ne '2' ]; then
    help
fi

soundDevice=$1 # Check with: aplay -l
optionValue=$2

volStepChange='5'
maxVol="100"
volCurrentPerc=$(pacmd list-sinks | grep "volume" | head -n 1 | cut -d '/' -f2 | cut -d '%' -f1 | tr -d "[:space:]")

case $optionValue in
    "up" )
        pactl set-sink-mute "$soundDevice" 0 > /dev/null # Unmute
        volCurrentPerc=$((volCurrentPerc + volStepChange)) ;;
    "down" )
        skipOverCheck='1'
        volCurrentPerc=$((volCurrentPerc - volStepChange)) ;;
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
    *)
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
