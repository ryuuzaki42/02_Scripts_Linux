#!/usr/bin/env bash
# lightsOnPlusJb.sh

# Changed in 08/06/2016 by João Batista (joao42lbatista@gmail.com)

# based on
# Copyright (c) 2014 devkral at web de
# url: https://github.com/devkral/lightsonplus

# that was based on
# Copyright (c) 2011 iye.cba at gmail com
# url: https://github.com/iye/lightsOn
# This script is licensed under GNU GPL version 2.0 or above

# Description: Bash script that prevents the screensaver and display power
# management (DPMS) from being activated while watching fullscreen videos
# on Firefox, Chrome and Chromium. Media players like mplayer, VLC and minitube
# can also be detected.
# One of {x, k, gnome-}screensaver must be installed.

# HOW TO USE:
# "./lightsOnPlusJb.sh 120 &" will Check every 120 seconds if Mplayer,
# VLC, Firefox, Chromium or Chrome are fullscreen and delay screensaver and Power Management if so.
# You want the number of seconds to be ~10 seconds less than the time it takes
# your screensaver or Power Management to activate.
# If you don't pass an argument, the checks are done every 50 seconds.

# Select the programs to be checked
mplayer_detection=1
vlc_detection=1
totem_detection=1
firefox_flash_detection=1
chromium_flash_detection=1
chrome_app_detection=1
chrome_app_name="Netflix"
webkit_flash_detection=1 # untested
html5_detection=1 # actually check whether your browser is toggled fullscreen, so simply surfing in fullscreen triggers screensaver inhibition as well (work in progress)
steam_detection=0 # untested
minitube_detection=0 # untested
popcorn_detection=1
chrome_flash_detection=1

defaultdelay=50

realdisp=`echo "$DISPLAY" | cut -d. -f1`

inhibitfile="/tmp/lightsOnPlusJbinhibit-$UID-$realdisp"
pidfile="/tmp/lightsOnPlusJb-$UID-$realdisp.pid"

# YOU SHOULD NOT NEED TO MODIFY ANYTHING BELOW THIS LINE

pidcreate() { # pidlocking
    # just one instance can run simultaneously
    if [ ! -e "$pidfile" ]; then
        echo "$$" > "$pidfile"
    else
        if [ -d "/proc/$(cat "$pidfile")" ]; then
            echo "an other instance is running, abort!" >&2
            exit 1
        else
            echo "$$" > "$pidfile"
        fi
    fi
}

pidremove() {
    if [ ! -e "$pidfile" ]; then
        echo "error: missing pidfile" >&2
    elif [ ! -f "$pidfile" ]; then
        echo -e "error: \"$pidfile\" is not a file\n" >&2
    else
        if [ "$(cat "$pidfile")" != "$$" ]; then
            echo "an other instance is running, abort!" >&2
            exit 1
        else
            rm "$pidfile"
        fi
    fi
    exit 0
}

pidcreate
trap "pidremove" EXIT

# enumerate all the attached screens
displays=""
while read id; do
    displays="$displays $id"
done< <(xvinfo | sed -n 's/^screen #\([0-9]\+\)$/\1/p')

# Detect screensaver been used # pgrep cuts off last character
if [ `pgrep -l xscreensave | grep -wc xscreensave` -ge 1 ]; then
    screensaver="xscreensaver"
elif [ `pgrep -l gnome-screensave | grep -wc gnome-screensave` -ge 1 ] || [ `pgrep -l gnome-shel | grep -wc gnome-shel` -ge 1 ] ;then
    screensaver="gnome-screensaver"
# make sure that the command exists then execute
elif [ `which gnome-screensaver-command 2> /dev/null;echo $?` -eq 0 ] && [ `"$(which gnome-screensaver-command)" -q  | grep -c active` -ge 1 ]; then
    screensaver="gnome-screensaver"
elif [ `pgrep -l mate-screensave | grep -wc mate-screensave` -ge 1 ]; then
    screensaver="mate-screensaver"
elif [ `pgrep -l kscreensave | grep -wc kscreensave` -ge 1 ]; then
    screensaver="kscreensaver"
elif [ `pgrep -l xautoloc | grep -wc xautoloc` -ge 1 ]; then
    screensaver="xautolock"
elif [ `pgrep -l cinnamon-screen | grep -wc cinnamon-screen` -ge 1 ]; then
    screensaver="cinnamon-screensaver"
elif ls /usr/lib*/kde4/libexec/kscreenlocker* | grep -qc kscreenlocker*; then
    screensaver="kscreensaver"
else
    screensaver=""
    echo "No screensaver detected"
    exit 1
fi

