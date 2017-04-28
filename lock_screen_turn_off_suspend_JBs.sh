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
# Last update: 27/04/2017
#
# Tip: Add a shortcut to this script
#
waitTimeToSuspend=$1 # Time before suspend in minutes
if echo "$waitTimeToSuspend" | grep -q -v "[[:digit:]"; then
    waitTimeToSuspend='0'
fi

amixer set Master mute # Mute

if [ "$XDG_CURRENT_DESKTOP" = '' ]; then
    desktopGUI=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
else
    desktopGUI=$XDG_CURRENT_DESKTOP
fi

desktopGUI=${desktopGUI,,} # Convert to lower case

if [ "$desktopGUI" == "xfce" ]; then
    xflock4 # Lock the session in the XFCE
elif [ "$desktopGUI" == "kde" ]; then
    qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock # Lock the session in the KDE
fi

sleep 2s
xset dpms force off # Turn off the screen

if [ "$waitTimeToSuspend" != '0' ]; then
    notify-send "lock_screen_turn_off_suspend_JBs.sh" "System will syspend in ${waitTimeToSuspend} min $(echo; echo; date)"
    sleep "$waitTimeToSuspend"m
fi

if xset q | grep -q "Monitor is Off"; then
    dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend # Suspend
fi
