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
# Script: On keyboard with brightness is activated on scroll lock, enable an disable in turn
#
# Tip: Add a shortcut to this script
#
# Last update: 08/05/2026
#
value_brightness=$(cat /sys/class/leds/input0::scrolllock/brightness)
if [ "$value_brightness" == 0 ]; then
    xset led named "Scroll Lock"
else
    xset -led named "Scroll Lock"
fi
