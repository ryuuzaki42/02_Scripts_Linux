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
# Last update: 21/08/2022
#
set -e

echo -e "\\n # Script to clean some logs from home folder (~) and /tmp/ folder #\\n"

rmFilesAndFolders() {
    fileName=$1
    rm -fvr "$fileName" || true
}

# rmFilesAndFolders "~/.cache/"
rmFilesAndFolders "~/.cache/thumbnails/"

rmFilesAndFolders "~/.thumbnails/"
rmFilesAndFolders "~/.xsession-errors"
rmFilesAndFolders "~/.config/VirtualBox/*log*"
rmFilesAndFolders "~/VirtualBox\ VMs/*/Logs/"

rmFilesAndFolders "/tmp/tmpaddon*"
rmFilesAndFolders "/tmp/lastChance*"
rmFilesAndFolders "/tmp/qtsingleapp-*"
rmFilesAndFolders "/tmp/.ktorrent_kde4_*"
rmFilesAndFolders "/tmp/gameoverlayui.log*"
rmFilesAndFolders "/tmp/dropbox-antifreeze-*"
rmFilesAndFolders "/tmp/steam_chrome_shmem_uid*"
rmFilesAndFolders "/tmp/steam_chrome_overlay_uid*"
rmFilesAndFolders "/tmp/mastersingleapp-master*"
rmFilesAndFolders "/tmp/.org.chromium.Chromium.*"
rmFilesAndFolders "/tmp/OSL_PIPE_1000_SingleOfficeIPC_*"

rmFilesAndFolders "/tmp/SBo/"
rmFilesAndFolders "/tmp/dumps/"
rmFilesAndFolders "/tmp/Temp-*/"
rmFilesAndFolders "/tmp/lu*.tmp/"
rmFilesAndFolders "/tmp/skype-*/"
rmFilesAndFolders "/tmp/.esd-1000/"
rmFilesAndFolders "/tmp/runtime-*/"
rmFilesAndFolders "/tmp/.vbox-*-ipc/"
rmFilesAndFolders "/tmp/hsperfdata_*/"
rmFilesAndFolders "/tmp/skypeforlinux*/"
rmFilesAndFolders "/tmp/Slack\ Crashes/"
rmFilesAndFolders "/tmp/smartsynchronize-*/"
rmFilesAndFolders "/tmp/org.cogroo.addon.*/"
rmFilesAndFolders "/tmp/v8-compile-cache-*/"
rmFilesAndFolders "/tmp/plasma-csd-generator.*/"
rmFilesAndFolders "/tmp/.org.chromium.Chromium.*/"
rmFilesAndFolders "/tmp/com.microsoft.teams.linux\ Crashes/"

echo -e "\\nEnd of script!"