checkFullscreen() {
    for display in $displays; do # loop through every display looking for a fullscreen window
        # get id of active window and clean output
        activ_win_id=`DISPLAY=$realdisp.${display} xprop -root _NET_ACTIVE_WINDOW`
        activ_win_id=${activ_win_id##*# }
        activ_win_id=${activ_win_id:0:9} # eliminate potentially trailing spaces

        top_win_id=`DISPLAY=$realdisp.${display} xprop -root _NET_CLIENT_LIST_STACKING`
        top_win_id=${activ_win_id##*, }
        top_win_id=${top_win_id:0:9} # eliminate potentially trailing spaces

        # Check if Active Window (the foremost window) is in fullscreen state
        if [ ${#activ_win_id} -eq 9 ]; then
            isActivWinFullscreen=`DISPLAY=$realdisp.${display} xprop -id $activ_win_id | grep _NET_WM_STATE_FULLSCREEN`
        else
            isActiveWinFullscreen=""
        fi
        if [ ${#top_win_id} -eq 9 ]; then
            isTopWinFullscreen=`DISPLAY=$realdisp.${display} xprop -id $top_win_id | grep _NET_WM_STATE_FULLSCREEN`
        else
            isTopWinFullscreen=""
        fi

        if [[ "$isActivWinFullscreen" = *NET_WM_STATE_FULLSCREEN* ]] || [[ "$isTopWinFullscreen" = *NET_WM_STATE_FULLSCREEN* ]]; then
            isAppRunning
            var=$?
            [ $var -eq 1 ] && delayScreensaver
        fi
    done
}

# check if active window is mplayer, vlc or firefox
# TODO only window name in the variable activ_win_id, not whole line.
# Then change IFs to detect more specifically the apps "<vlc>" and if process name exist

isAppRunning() {
    # Get title of active window
    activ_win_title=`xprop -id $activ_win_id | grep "WM_CLASS(STRING)"` # I used WM_NAME(STRING) before, WM_CLASS is more accurate.

    if [ $firefox_flash_detection == 1 ]; then
        if [[ "$activ_win_title" = *unknown* || "$activ_win_title" = *plugin-container* ]]; then
            # Check if plugin-container process is running, pgrep cuts off last character
            [ `ps faux | grep -c plugin-containe` -ge 2 ] && return 1
        fi
    fi

    if [ $chromium_flash_detection == 1 ]; then
        if [ "$activ_win_title" = *hromium* ]; then # Check if Chromium Flash process is running
            [ `ps faux | grep -c "(c|C)hromium --type=ppapi"` -ge 2 ] && return 1
        fi
    fi

    if [ $chrome_flash_detection == 1 ]; then
        if [ "$activ_win_title" = *hrome* ]; then # Check if Chrome flash is running (by cadejager)
            [ `ps faux | grep -c "(c|C)hrome --type=ppapi"` -ge 2 ] && return 1
        fi
    fi

    if [ $webkit_flash_detection == 1 ]; then
        if [ "$activ_win_title" = *WebKitPluginProcess* ]; then # Check if WebKit Flash process is running
            [ `ps faux | grep -c ".*WebKitPluginProcess.*flashp.*"` -ge 2 ] && (log "isAppRunning(): webkit flash fullscreen detected" && return 1)
        fi
    fi

    if [ $html5_detection == 1 ]; then
        # check if they are running.
        if [[ "$activ_win_title" = *hrome* || "$activ_win_title" = *hromium* || "$activ_win_title" = *irefox* || "$activ_win_title" = *epiphany* || "$activ_win_title" = *opera* ]]; then
            [[ `ps faux | grep -Ec "chrome|firefox|chromium|opera|epiphany"` -ge 2 ]] && return 1
        fi
    fi

    if [ $chrome_app_detection == 1 ]; then
        if [[ ! -z $chrome_app_name && "$activ_win_title" = *$chrome_app_name* ]]; then # check if google chrome is runnig in app mode
            [ `ps faux | grep -c "chrome --app"` -ge 2 ] && return 1
        fi
    fi

    if [ $mplayer_detection == 1 ]; then
        if [[ "$activ_win_title" = *mplayer* || "$activ_win_title" = *MPlayer* ]]; then # check if mplayer is running.
            [ `ps faux | grep -c mplayer` -ge 2 ] && return 1
        fi
    fi

    if [ $vlc_detection == 1 ]; then
        if [[ "$activ_win_title" = *vlc* || "$activ_win_title" = *VLC* ]]; then # check if vlc is running.
            [ `ps faux | grep -c vlc` -ge 2 ] && return 1
        fi
    fi

    if [ $totem_detection == 1 ]; then
        if [ "$activ_win_title" = *totem* ]; then # check if totem is running.
            [ `ps faux | grep -c totem` -ge 2 ] && return 1
        fi
    fi

    if [ $steam_detection == 1 ]; then
        if [ "$activ_win_title" = *steam* ]; then # check if steam is running.
            [ `ps faux | grep -c steam` -ge 2 ] && return 1
        fi
    fi

    if [ $minitube_detection == 1 ]; then
        if [ "$activ_win_title" = *minitube* ]; then # check if minitube is running.
            [ `ps faux | grep -c minitube` -ge 2 ] && (log "isAppRunning(): minitube fullscreen detected" && return 1)
        fi
    fi

    if [ $popcorn_detection == 1 ]; then
        if [ `xprop -id $activ_win_id | grep -cE "(p|P)opcorn"` -ge 2 ]; then # check if Popcorn is running.
            return 1
        fi
    fi

    return 0
}

delayScreensaver() {
    # reset inactivity time counter so screensaver is not started
    case $screensaver in
        "xscreensaver" )
            # This tells xscreensaver to pretend that there has just been user activity.
            # This means that if the screensaver is active
            # (the screen is blanked), then this command will cause the screen
            # to un-blank as if there had been keyboard or mouse activity.
            # If the screen is locked, then the password dialog will pop up first,
            # as usual. If the screen is not blanked, then this simulated user
            # activity will re-start the countdown (so, issuing the -deactivate
            # command periodically is one way to prevent the screen from blanking.)

            xscreensaver-command -deactivate > /dev/null;;
    "gnome-screensaver" )
            # new way, first try
            dbus-send --session --dest=org.freedesktop.ScreenSaver --reply-timeout=2000 --type=method_call /ScreenSaver org.freedesktop.ScreenSaver.SimulateUserActivity > /dev/null
            # old way second try
            dbus-send --session --type=method_call --dest=org.gnome.ScreenSaver --reply-timeout=20000 /org/gnome/ScreenSaver org.gnome.ScreenSaver.SimulateUserActivity > /dev/null;;
    "mate-screensaver" )
            mate-screensaver-command --poke > /dev/null;;
    "kscreensaver" )
        qdbus org.freedesktop.ScreenSaver /ScreenSaver SimulateUserActivity > /dev/null;;
    "cinnamon-screensaver" )
        # use standard inhibit message, maybe merge with gnome-screensaver
        dbus-send --session --dest=org.freedesktop.ScreenSaver --reply-timeout=2000 --type=method_call /ScreenSaver org.freedesktop.ScreenSaver.SimulateUserActivity > /dev/null;;
    "xautolock" )
        xautolock -disable
        xautolock -enable;;
    esac

    # Check if DPMS is on. If it is, deactivate and reactivate again. If it is not, do nothing.
    dpmsStatus=`xset -q | grep -c 'DPMS is Enabled'`
    [ $dpmsStatus == 1 ] && (xset -dpms && xset dpms)
}

