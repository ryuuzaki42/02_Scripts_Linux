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
# Script: Download images (manga) from a link
#
# Last update: 02/08/2017
#
echo -e "\n# Download images (manga) from a link #\n"

help() {
    echo "Usage:"
    echo " $0 [OPTION] ..."
    echo "The script's parameters are:"
    echo " -h        This help"
    echo " -n <name> Manga name to download. With space use \"manga name\" as \"One Piece\""
    echo " -l <link> Link to download the manga (with out chapter number)"
    echo " -s        Chapter to start the download"
    echo -e " -e        Chapter to end the download\n"
    exit 0
}

while getopts "hn:l:s:e:" optionInput; do
    case $optionInput in
        'h' ) help ;;
        'n' ) mangaName=${OPTARG} ;;
        'l' ) linkDl=${OPTARG} ;;
        's' ) chapterStart=${OPTARG} ;;
        'e' ) chapterEnd=${OPTARG} ;;
    esac
done

if [ "$mangaName" == '' ]; then
    echo -en "Manga name: "
    read -r mangaName

    if [ "$mangaName" == '' ]; then
        echo -e "\nERRROR: The manga name can't be empty\n"
        exit 1
    fi
fi

if [ "$linkDl" == '' ]; then
    echo -en "\nManga link to download (without chapter number): "
    read -r linkDl

    if [ "$linkDl" == '' ]; then
        echo -e "\nERRROR: The link <site> can't be empty\n"
        exit 1
    fi
fi

if [ "$chapterStart" == '' ]; then
    echo -en "\nChapter to start: "
    read -r chapterStart

    if [ "$chapterStart" == '' ]; then
        echo -e "\nERRROR: The chapter to start can't be empty\n"
        exit 1
    fi
fi

if [ "$chapterEnd" == '' ]; then
    echo -en "\nChapter to end: "
    read -r chapterEnd

    if [ "$chapterEnd" == '' ]; then
        chapterEnd=$chapterStart
    fi
fi

echo -e "\nWill download \"$mangaName\" from chapter \"$chapterStart\" to \"$chapterEnd\""
echo -en "From: \"$linkDl\"\n\nContinue? (y)es or (n)o (hit enter to yes): "
read -r ContinueOrNot

if [ "$ContinueOrNot" == 'n' ]; then
    echo -e "\nJust exiting by local choice\n"
else
    mkdir "$mangaName"
    cd "$mangaName" || exit

    ((chapterEnd+=1)) # To download the last chapter in the while condition
    IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"

    while [ "$chapterStart" -lt "$chapterEnd" ]; do # Run until chapter download equal to end chapter to download
        zeroChapter='0' # Just for zero to 0 to 9
        if [ "$chapterStart" -gt '9' ]; then
            zeroChapter='' # Greater then 9, don't need zero in begin
        fi
        chapterDl="$zeroChapter$chapterStart"
        mangaNameAndChapterDl="$mangaName $chapterDl"

        echo -e "\nDownload html file from page $chapterDl\n"
        wget "$linkDl/$chapterDl" -O "$chapterDl.html"

        linksPageDl=$(grep "http.*[[:digit:]].*g" < "$chapterDl.html" | cut -d'"' -f2- | cut -d'"' -f1 | grep "$mangaName") # Grep link to images (png, jpg)
        rm "${chapterDl}.html" # Delete html page file

        i='1'
        countImg=$(echo "$linksPageDl" | wc -l)

        mkdir "$mangaNameAndChapterDl" # Create folder to download the images
        cd "$mangaNameAndChapterDl" || exit

        for linkImg in $linksPageDl; do
            echo -e "\nDownloading chapter: $chapterDl imagens: $i of $countImg (\"$linkImg\")\n"
            wget "$linkImg"
            ((i++))
        done

        cd .. || exit
        zip -r "${mangaNameAndChapterDl}.zip" "$mangaNameAndChapterDl"
        rm -r "$mangaNameAndChapterDl" # Delete the folder with the images

        ((chapterStart++))
    done

    echo -e "\nScript end\n"
fi
