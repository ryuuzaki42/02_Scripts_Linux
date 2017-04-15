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
# Script: Download files/packages from one mirror
#
# Last update: 14/04/2017
#
echo -e "\n# This script download files/packages from a repository #\n"

case "$(uname -m)" in
    i?86) archDL=x86 ;;
    arm*) archDL=armv7hl ;;
    *) archDL=$(uname -m) ;;
esac

echo -e "The arch of your computer is: $archDL"

echo -en "Want download from another arch? (y)es - (n)o (press enter to no): "
read -r changeArchDl
if [ "$changeArchDl" == 'y' ]; then
    echo -en "\nType the new arch: "
    read -r archDL
fi

if [ "$archDL" == "x86" ] || [ "$archDL" == "armv7hl" ] || [ "$archDL" == "x86_64" ]; then
    mirrorSource="http://bear.alienbase.nl/mirrors/people/alien/sbrepos"

    echo -e "\nDefault mirror is: $mirrorSource"

    echo -en "Want change the mirror? (y)es - (n)o (press enter to no): "
    read -r changeMirror

    if [ "$changeMirror" == 'y' ]; then
        mirrorSource=''

        while echo "$mirrorSource" | grep -v -q -E "ftp|http"; do
            echo -en "\nType the new mirror: "
            read -r mirrorSource
        done

        echo -e "\nNew mirror is: $mirrorSource\n"
    fi

    echo -en "\nFor with version of Slackware you want? (press enter to 14.2): "
    read -r versioSlackware
    if [ "$versioSlackware" == '' ]; then
        versioSlackware="14.2"
    fi

    progNameDl=''
    while echo "$progNameDl" | grep -v -q -E "[a-zA-Z0-9]"; do
        echo -en "\nType the program name or pattern that want download: "
        read -r progNameDl
    done

    echo -en "\nAll file or only with \".t?z\" in the end?\n1 - to all files or 2 - to only the \".t?z\" (press enter to only \".t?z\"): "
    read -r filesAllMachOrNot
    if [ "$filesAllMachOrNot" == '1' ]; then
        patternDl=$progNameDl
    else
        patternDl="$progNameDl*.t?z"
    fi

    echo -e "\nLook in all folder or just in \"$progNameDl\" folder?"
    echo -en "1 - in all folders (can take a long time) or 2 - only in \"$progNameDl\" (press enter to only in \"$progNameDl\"): "
    read -r filesAllFolderOrNot
    if [ "$filesAllFolderOrNot" == '1' ]; then
        mirrorDl="$mirrorSource/$versioSlackware/$archDL"
    else
        mirrorDl="$mirrorSource/$versioSlackware/$archDL/$progNameDl"
    fi

    initialFolder=$(pwd)
    folderDest="$progNameDl-JBdl-alien-$(date +%s)"
    mkdir "$folderDest"
    cd "$folderDest" || exit
    echo

    wget -r -np -nH --cut-dirs=100 -A "$patternDl" "$mirrorDl/"
    # --cut-dirs=NUMBER  ignore NUMBER remote directory components
    #    --cut-dirs=100 cut 100 directories to be no created
    # -nH                don't create host directories
    # -np                don't ascend to the parent directory
    #    Only downloads from the specified sub directory and downwards hierarchy
    # -r                 specify recursive download

    cd "$initialFolder" || exit
    filesDlCountMoreOne=$(tree --noreport "$folderDest" | wc -l)
    if [ "$filesDlCountMoreOne" -gt 1 ]; then
        echo -e "\nThe files with the pattern \"$progNameDl\" was saved in the folder \"$folderDest/\"\n"
        echo -e "List of files downloaded:\n\n$(tree --noreport "$folderDest")\n"
    else
        echo -e "\nNot found any file with the pattern \"$progNameDl\"\n"
        rm -r "$folderDest"
    fi
else
    echo "Error: the arch \"$archDL\" don't have files in a default alien mirror"
fi
