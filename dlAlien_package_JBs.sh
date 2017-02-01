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
# Script: Download files/packages from one mirror with MD5
#
# Last update: 31/01/2017
#
case "$( uname -m )" in
    i?86) archDL=x86 ;;
    *) archDL=$( uname -m ) ;;
esac

echo -e "\n# This script download files/packages from one alien mirror #\n"
echo -e "### Use \"pathDl\"- to download the packages instead the full folder ###"
echo -n "Type the path/program that want download: "
read pathDl

echo -en "\nOnly \"t?z\" or all files? 1 to only \"t?z\" - 2 to all (hit enter to only t?z): "
read allOrNot

if [ "$allOrNot" != '2' ]; then
    extensionFile=".t\?z"
fi

mirrorStart="http://bear.alienbase.nl/mirrors/people/alien/sbrepos"
slackVersion="14.2"

mirrorDl="$mirrorStart/$slackVersion/$archDL"

wget "$mirrorDl/CHECKSUMS.md5" -O CHECKSUMS.md5

runFile=`cat CHECKSUMS.md5 | grep "$pathDl.*.$extensionFile$" | cut -d '.' -f2-`
rm CHECKSUMS.md5

echo -e "Will download the file(s) listed: \n$runFile\n"
echo -n "Want to continue? (y)es - (n)o (hit enter to yes): "
read continueDl

if [ "$continueDl" != "n" ]; then
    mkdir $pathDl-new
    cd $pathDl-new

    for fileGrep in `echo -e "$runFile"`; do
        wget -c $mirrorDl/$fileGrep
    done

    echo -e "List of files downloaded:\n\n`tree --noreport`\n"
else
    echo -e "\nJust exiting by user choice\n"
fi
