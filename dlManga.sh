#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
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
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Download de imagem (manga) a partir do link da primeira imagem
#
# Última atualização: 06/06/2016
#
# Set color by tput:
green=`tput setaf 2`
magenta=`tput setaf 5`
reset=`tput sgr0`

#     Num  Colour    #define         R G B
# 
#     0    black     COLOR_BLACK     0,0,0
#     1    red       COLOR_RED       1,0,0
#     2    green     COLOR_GREEN     0,1,0
#     3    yellow    COLOR_YELLOW    1,1,0
#     4    blue      COLOR_BLUE      0,0,1
#     5    magenta   COLOR_MAGENTA   1,0,1
#     6    cyan      COLOR_CYAN      0,1,1
#     7    white     COLOR_WHITE     1,1,1

echo -e "${magenta}\n\t# Wellcome to DlManga #"
echo -e " ${green}\t\t\t\t\t* $0 -h for help/example"
echo -e "\t${reset}# This Script will download images from <folder(s)> link(s) sequentially #"

if [ "$1" == "-h" ]; then
    echo -e "\n\t${green}Example:\n"
    echo -e "\tlink = http://website.com/mangax/; chapterStart = 10; chapterEnd = 12; startImage = 1; smallDifference=_Qa_\n"
    echo -e "\tFirst part will try:"
    echo -e "\twget -q link=http://website.com/mangax/10/00.jpg\n"
    echo -e "\tIn the last part will try:"
    echo -e "\twget -q link=http://website.com/mangax/10/00_Qa_.jpg\n"
    echo -e "\tTested with mangas from the site: http://unionmangas.com.br/${reset}\n"
    exit 0
fi

echo -en "\n\nManga name: "
read nameManga

echo -e "\nCreate a folder <download destination>:?"
echo -n "Yes <Hit Enter> | ${green}No <type n>${reset}: "
read newFolder

echo -e "\nLink of Manga (imagens) [${green}only the link without the chapter number or image number]${reset}:"
read link

echo -en "\nChapter to start the download: "
read chapterStart

echo -en "\nChapter to end the download <${green}if you will download just one chapter, hit enter${reset}>: "
read chapterEnd

echo -e "\nThe name of the imagens begin is different from 00 (00, 01 etc)?"
echo -n "No <Hit Enter> | Yes <${green}Type de difference, like Q_c00, type: Q_c${reset}>: "
read startImage

echo -e "\nSome imagens can have one difference in the middle (e.g., 00a.jpg e 01a.jpg)"
echo -n "Possible difference (most common is a) <will try download with this difference in the last part>: "
read smallDifference

echo -e "\n${green}How many images have try to be the end the chapter${reset}? (Default is 3 times)"
echo -n "In another words, count not found before go to next chapter: "
read tryTimesSequentiallyDl

if [ "$tryTimesSequentiallyDl" == '' ]; then
    tryTimesSequentiallyDl=3
fi

if [ "$link$zeroChapter" == '' ]; then
    echo -e "\n\nERRROR\n${magenta}The link <site> is empty (link: \"$link$zeroChapter\").${reset}\n\n"
    exit 1
fi

if [ "$chapterStart" == '' ]; then
    echo -e "\n\nERRROR\n${magenta}The chapter to start is empty (Start: \"$chapterStart\", End: \"$chapterEnd\").${reset}\n\n"
    exit 1
fi

if [ "$chapterEnd" == '' ]; then
    chapterEnd=$chapterStart
fi

if [ $chapterStart -gt $chapterEnd ]; then
    echo -e "\n\nERRROR\n${magenta}The chapter to start the download is great than chapter end (Start: \"$chapterStart\", End: \"$chapterEnd\").${reset}\n\n"
    exit 1
fi

if [ "$newFolder" != "n" ]; then
    mkdir "$nameManga" 2> /dev/null # Create folder destination
    cd "$nameManga" # Move to there
fi

((chapterEnd+=1)) # To download the last chapter in the while condition
wgetReturn=1 # For status about the download by wget
imagensNotDownload='' # Images not downloaded

countImages=1000 # Count of images, not for real, just for try

