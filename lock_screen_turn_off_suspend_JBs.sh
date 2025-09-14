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
# Script: in the KDE and XFCE, lock the session and suspend (allow insert X min before suspend)
# Has options $mute_audio to mute audio and $reduce_brightness to reduce brightness
#
# Last update: 14/09/2025
#
# Tip: Add a shortcut to this script
#
wait_time_to_suspend=${1:-'0'} # Time before suspend in minutes, default is 0 minutes

mute_audio=${2:-'n'}        # Not mute by default
reduce_brightness=${3:-'n'} # Not reduce the brightness by default
disconnect_wifi=${4:-'y'}   # Disconnect the Wi-Fi by default

suspend_command="qdbus --print-reply --system org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Suspend true"

if echo "$wait_time_to_suspend" | grep -q -v "[[:digit:]]"; then
    wait_time_to_suspend=0
fi

if [ "$mute_audio" == "y" ]; then
    amixer set Master mute # Mute
    echo " # Muted Master audio #"
fi

if [ "$reduce_brightness" == "y" ]; then
    xbacklight -set 1 # Set brightness to 1%
    echo " # Reduce brightness to 1% #"
fi

desktopGUI=$XDG_CURRENT_DESKTOP
desktopGUI=${desktopGUI,,} # Convert to lower case

if [ "$desktopGUI" == "xfce" ]; then
    xflock4 # Lock the session in the XFCE
elif [ "$desktopGUI" == "kde" ]; then
    qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock # Lock the session in the KDE
else
    echo -e "\nError: The variable \"\$desktopGUI\" is not set.\n"
    exit 1
fi

if [ "$disconnect_wifi" == "y" ]; then
    wifi_card_name=$(grep ":" /proc/net/wireless | cut -d ':' -f1 | cut -d ' ' -f2)
    nmcli d disconnect "$wifi_card_name"
    echo " # Disconnect Wi-Fi: $wifi_card_name #"
fi

sleep 2s
xset dpms force off
echo " # Turn off the screen #"

if [ "$wait_time_suspend" != 0 ]; then
    script_name=$0
    notify-send "$script_name" "System will suspend in ${wait_time_to_suspend} min $(echo; echo; date)"
    sleep "$wait_time_to_suspend"m

    if xset q | grep -q "Monitor is Off"; then
        $suspend_command
    else
        notify-send "$script_name" "System will not suspend because Monitor is On"
    fi
else
    $suspend_command
fi
