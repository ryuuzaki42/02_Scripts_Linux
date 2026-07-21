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
# Script: Clean some logs and cache from home folder ($home_user) and /tmp/ folder
#
# Last update: 21/07/2026
#
# Tip: pass all to clean empty files and folders in /tmp/
#
# Use: cleanup_system_JBs.sh 'user_name' 'continue_or_not_1' 'clean_all' 'continue_or_not_2' 'only_test'
# All: cleanup_system_JBs.sh j y all y
# Test cleanup_system_JBs.sh j y all y test
#
user_name=$1
continue_or_not_1=$2
clean_all=$3
continue_or_not_2=$4
only_test=$5 # test # To only show files that will be deleted

echo -e "\n # Script to clean some logs from home folder and /tmp/ folder #\n"

if [ "$user_name" != '' ]; then
    if grep -q "^$user_name" /etc/passwd; then # Check if user exists
        home_user=$(eval echo "~$user_name") # Get user home path
    else
        echo -e "\n Error: the user \"$user_name\" not exists! Try again with another user\n"
        exit 1
    fi
else
    user_name=$(whoami)
    home_user=$HOME
fi

echo -e "- user_name: $user_name\n- home_user: $home_user\n"

if [ "$only_test" != '' ]; then
    echo -e "# Test mode - files will not be deleted #\n"
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

if echo "$home_user" | grep -q '/$'; then # Check if last character is '/'
    home_user=${home_user::-1} # Remove the last character - '/'
fi

files_folders_remove=("$home_user/.cache/thumbnails/"
"$home_user/.thumbnails/" # Dolphin
"$home_user/.xsession-errors"
"$home_user/.config/VirtualBox/*.log*" # VirtualBox
"$home_user/VirtualBox VMs/*/Logs/"
"/tmp/.vbox-*-ipc/"
"/tmp/vboxdrv-Module.symvers"
"$home_user/.local/share/okular/docdata/*.xml" # Okular open file info/config (like last page viewed)
"$home_user/.cache/vivaldi/Default/*Cache*" # Vivaldi
"$home_user/.config/opera/Default/Service Worker/CacheStorage/" # Opera
"$home_user/.cache/opera/Default/Cache/"
"$home_user/.cache/opera/Default/Code Cache/"
"$home_user/.cache/zotero/zotero/*/cache2/" # Zotero
"$home_user/.mozilla/firefox/*/storage/default/http*/" # Firefox
"$home_user/.mozilla/firefox/*/storage/default/file*/"
"$home_user/.mozilla/firefox/*/storage/default/https+++web.whatsapp.com/cache/"
"$home_user/.cache/mozilla/firefox/*/cache2/"
"/tmp/mozilla-temp*"
"$home_user/.config/librewolf/librewolf/*/storage/default/http*/" # LibreWolf
"$home_user/.config/librewolf/librewolf/*/storage/default/file*/"
"$home_user/.config/librewolf/librewolf/*/storage/default/https+++web.whatsapp.com/cache/"
"$home_user/.cache/librewolf/*/cache2/"
"$home_user/.config/discord/Cache/" # Discord
"$home_user/.config/teams-for-linux/Partitions/teams-4-linux/WebStorage/" # Teams AppImage
"$home_user/.config/teams-for-linux/Partitions/teams-4-linux/Cache/"
"$home_user/.config/teams-for-linux/Partitions/teams-4-linux/Code Cache/"
"/tmp/com.microsoft.teams.linux Crashes/"
"$home_user/.wget-hsts" # Wget
"$home_user/.anydesk/thumbnails/" # AnyDesk
"$home_user/.anydesk/AnyDesk/"
"$home_user/.anydesk/cache/"
"$home_user/.anydesk/global_cache/"
"$home_user/.anydesk/incoming/"
"$home_user/.anydesk/anydesk.trace"
"$home_user/.anydesk/connection_trace.txt"
"/tmp/ad_gevt_*"
"/tmp/ad_mailbox_*"
"/tmp/ad_connect_queue_*"
"/tmp/anydesk/"
"$home_user/.cache/kioexec/krun/" # KIO from KDE
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
"/tmp/create_ap.all.lock" # create_ap
"/tmp/System.lua" # Lua
"/tmp/ksmserver.NAQOIo")

## Can be useful if add to $files_folders_remove
# "$home_user/.cache/"
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
        #echo -e "        # value: \"$value\" #" # Disable by default

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
                echo -e "\n    # Value: \"$value\" #"
                echo " - Not removing whatsapp, like https+++web.whatsapp.com" # Need to re-link account
            fi
        fi
    done
done

# Show all files/folders empty in /tmp/ - '-maxdepth 1' to not recursively
#find /tmp/ -maxdepth 1 -empty -print

# Delete all files/folders empty in /tmp/
echo -e "\n    # Removing all empty files in /tmp/ not recursively"
find /tmp/ -maxdepth 1 -empty -print $delete_file # -delete

if [ "$clean_all" == "all" ]; then # Delete .ICE-unix .X11-unix plasma-csd-generator.* sddm-auth*
    echo -en "\nDelete empty files/folders in /tmp/ folder. Continue? (y)es or (n)o: "
    if [ "$continue_or_not_2" == '' ]; then
        read -r continue_or_not_2
    else
        echo -n "$continue_or_not_2"
    fi

    if [ "$continue_or_not_2" == 'y' ]; then
        # Preserves important files required for graphical sessions
            # /tmp/sddm-auth-*, /tmp/xauth-*, /tmp/xauth_*, /tmp/.ICE-unix/, /tmp/.X11-unix/
        preserve_X=(-name "sddm-auth-*" -o -name "xauth-*" -o -name "xauth_*" -o )
        preserve_X+=( -name ".ICE-unix*" -o -name ".X11-unix*" ) # Need '-prune -o' after
        echo -e "\n\nFiles/Folders ignored - need by X -\$preserve_X: ${preserve_X[@]}"

        # Delete all empty (zero size) folders and files in /tmp/ recursively
            # '-name ".mount_*" -prune -o' to ignore all AppImage in use, with mount in "/tmp/.mount_*"
        find /tmp/ \( "${preserve_X[@]}" \) -prune -o -name ".mount_*" -prune -o -empty -print $delete_file # -delete # Safer to remove empty files
        find /tmp/ \( "${preserve_X[@]}" \) -prune -o -name ".mount_*" -prune -o -size 0b -print $delete_file # -delete # Remove files with 0b. Depend of block size

        echo -e "\n # Recommendation: Restart your system! #"
    else
        echo -e "\nJust exiting\n"
    fi
fi
echo -e "\nEnd of script!\n"