help() {
    echo -e "\nUSAGE:    $ lighsonplus [FLAG1 ARG1] ... [FLAGn ARGn]"
    echo -e "FLAGS (ARGUMENTS must be 0 or 1, except stated otherwise):\n"
    echo "  -d,  --delay            Time interval in seconds, default is 50s"
    echo "  -mp, --mplayer          mplayer detection"
    echo "  -v,  --vlc              VLC detection"
    echo "  -t,  --totem            Totem detection"
    echo "  -ff, --firefox-flash    Firefox flash plugin detection"
    echo "  -cf, --chromium-flash   Chromium flash plugin detection"
    echo "  -ca, --chrome-app       Chrome app detection, app name must be passed"
    echo "  -wf, --webkit-flash     Webkit flash detection"
    echo "  -h5, --html5            HTML5 detection"
    echo "  -s,  --steam            Steam detection"
    echo -e "  -mt, --minitube         MiniTube detection\n"
}

# check if arguments are valid, default to 50s interval if none is given
delay=$defaultdelay

while [ ! -z $1 ]; do
    case $1 in
       "-d" | "--delay" )
            [[ $2 = *[^0-9]* ]] && echo "Invalid argument. Time in seconds expected after \"$1\" flag. Got \"$2\" " && exit 1 || delay=$2;;
       "-mp" | "--mplayer" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && mplayer_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-v" | "--vlc" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && vlc_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-t" | "--totem" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && totem_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-ff" | "--firefox-flash" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && firefox_flash_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-cf" | "--chromium-flash" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && chromium_flash_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        # passing an app name suffices to activate chrome app detection
        "-ca" | "--chrome-app" )
            [ ! -z $2 ] && (chrome_app_detection=$1 && chrome_app_name="$2") || (echo "Missing argument. Chrome app name expected after \"$1\" flag." && exit 1);;
        "-wf" | "--webkit-flash" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && webkit_flash_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-h5" | "--html5" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && html5_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-s" | "--steam" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && steam_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-mt" | "--minitube" )
            [[ $2 -eq 1 || $2 -eq 0 ]] && minitube_detection=$2 || (echo "Invalid argument. 0 or 1 expected after \"$1\" flag." && exit 1);;
        "-h" | "--help" )
            help && exit 0;;
        * )
            echo "Ivalid argument. See -h, --help for more information." && exit 1;;
    esac
    shift 2 # arguments must be always passed in tuples
done

while true; do
    [ -f "$inhibitfile" ] && delayScreensaver || checkFullscreen
    sleep $delay
done
