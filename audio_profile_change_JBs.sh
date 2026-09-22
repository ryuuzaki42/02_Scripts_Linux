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
# Script: Change the profile audio active
#
# Last update: 19/03/2026
#
# Tips:
#    1. Pass Speakers or HDMI as a parameter to directly set the audio output
#    2. Pass 1 as a parameter to disable the notification
#    3. To list all profiles available, use:
#        pacmd list-cards | grep "output:" | grep -v "active"
#

output_to_set=$1 # Set the output as Speakers or HDMI
output_to_set=${output_to_set^^} # uppercase
if [ "$output_to_set" == "SPEAKERS" ] || [ "$output_to_set" == "HDMI" ]; then # Check is Speakers or HDMI
    shift
else
    output_to_set=''
fi

notification_Off=$1 # Pass 1 to disable the notification

# Stereo without input
#speakers_Audio="output:analog-stereo"
#HDMI_Audio="output:hdmi-stereo"

# Stereo with input
speakers_Audio="output:analog-stereo+input:analog-stereo"    # Notebook audio
HDMI_Audio_A="output:hdmi-stereo-extra1+input:analog-stereo" # HDMI audio - starting with the cable not plugged
HDMI_Audio_B="output:hdmi-surround+input:analog-stereo"      # HDMI audio - starting with the cable plugged

all_Outputs=$(pacmd list-cards | grep "output") # Grep all outputs

if [ "$output_to_set" != "" ];then
    if [ "$output_to_set" == "SPEAKERS" ];then
        profile_Active=$HDMI_Audio_A # Set to HDMI to change after to Speakers
    elif [ "$output_to_set" == "HDMI" ];then
        profile_Active=$speakers_Audio # Set to Speakers to change after to HDMI
    fi
fi # else profile_Active=""

if [ "$profile_Active" == "" ]; then
    profile_Active=$(echo "$all_Outputs" | grep "active profile" | sed 's/.*<//; s/>//') # Grep profile active
fi
echo -e "\nProfile active now: $profile_Active"
echo -n "Profile changed to: "

if echo "$profile_Active" | grep -q "$speakers_Audio"; then # Check if speakers_Audio is active
    profilePriority=$(echo "$all_Outputs" | grep $HDMI_Audio_A | head -n 1 | sed 's/.*priority //; s/, .*//' | wc -c)

    if [ "$profilePriority" == 6 ] ; then # > 33?633 = 6 numbers, if not = 5 numbers
        final_Value=$HDMI_Audio_A
        #echo -e "\n\n    HDMI_Audio_A\n" # To test
    else
        final_Value=$HDMI_Audio_B
        #echo -e "\n\n    HDMI_Audio_B\n" # To test
    fi
else
    final_Value=$speakers_Audio
fi

pactl set-card-profile 0 "$final_Value"
echo -e "$final_Value\n"

if [ "$notification_Off" != 1 ]; then
    icon_Name="audio-volume-medium"
    notify-send "Profile audio changed" "Final value $final_Value" -i $icon_Name
fi
