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
# Script: Change the profile audio active
#
# Last update: 19/03/2026
#
# Tip: To list all profiles available use the command below
# pacmd list-cards | grep "output:" | grep -v "active"
#

output_to_set=$1 # Set the output as Speakers or HDMI
output_to_set=${output_to_set^^} #uppercase
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
speakers_Audio="output:analog-stereo+input:analog-stereo"   # Notebook audio
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
