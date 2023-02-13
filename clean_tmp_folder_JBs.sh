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
# Script: Clean some logs from home folder ($HOME_USER) and /tmp/ folder
#
# Last update: 13/02/2023
# Tip: pass all to clean empty files/folder in /tmp
#
#HOME_USER="/media/sda2/home/j/
HOME_USER=$HOME
CLEAN_ALL=$1

echo -e "\\n # Script to clean some logs from home folder ($HOME_USER) and /tmp/ folder #\\n"

filesFoldersToRermove=("$HOME_USER/.cache/thumbnails/"
"$HOME_USER/.thumbnails/"
"$HOME_USER/.xsession-errors"
"$HOME_USER/.config/VirtualBox/*log*"
"$HOME_USER/VirtualBox VMs/*/Logs/"
 "/tmp/tmpaddon*"
 "/tmp/lastChance*"
 "/tmp/qtsingleapp-*"
"/tmp/.ktorrent_kde4_*"
"/tmp/gameoverlayui.log*"
"/tmp/dropbox-antifreeze-*"
"/tmp/steam_chrome_shmem_uid*"
"/tmp/steam_chrome_overlay_uid*"
"/tmp/mastersingleapp-master*"
"/tmp/.org.chromium.Chromium.*"
"/tmp/OSL_PIPE_*_SingleOfficeIPC_*"
"/tmp/SBo/"
"/tmp/dumps/"
"/tmp/Temp-*/"
"/tmp/lu*.tmp/"
"/tmp/skype-*/"
"/tmp/.esd-*/"
"/tmp/.wine-*"
"/tmp/runtime-*/"
"/tmp/.vbox-*-ipc/"
"/tmp/hsperfdata_*/"
"/tmp/skypeforlinux*/"
"/tmp/Slack Crashes/"
"/tmp/smartsynchronize-*/"
"/tmp/org.cogroo.addon.*/"
"/tmp/v8-compile-cache-*/"
"/tmp/.org.chromium.Chromium.*/"
"/tmp/com.microsoft.teams.linux Crashes/")

# Can be useful if add to filesFoldersToRermove
# "$HOME_USER/.cache/"
# "/tmp/plasma-csd-generator.*"
# "/tmp/plasma-csd-generator.*/"

IFS=$(echo -en "\\n\\b") # Change the Internal Field Separator (IFS) to "\\n\\b"
for val in ${filesFoldersToRermove[*]}; do
    #echo "val: \"$val\""

    # Show errors (files and folders not found)
    #rm -vr "$val"

    # Default - not show errors
    rm -fvr "$val"
done

if [ "$CLEAN_ALL" == "all" ]; then # Delete .ICE-unix .X11-unix plasma-csd-generator.* sddm-auth*
    echo -en "\\nDelete empty files/folders in /tmp/ folder. Continue? (y)es or (n)o: "
    read continue_or_not

    if [ "$continue_or_not" == 'y' ]; then
        # Delete empty (zero size) folder and files in /tmp/
        find /tmp/ -size 0 -print -delete
        find /tmp/ -empty -print -delete

        echo -e "\\n # Recommendation: Restart your system! #"
    else
        echo "Just exiting"
    fi
fi

echo -e "\\nEnd of script!\\n"
