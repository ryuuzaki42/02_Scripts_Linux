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
# Script: Change the profile audio active
#
# Last update: 09/10/2022
#
# Tip: To list all profiles available use the command below
#pacmd list-cards | grep "output:" | grep -v "active"
#
# Stereo without input
#speakersAudio="output:analog-stereo"
#hdmiAudio="output:hdmi-stereo"

# Stereo with input
speakersAudio="output:analog-stereo+input:analog-stereo"   # Notebook audio
hdmiAudioA="output:hdmi-stereo-extra1+input:analog-stereo" # HDMI audio - starting with the cable not plugged
hdmiAudioB="output:hdmi-surround+input:analog-stereo"      # HDMI audio - starting with the cable plugged

profileActive=$(pacmd list-cards | grep "active profile" | sed 's/.*<//; s/>//') # Grep profile active

echo -e "Profile now active $profileActive"
echo -n "Profile changed to "

if echo "$profileActive" | grep -q "$speakersAudio"; then # Check if speakersAudio is active
    profilePriority=$(pacmd list-cards | grep $hdmiAudioA | head -n 1 | sed 's/.*priority //; s/, .*//' | wc -c)

    if [ "$profilePriority" == '6' ] ; then # > 33?633 = 6 numbers, if not = 5 numbers
        finalValue=$hdmiAudioA
#         echo -e "\\n\\n    hdmiAudioA\\n" # To test
    else
        finalValue=$hdmiAudioB
#         echo -e "\\n\\n    hdmiAudioB\\n" # To test
    fi
else
    finalValue=$speakersAudio
fi

pactl set-card-profile 0 $finalValue

# echo -e "$finalValue\\n" # To test
iconName="audio-volume-medium"

notify-send "Profile audio changed" "Final value $finalValue" -i $iconName
