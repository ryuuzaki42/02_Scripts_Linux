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
# Script: Keep the brightness up to 1%
#
# Last update: 19/06/2023
#
sleepTime=5 # in seconds
brightnessValueSet=50 # brightness mim value to be set ~ 1%

if [ -f /sys/class/backlight/acpi_video0/brightness ]; then # Choose the your path from "files brightness"
    pathFile="/sys/class/backlight/acpi_video0"
elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
    pathFile="/sys/class/backlight/intel_backlight"
else
    echo -e "\n\tError, file to set brightness not found"
fi

if [ "$pathFile" != '' ]; then
    while true; do
        brightnessValue=$(cat "$pathFile"/brightness)
        #echo "Actual brightness: $brightnessValue"

        if [ "$brightnessValue" -lt "$brightnessValueSet" ]; then
            echo "$brightnessValueSet" > "$pathFile/brightness"
            #echo "Setting brightness value: $brightnessValueSet"
        fi

        sleep "$sleepTime"s
    done
fi
