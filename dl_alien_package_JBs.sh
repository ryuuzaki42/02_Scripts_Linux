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
# Script: Download files/packages from one mirror with CHECKSUMS.md5
#
# Last update: 19/06/2023
#
case "$(uname -m)" in
    i?86) archDL="x86" ;;
    *) archDL=$(uname -m) ;;
esac

echo -e "\n# This script download files/packages from one Alien mirror #\n"
pathDl=$1 # Use the "pathDl" to download the packages instead the (full) folder

#mirrorStart="http://www.slackware.com/~alien/sbrepos"
#mirrorStart="https://slackware.nl/people/alien/sbrepos"
mirrorStart="https://slackware.uk/people/alien/sbrepos"

echo "Default mirror: $mirrorStart"

echo -en "\nWant change the mirror?\n(y)es - (n)o (press enter to no): "
read -r changeMirror

if [ "$changeMirror" == 'y' ]; then
    mirrorStart=''

    while echo "$mirrorStart" | grep -v -q -E "ftp|http"; do
        echo -en "\nType the new mirror: "
        read -r mirrorStart

        if echo "$mirrorStart" | grep -v -q -E "ftp|http"; then
            echo -e "\nError: the mirror \"$mirrorStart\" is not valid\nOne valid mirror has \"ftp\" or \"http\""
        fi
    done
    echo -e "\nNew mirror: $mirrorStart"
fi

echo -en "\nWith version Slackware you want? (press enter to 15.0): "
read -r versionSlackware

if [ "$versionSlackware" == '' ]; then
    versionSlackware="15.0"
fi

if [ "$pathDl" == '' ]; then
    echo -en "\nType the path/program that want download: "
    read -r pathDl
fi

echo -en "\nOnly \"t?z\" or all files?\n1 to only \"t?z\" - 2 to all (hit enter to only t?z): "
read -r allOrNot

if [ "$allOrNot" != 2 ]; then
    extensionFile=".t\\?z"
fi

mirrorDl="$mirrorStart/$versionSlackware/$archDL"
echo
wget "$mirrorDl/CHECKSUMS.md5" -O CHECKSUMS.md5

runFileTmp=$(grep "$pathDl.*.$extensionFile$" < CHECKSUMS.md5)
rm CHECKSUMS.md5
runFile=$(echo "$runFileTmp" | cut -d '/' -f2-)

echo -e "All packages found with \"$pathDl\":\n$runFile"

echo -e "\nExclude some results based in some patterns?"
echo -n "Hit enter to no or type the patterns (use | between the patterns, like: p1|p2): "
read -r pathExclude

if [ "$pathExclude" != '' ]; then
    echo -e "\nFiles excluded with \"$pathExclude\":"
    echo "$runFile" | grep -E "$pathExclude"

    runFileTmp=$(echo "$runFileTmp" | grep -vE "$pathExclude")
    runFile=$(echo "$runFile" | grep -vE "$pathExclude")
fi

if [ "$runFile" != '' ]; then
    echo -e "\nCurrent packages found with \"$pathDl\":\n$runFile\n"
    echo -n "Want to continue and download them or no to only show the links? (y)es - (n)o (hit enter to yes): "
    read -r continueDl

    if [ "$continueDl" != 'n' ]; then
        folderName="${pathDl}_new"
        mkdir "$folderName"
        cd "$folderName" || exit

        for fileGrep in $(echo -e "$runFile"); do
            echo
            wget -c "$mirrorDl/$fileGrep"
            wget -c "$mirrorDl/$fileGrep.md5"
        done

        echo -e "Md5sum test of integrate:"
        md5sum -c ./*.md5
    else
        for fileGrep in $(echo -e "$runFile"); do
            echo
            echo "$mirrorDl/$fileGrep"
            echo "$mirrorDl/$fileGrep.md5"
        done
        echo -e "\nJust exiting by user choice"
    fi
else
    echo -e "\nNot found any file to download"
fi
echo
