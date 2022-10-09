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
# Script: Clean some logs from home folder (~) and /tmp/ folder
#
# Last update: 09/10/2022
#
echo -e "\\n # Script to clean some logs from home folder (~) and /tmp/ folder #\\n"

filesFoldersToRermove=("~/.cache/thumbnails/"
"~/.thumbnails/"
"~/.xsession-errors"
"~/.config/VirtualBox/*log*"
"~/VirtualBox\ VMs/*/Logs/"
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
"/tmp/Slack\ Crashes/"
"plasma-csd-generator.*"
"/tmp/smartsynchronize-*/"
"/tmp/org.cogroo.addon.*/"
"/tmp/v8-compile-cache-*/"
"/tmp/plasma-csd-generator.*/"
"/tmp/.org.chromium.Chromium.*/"
"/tmp/com.microsoft.teams.linux\ Crashes/")

# Can be useful if add to filesFoldersToRermove
# "~/.cache/"

for val in ${filesFoldersToRermove[*]}; do
    #echo "$val"

    # echo to expand * and ~
    eval $(echo "rm -fvr $val")
done

# Delete empty (zero size) folder and files in /tmp/
find /tmp/ -size 0 -print -delete
find /tmp/ -empty -print -delete

echo -e "\\nEnd of script!\\n"
