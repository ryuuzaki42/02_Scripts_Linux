#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
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
# Script: Download files/packages from one mirror
#
# Last update: 17/11/2016
#
echo -e "\n# This script download files/packages from a repository #\n"


if [ -z "$ARCH" ]; then
    case "$( uname -m )" in
        i?86) ARCH=x86 ;;
        arm*) ARCH=armv7hl ;;
        *) ARCH=$( uname -m ) ;;
    esac
fi
archDL=$ARCH

echo -e "The arch of your computer is: $archDL"

echo -en "Want download from another arch? (y)es - (n)o (press enter to no): "
read changeArchDl
if [ "$changeArchDl" == 'y' ]; then
    echo -en "\nType the new arch: "
    read archDL
fi

if [ $archDL == "x86" ] || [ "$archDL" == "armv7hl" ] || [ "$archDL" == "x86_64" ]; then
    mirrorSource="http://bear.alienbase.nl/mirrors/people/alien/sbrepos/"

    echo -e "\nDefault mirror: $mirrorSource"

    echo -en "Want change the mirror? (y)es - (n)o (press enter to no): "
    read changeMirror

    if [ "$changeMirror" == 'y' ]; then
        mirrorSource=''

        while echo "$mirrorSource" | grep -v -q -E "ftp|http"; do
            echo -en "\nType the new mirror: "
            read mirrorSource
        done

        echo -e "\nNew mirror: $mirrorSource\n"
    fi

    echo -en "\nWith version Slackware you want? (press enter to 14.2): "
    read versioSlackware
    if [ "$versioSlackware" == '' ]; then
        versioSlackware="14.2"
    fi

    progNameDl=''
    while echo "$progNameDl" | grep -v -q -E "[a-zA-Z0-9]"; do
        echo -en "\nType the program name or pattern that want download: "
        read progNameDl
    done

    echo -en "\nAll file or only with \".t?z\" in the end?\n1 - to all files or 2 - to only the \".t?z\" (press enter to only \".t?z\"): "
    read filesAllMachOrNot
    if [ "$filesAllMachOrNot" == '' ]; then
        patternDl=$progNameDl*.t?z
    else
        patternDl=$progNameDl
    fi
    echo

    mirrorDl="$mirrorSource/$versioSlackware/$archDL/$progNameDl"

    initialFolder=`pwd`
    folderDest=$progNameDl-dl-alien-`date +%s`

    mkdir $folderDest/
    cd $folderDest/

    wget -c -r -l 1 -np -nH --cut-dirs=100 \
    -A "$patternDl" \
    $mirrorDl/

    # -nH --cut-dirs=100 cut 100 directories to be no created
    # -c continue
    # -r:  recursive retrieving
    # -l 1  sets the maximum recursion depth to be 1
    # -np  does not ascend to the parent; only downloads from the specified sub directory and downwards hierarchy

    cd $initialFolder

    if [ $? == 0 ]; then
        echo -e "\nThe files with the pattern \"$progNameDl\" was saved in the folder \"$folderDest/\"\n"
        echo -e "List of files downloaded:`tree --noreport $folderDest`"
    else
        echo -e "\nNot found any file with the pattern \"$progNameDl\"\n"
        rm -r $folderDest/
    fi
else
    echo "Error: the arch $archDL don't have files in one default alien mirror"
fi
