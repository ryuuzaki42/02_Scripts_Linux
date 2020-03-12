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
# Script: Clean some logs do home folder (~) and /tmp/ folder
#
# Last update: 13/03/2020
#

folderHomeToClean="/media/sda2/home/j"
rm -fv $folderHomeToClean/.xsession-errors
# rm -fr $folderHomeToClean/.cache/
rm -fvr $folderHomeToClean/.thumbnails/
rm -fvr $folderHomeToClean/.config/VirtualBox/*log*
rm -fvr $folderHomeToClean/VirtualBox\ VMs/*/Logs/

rm -fv /tmp/lastChance*
rm -fv /tmp/qtsingleapp-*
rm -fv /tmp/.ktorrent_kde4_*
rm -fv /tmp/dropbox-antifreeze-*
rm -fv /tmp/gameoverlayui.log*
rm -fv /tmp/.org.chromium.Chromium.*
rm -fv /tmp/mastersingleapp-master*
rm -fv /tmp/OSL_PIPE_1000_SingleOfficeIPC_*
rm -fv /tmp/steam_chrome_shmem_uid*

rm -fvr /tmp/skype-*/
rm -fvr /tmp/SBo/
rm -fvr /tmp/skypeforlinux*/
rm -fvr /tmp/smartsynchronize-*/
rm -fvr /tmp/.esd-1000/
rm -fvr /tmp/runtime-*/
rm -fvr /tmp/dumps/
rm -fvr /tmp/Temp-*/
rm -fvr /tmp/hsperfdata_*/
rm -fvr /tmp/.vbox-*-ipc/
rm -fvr /tmp/Slack\ Crashes/
rm -fvr /tmp/org.cogroo.addon.*/
rm -fvr /tmp/lu*.tmp/
