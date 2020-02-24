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
# Script: Clean /tmp/ folder
#
# Last update: 24/02/2020
#
cd /tmp/ || exit

rm -r skype-*/ 2> /dev/null
rm -r SBo/ 2> /dev/null
rm -r skypeforlinux*/ 2> /dev/null
rm -r smartsynchronize-* 2> /dev/null
rm lastChance* 2> /dev/null
rm -r .esd-1000/ 2> /dev/null
rm -r runtime-*/ 2> /dev/null
rm -r dumps/ 2> /dev/null
rm qtsingleapp-* 2> /dev/null
rm .ktorrent_kde4_* 2> /dev/null
rm -r Temp-*/ 2> /dev/null
rm -r hsperfdata_*/ 2> /dev/null
rm dropbox-antifreeze-* 2> /dev/null
rm -r .vbox-*-ipc/ 2> /dev/null
rm gameoverlayui.log* 2> /dev/null
rm .org.chromium.Chromium.* 2> /dev/null
rm -r Slack\ Crashes/ 2> /dev/null
rm mastersingleapp-master* 2> /dev/null
