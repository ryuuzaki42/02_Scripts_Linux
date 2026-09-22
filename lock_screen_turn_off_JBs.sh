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
# Script: On KDE and XFCE, lock the session and turnoff the screen
# Has options $mute_audio to mute audio and $reduce_brightness to reduce brightness
#
# Last update: 15/03/2026
#
# Tip: Add a shortcut to this script
#
mute_audio=$1
reduce_brightness=$2

if [ "$mute_audio" == "y" ]; then
    amixer set Master mute # Mute
fi

if [ "$reduce_brightness" == "y" ]; then
    xbacklight -set 1 # Set brightness to 1%
fi

loginctl lock-session # Works with more desktop GUI

# desktopGUI=$XDG_CURRENT_DESKTOP
# desktopGUI=${desktopGUI,,} # Convert to lower case
#
# if [ "$desktopGUI" == "xfce" ]; then
#     xflock4 # Lock the session in the XFCE
# elif [ "$desktopGUI" == "kde" ]; then
#     qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock # Lock the session in the KDE
# else
#     echo -e "\nError: The variable \"\$desktopGUI\" is not set.\n"
#     exit 1
# fi

sleep 2s
xset dpms force off # Turn off the screen
