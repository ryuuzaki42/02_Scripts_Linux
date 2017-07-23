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
# Script: in the KDE and XFCE, lock the session and suspend (allow insert X min before suspend)
#
# Last update: 23/07/2017
#
# Tip: Add a shortcut to this script
#
waitTimeToSuspend=$1 # Time before suspend in minutes

suspendCommand="dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend"

if echo "$waitTimeToSuspend" | grep -q -v "[[:digit:]]"; then
    waitTimeToSuspend='0'
fi

amixer set Master mute # Mute

xbacklight -set 1 # Set brightness to 1%

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

sleep 2s
xset dpms force off # Turn off the screen

if [ "$waitTimeToSuspend" != '0' ]; then
    notify-send "lock_screen_turn_off_suspend_JBs.sh" "System will suspend in ${waitTimeToSuspend} min $(echo; echo; date)"
    sleep "$waitTimeToSuspend"m

    if xset q | grep -q "Monitor is Off"; then
        $suspendCommand
    else
        notify-send "lock_screen_turn_off_suspend_JBs.sh" "System will not suspend because Monitor is On"
    fi
else
    $suspendCommand
fi
