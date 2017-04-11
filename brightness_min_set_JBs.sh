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
# Script: Keep the brightness up to 1%
#
# Last update: 11/04/2017
#
sleepTime='5' # in seconds
brightnessValueSet="50" # brightness mim value to be set ~ 1%

if [ -f /sys/class/backlight/acpi_video0/brightness ]; then # Choose the your path from "files brightness"
    pathFile="/sys/class/backlight/acpi_video0"
elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
    pathFile="/sys/class/backlight/intel_backlight"
else
    echo -e "\n\tError, file to set brightness not found"
fi

if [ "$pathFile" != '' ]; then
    while true; do
        brightnessValue=$(cat $pathFile/brightness)
        #echo "Actual brightness: $brightnessValue"

        if [ "$brightnessValue" -lt "$brightnessValueSet" ]; then
            echo "$brightnessValueSet" > "$pathFile/brightness"
            #echo "Setting brightness value: $brightnessValueSet"
        fi

        sleep "$sleepTime"s
    done
fi
