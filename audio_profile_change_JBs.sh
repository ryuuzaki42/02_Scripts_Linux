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
# Last update: 12/11/2019
#
#Tip: To list all profiles available use the command below
#pacmd list-cards | grep "output:" | grep -v "active"

# Stereo without input
#speakersAudio="output:analog-stereo"
#hdmiAudio="output:hdmi-stereo"

# Stereo with input
speakersAudio="output:analog-stereo+input:analog-stereo"
hdmiAudio="output:hdmi-stereo-extra1+input:analog-stereo"

profileActive=$(pacmd list-cards | grep "active profile" | tr -d "[:space:]" | cut -d '<' -f2 | cut -d '>' -f1)

echo -e "Profile now active $profileActive"
echo -n "Profile changed to "

if echo "$profileActive" | grep -q "$speakersAudio"; then
    pactl set-card-profile 0 "$hdmiAudio"

    finalValue=$hdmiAudio
else
    pactl set-card-profile 0 "$speakersAudio"

    finalValue=$speakersAudio
fi

echo "$finalValue"
iconName="audio-volume-medium"

notify-send "Profile audio changed" "Final value $finalValue" -i $iconName
