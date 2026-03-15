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
# Script: Clean some logs and cache from home folder ($HOME_USER) and /tmp/ folder
#
# Last update: 15/03/2026
#
# Tip: pass all to clean empty files and folder in /tmp/
#

HOME_USER=$HOME
CLEAN_ALL=$1

echo -e "\n # Script to clean some logs from home folder ($HOME_USER) and /tmp/ folder #\n"
echo -en "Continue? (y)es or (n)o (enter to continue): "
read -r continue_or_not

if [ "$continue_or_not" != 'y' ] && [ "$continue_or_not" != '' ]; then
    echo -e "\nJust exiting\n"
    exit 0
fi

HOME_USER=${HOME_USER::-1} # Remove last /

filesFoldersToRermove=("$HOME_USER/.cache/thumbnails/"
"$HOME_USER/.thumbnails/" # Dolphin
"$HOME_USER/.xsession-errors"
"$HOME_USER/.config/VirtualBox/*log*" # VirtualBox
"$HOME_USER/VirtualBox VMs/*/Logs/"
"/tmp/.vbox-*-ipc/"
"/tmp/vboxdrv-Module.symvers"
"$HOME_USER/.local/share/okular/docdata/*.xml" # Okular open file info/config (like last page viewed)
"$HOME_USER/.cache/vivaldi/Default/*Cache*" # Vivaldi
"$HOME_USER/.config/opera/Default/Service Worker/CacheStorage/" # Opera
"$HOME_USER/.cache/opera/Default/Cache/"
"$HOME_USER/.cache/opera/Default/Code Cache/"
"$HOME_USER/.cache/zotero/zotero/*/cache2/" # Zotero
"$HOME_USER/.mozilla/firefox/*/storage/default/http*/" # Firefox
"$HOME_USER/.mozilla/firefox/*/storage/default/file*/"
"$HOME_USER/.cache/mozilla/firefox/*/cache2/"
"/tmp/mozilla-temp*"
"$HOME_USER/.config/librewolf/librewolf/*/storage/default/http*/" # LibreWolf
"$HOME_USER/.config/librewolf/librewolf/*/storage/default/file*/"
"$HOME_USER/.cache/librewolf/*/cache2/"
"$HOME_USER/.config/discord/Cache/" # Discord
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/WebStorage/" # Teams AppImage
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/Cache/"
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/Code Cache/"
"/tmp/com.microsoft.teams.linux Crashes/"
"$HOME_USER/.wget-hsts" # Wget
"$HOME_USER/.cache/kioexec/krun/" # KIO from KDE
"/tmp/tmpaddon*" # Others
"/tmp/lastChance*"
"/tmp/qtsingleapp-*"
"/tmp/.ktorrent_kde4_*" # KTorrent
"/tmp/dropbox-antifreeze-*" # Dropbox
"/tmp/steam_chrome_shmem_uid*" # Steam
"/tmp/steam_chrome_overlay_uid*"
"/tmp/.com.valvesoftware.Steam.*"
"/tmp/steam*"
"/tmp/gameoverlayui.log*"
"/tmp/mastersingleapp-master*" # Master PDF Editor
"/tmp/.org.chromium.Chromium.*" # Chromium
"/tmp/.org.chromium.Chromium.*/"
"/tmp/OSL_PIPE_*_SingleOfficeIPC_*"
"/tmp/SBo/"
"/tmp/dumps/"
"/tmp/Temp-*/"
"/tmp/lu*.tmp/"
"/tmp/.esd-*/"
"/tmp/.wine-*" # Wine
"/tmp/runtime-*/"
"/tmp/hsperfdata_*/"
"/tmp/Slack Crashes/" # Slack
"/tmp/smartsynchronize-*/" # SmartSynchronize
"/tmp/org.cogroo.addon.*/" # CoGrOO LibreOffice addon
"/tmp/v8-compile-cache-*/"
"/tmp/eZtz0jVPqfxm0NLRhlfuznK8-TD-webview-*"
"/tmp/System.lua" # Lua
"/tmp/ksmserver.NAQOIo")

## Can be useful if add to filesFoldersToRermove
# "$HOME_USER/.cache/"
# "/tmp/plasma-csd-generator.*"
# "/tmp/plasma-csd-generator.*/"

## Important temporary files and folders - Do not delete
# /tmp/sddm-auth-*
# /tmp/xauth-*
# /tmp/xauth_*
# /tmp/.ICE-unix/
# /tmp/.X11-unix/

IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
for value in ${filesFoldersToRermove[*]}; do
    #echo -e "\n   # value: \"$value\" #"

    if echo "$value" | grep -v -q "web.whatsapp.com"; then
        # Show errors (files and folders not found)
        #rm -vr "$value"


        # Default - not show errors
        rm -fvr "$value"
    else
        echo -e "\n   # value: \"$value\" #"
        echo "Not removing whatsapp, like https+++web.whatsapp.com" # Need to re-link account
    fi
done

if [ "$CLEAN_ALL" == "all" ]; then # Delete .ICE-unix .X11-unix plasma-csd-generator.* sddm-auth*
    echo -en "\nDelete empty files/folders in /tmp/ folder. Continue? (y)es or (n)o: "
    read -r continue_or_not

    if [ "$continue_or_not" == 'y' ]; then
        # Delete empty (zero size) folder and files in /tmp/
        cd /tmp/ || exit

        find . -size 0 -print -delete
        find . -empty -print -delete

        echo -e "\n # Recommendation: Restart your system! #"
    else
        echo -e "\nJust exiting\n"
    fi
fi
echo -e "\nEnd of script!\n"