echo -e "\n\t${magenta}#Please wait until the download finished#\n"

while [ $chapterStart -lt $chapterEnd ]; do # Run until chapter download equal to end chapter to download
    i=0 # first image
    emptyFolder=1 # Just tell the chapter folder is empty
    zeroChapter=0 # Just for zero to 0 to 9, like (0<1,2,3,4,5,6,7,8,9>)
    zero=0 # Just for zero to 0 to 9, like (0<1,2,3,4,5,6,7,8,9>)
    goTONext=0 # To not try more and go for next chapter, when get equal tryTimesSequentiallyDl not found
    notZip=0 # Just for not zip one incomplete chapter folder

    if [ $chapterStart -gt 9 ]; then
        zeroChapter= # More then 9 (10, 11 etc) don't need zero in begin
    fi

    echo -e "${green}Downloading the chapter $chapterStart ($link$zeroChapter$chapterStart/$startImage<00|?end?>.<jpg|png|jpeg>).\n${reset}" # Current chapter download

    if [ "$nameManga" != '' ]; then # Get the name of chapter folder
        nameFolder="$nameManga $chapterStart"
    else
        nameFolder="$chapterStart"
    fi

    mkdir "$nameFolder" 2> /dev/null # Create the folder to current chapter in download
    mkdirReturn=$?

    if [ $mkdirReturn -eq 1 ]; then
        randomNameFolder=$nameFolder # Random name to move to /tmp/
        randomNameFolder="$nameFolder $RANDOM"
        echo -e "${magenta}\tThe Folder \"$nameFolder\" already exist. Renamed to \"$randomNameFolder\" and moved to /tmp/${reset}\n\n"
        mv "$nameFolder" "$randomNameFolder"
        mv "$randomNameFolder" /tmp/
        mkdir "$nameFolder" 2> /dev/null # Create the folder to current chapter in download
    fi

    cd "$nameFolder" # Move to download folder
    while [ $i -lt $countImages ]; do # Try download all images, if has not found tree times, go to next chapter
        dualPage=0 # Just for print the status of download dual page

        if [ $i -gt 9 ]; then
            zero= # More then 9 (10, 11 etc) don't need zero in begin
        fi

        # C => Chapter, I => Image, S => Status
        echo -n " # C: $chapterStart # P: $zero$i # S: " # Print the try download right now

        wget -q $link$zeroChapter$chapterStart/$startImage$zero$i.jpg # Try download with extension jpg
        wgetReturn=$? # Get result from the command wget
 
        if [ $wgetReturn != 0 ]; then # If fail try with another extension
            wget -q $link$zeroChapter$chapterStart/$zero$i.png
            wgetReturn=$?

            if [ $wgetReturn != 0 ]; then
                wget -q $link$zeroChapter$chapterStart/$startImage$zero$i.jpeg
                wgetReturn=$?

                if [ $wgetReturn != 0 ]; then # If fail try with dual page
                    i2=$i
                    ((i2++))
                    dualPage=1

                    if [ $i2 -gt 9 ]; then # More then 9 (10, 11 etc) don't need zero in begin
                        zero2=
                    else
                        zero2=$zero
                    fi

                    wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2.jpg
                    wgetReturn=$?

                    if [ $wgetReturn != 0 ]; then
                        wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2.png
                        wgetReturn=$?

                        if [ $wgetReturn != 0 ]; then
                            wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2.jpeg
                            wgetReturn=$?

                            if [ "$smallDifference" != '' ]; then # Start "Try download with the smallDifference"

                                if [ $wgetReturn != 0 ]; then # If fail try with another extension
                                    dualPage=0
                                    wget -q $link$zeroChapter$chapterStart/$startImage$zero$i$smallDifference.jpg # Try download with extension jpg
                                    wgetReturn=$?

                                    if [ $wgetReturn != 0 ]; then # If fail try with another extension
                                        wget -q $link$zeroChapter$chapterStart/$startImage$zero$i$smallDifference.png
                                        wgetReturn=$?

                                        if [ $wgetReturn != 0 ]; then
                                            wget -q $link$zeroChapter$chapterStart/$startImage$zero$i$smallDifference.jpeg
                                            wgetReturn=$?

                                            if [ $wgetReturn != 0 ]; then # If fail try with dual page
                                                i2=$i
                                                ((i2++))
                                                dualPage=1

                                                if [ $i2 -gt 9 ]; then # More then 9 (10, 11 etc) don't need zero in begin
                                                    zero2=
                                                else
                                                    zero2=$zero
                                                fi

                                                wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.jpg
                                                wgetReturn=$?

                                                if [ $wgetReturn != 0 ]; then
                                                    wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.png
                                                    wgetReturn=$?

                                                    if [ $wgetReturn != 0 ]; then
                                                        wget -q $link$zeroChapter$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.jpeg
                                                        wgetReturn=$?
                                                    fi
                                                fi
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi

        if [ $wgetReturn -eq 0 ]; then
            echo -n " ok #"
            emptyFolder=0
            if [ $dualPage -eq 1 ]; then # If not fail, don't need try i+1, beacause i+1 is already download with i page (dual page)
                ((i++))
                ((i2--))
                echo -n " * Downloaded # P: \"$startImage$zero$i2-$zero2$i\"."
            fi
            echo # Create break of line

            if [ $goTONext -eq 1 ]; then
                i2=$i
                ((i2--))
                if [ $dualPage -eq 1 ]; then
                    ((i2--))
                fi
                echo -e "\n Better look for the image [$startImage$i2].\n" # When not found only one image in the middle
                goTONext=0
                if [ "$imagensNotDownload" == '' ]; then
                    imagensNotDownload=$startImage$i2
                else
                    imagensNotDownload="$imagensNotDownload; $startImage$i2"
                fi
            fi

            if [ $goTONext -eq 2 ]; then
                i2=$i
                i3=$i
                ((i2--))
                ((i3-=2))
                if [ $dualPage -eq 1 ]; then
                    ((i2--))
                    ((i3--))
                fi
                echo -e "\n Better look for this imagens [$startImage$i2 and $startImage$i3].\n" # When not found only two image in the middle
                goTONext=0
                if [ "$imagensNotDownload" == '' ]; then
                    imagensNotDownload="$startImage$i2; $startImage$i3"
                else
                    imagensNotDownload="$imagensNotDownload; $startImage$i2; $startImage$i3"
                fi
            fi
        else # If not found page
            echo " not found #"
            ((goTONext++)) # Times for next chapter
            ((notZip++)) # Times for not zip (less than $tryTimesSequentiallyDl is accepted)
        fi

        if [ $goTONext -eq $tryTimesSequentiallyDl ]; then # If get equal tryTimesSequentiallyDl, go to next chapter
            i=1000
            echo -e "\nTried $tryTimesSequentiallyDl times and not found any more image, so stop download of this chapter."
        fi

        ((i+=1)) # Increase the i to next page
    done

    cd .. # Move to folder up, leaving the chapter folder

    if [ $notZip -eq $tryTimesSequentiallyDl ] && [ $emptyFolder -eq 0 ]; then
        zip -q -r "$nameFolder".zip "$nameFolder" # Zip the folder already downloaded
        rm -r "$nameFolder" # Delete the <open> folder and files
        echo -e "\nziped the folder \"$nameFolder\" ("$nameFolder".zip) and delete the folder \"$nameFolder\".\n"
    elif [ $notZip -gt $tryTimesSequentiallyDl ]; then
        echo -e "\nThe folder \"$nameFolder\" has image(ns) not found, so this was not downloaded.\nThis <folder> was left to you be aware of them.\n"
    else
        echo -e "\nThe folder \"$nameFolder\" is empty, so none image was downloaded.\nThis <folder> was left to you be aware of them.\n"
    fi

    ((chapterStart++)) # Increase to go to next chapter

    if [ "$imagensNotDownload" != '' ]; then
        echo -e "\nImagens not downloaded: $imagensNotDownload\n"
    fi
    imagensNotDownload=''
done # end

if [ "$newFolder" != "n" ]; then
    cd .. # Move to folder up, leaving the manga folder
fi
echo -e "Download finished. \"Long life and prosperity\"\n\n"

exit 0
#