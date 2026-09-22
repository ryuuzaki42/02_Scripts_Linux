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
# Script: Define a resolução padrão do monitor do notebook (LVDS1)
# para o padrão, caso o cabo do VGA1 ou HDMI1 seja removido
#
# Script: Sets the default resolution for the laptop monitor (LVDS1)
# if the VGA1 or HDMI1 cable is disconnected.
#
# Last update: 19/06/2023
#
echo -e "\n Sets the default resolution for the laptop monitor (LVDS1) if the VGA1 or HDMI1 cable is disconnected\n"

LVDS1_resolution=$(xrandr | grep "\\+" | grep -v "+0" | cut -d ' ' -f4 | sed -n "1p")

while true; do
    value=$(xrandr | grep "\\*+")
    if [ "$value" == '' ]; then
        xrandr --output LVDS1 --mode "$LVDS1_resolution" --primary
        xrandr --output VGA1 --off
        xrandr --output HDMI1 --off
    fi
    sleep 5s
done
