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
# Script: Set the computer (notebook) to use less energy/battery as possible
# Mute the sound, brightness in 1% and CPU frequency in minimum available
# If CPU frequency is already in powersave, will set to performance
#
# Last update: 28/05/2017
#
if [ "$USER" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting\n"
else
    if cpufreq-info | grep "The governor" | head -n 1 | cut -d '"' -f2  | grep -q "performance"; then
        optionRun='1' # Will make all change
    else
        optionRun='2' # Will set cpu_frequency_scaling to performance
    fi

    cpu_frequency_scaling () {
        governorMode=$1

        ## Set CPU performance. See the actual governor # cpufreq-info
        ## http://docs.slackware.com/howtos:hardware:cpu_frequency_scaling

        countCPU=$(cpufreq-info | grep -c "analyzing CPU")
        i='0'
        while [ "$i" -lt "$countCPU" ]; do
            cpufreq-set --cpu $i --governor "$governorMode"
            ((i++))
        done

        echo -e "CPU frequency: $governorMode\n"
    }

    echo -e "\n# Changes made #"

    if [ "$optionRun" == '1' ]; then
        userNormal=$(w | awk '{print $1}' | grep -vE "root" | head -n 3 | tail -n 1) # Grep one normal user
        export soundDevice='0' # Device number
        su "$userNormal" -c "pactl set-sink-mute $soundDevice 1 > /dev/null" # Mute the device
        echo "Volume: muted"

        /usr/bin/usual_JBs.sh brigh-1 1 > /dev/null # Set brightness to 1%
        echo "Brightness: 1%"

        cpu_frequency_scaling powersave # This sets CPU frequency to the minimum available

    elif [ "$optionRun" == '2' ]; then
        cpu_frequency_scaling performance # This sets CPU frequency to the maximum available
    fi
fi
