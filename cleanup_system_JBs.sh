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
# Last update: 09/07/2026
#
# Tip: pass all to clean empty files and folders in /tmp/
#
# Use: cleanup_system_JBs.sh 'username' 'continue_or_not_1' 'clean_all' 'continue_or_not_2'
# cleanup_system_JBs.sh j y all y
#

username=$1
continue_or_not_1=$2
clean_all=$3
continue_or_not_2=$4
only_test=$5 # To only show files that will be deleted

if [ "$username" != '' ]; then
    HOME_USER=$(eval echo ~$username) # Get user home path
else
    HOME_USER=$HOME
fi

echo -e "\n # Script to clean some logs from home folder ($HOME_USER) and /tmp/ folder #\n"

if [ "$only_test" != '' ]; then
    echo "\n# Test mode - files will not be deleted #\n"
    delete_file=''
else
    delete_file="-delete"
fi

echo -en "Be careful! Want to continue? (y)es or (n)o (hit enter to continue): "
if [ "$continue_or_not_1" == '' ]; then
    read -r continue_or_not_1
else
    echo -n "$continue_or_not_1"
fi

if [ "$continue_or_not_1" != 'y' ] && [ "$continue_or_not_1" != '' ]; then
    echo -e "\nJust exiting\n"
    exit 0
fi

HOME_USER=${HOME_USER::-1} # Remove last /

files_folders_remove=("$HOME_USER/.cache/thumbnails/"
"$HOME_USER/.thumbnails/" # Dolphin
"$HOME_USER/.xsession-errors"
"$HOME_USER/.config/VirtualBox/*.log*" # VirtualBox
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
"$HOME_USER/.mozilla/firefox/*/storage/default/https+++web.whatsapp.com/cache/"
"$HOME_USER/.cache/mozilla/firefox/*/cache2/"
"/tmp/mozilla-temp*"
"$HOME_USER/.config/librewolf/librewolf/*/storage/default/http*/" # LibreWolf
"$HOME_USER/.config/librewolf/librewolf/*/storage/default/file*/"
"$HOME_USER/.config/librewolf/librewolf/*/storage/default/https+++web.whatsapp.com/cache/"
"$HOME_USER/.cache/librewolf/*/cache2/"
"$HOME_USER/.config/discord/Cache/" # Discord
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/WebStorage/" # Teams AppImage
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/Cache/"
"$HOME_USER/.config/teams-for-linux/Partitions/teams-4-linux/Code Cache/"
"/tmp/com.microsoft.teams.linux Crashes/"
"$HOME_USER/.wget-hsts" # Wget
"$HOME_USER/.anydesk/thumbnails/" # AnyDesk
"$HOME_USER/.anydesk/AnyDesk/"
"$HOME_USER/.anydesk/cache/"
"$HOME_USER/.anydesk/global_cache/"
"$HOME_USER/.anydesk/incoming/"
"$HOME_USER/.anydesk/anydesk.trace"
"$HOME_USER/.anydesk/connection_trace.txt"
"/tmp/ad_gevt_*"
"/tmp/ad_mailbox_*"
"/tmp/ad_connect_queue_*"
"/tmp/anydesk/"
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
"/tmp/.org.chromium.Chromium.*/" # Chromium
"/tmp/.org.chromium.Chromium.*"
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
"/tmp/org.cogroo.addon.*/" # CoGrOO LibreOffice Addon
"/tmp/v8-compile-cache-*/"
"/tmp/eZtz0jVPqfxm0NLRhlfuznK8-TD-webview-*"
"/tmp/bOfimIG4WelHX1Z0zZUnw_le-TD-webview-*"
"/tmp/System.lua" # Lua
"/tmp/ksmserver.NAQOIo")

## Can be useful if add to $files_folders_remove
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
for files_folders_remove_tmp in "${files_folders_remove[@]}"; do
    echo -e "\n    # \"$files_folders_remove_tmp\" #"

    for value in $files_folders_remove_tmp; do
        echo -e "        # value: \"$value\" #"
        if [ "$only_test" != '' ]; then
            echo -e "# will remove \"$value\" #"
            continue
            exit 0
        fi

        if echo "$value" | grep -v -q "web.whatsapp.com"; then # Not remove WhatsApp Web
            # Show errors (files and folders not found)
            #rm -vr $value # Without quote to expand variable / globbing

            # Default - not show errors
            rm -fvr $value # Without quote to expand variable / globbing
        else
            if echo "$value" | grep -q "/cache/"; then # Remove cache from WhatsApp Web
                echo -e "\n    # Removing cache in: $value"
                rm -fvr "$value"
            else
                #echo -e "\n    # Value: \"$value\" #"
                echo "Not removing whatsapp, like https+++web.whatsapp.com" # Need to re-link account
            fi
        fi
    done
done

# Show all files/folders empty in /tmp/
#find /tmp/ -maxdepth 1 -empty -print

# Delete all files/folders empty in /tmp/
echo -e "\n    # Removing empty files in: /tmp/"
find /tmp/ -maxdepth 1 -empty -print $delete_file # -delete

if [ "$clean_all" == "all" ]; then # Delete .ICE-unix .X11-unix plasma-csd-generator.* sddm-auth*
    echo -en "\nDelete empty files/folders in /tmp/ folder. Continue? (y)es or (n)o: "
    if [ "$continue_or_not_2" == '' ]; then
        read -r continue_or_not_2
    else
        echo -n "$continue_or_not_2"
    fi

    if [ "$continue_or_not_2" == 'y' ]; then
        # Delete empty (zero size) folder and files in /tmp/
        find /tmp/ -empty -print $delete_file # -delete # Safer to remove empty files
        find /tmp/ -size 0b -print $delete_file # -delete # Remove files with 0b. Depend of block size

        echo -e "\n # Recommendation: Restart your system! #"
    else
        echo -e "\nJust exiting\n"
    fi
fi
echo -e "\nEnd of script!\n"
