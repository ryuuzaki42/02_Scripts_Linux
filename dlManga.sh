#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
# Mande me um e-mail. Ficarei Grato!
# e-mail  joao42lbatista@gmail.com
#
# Este programa é um software livre; você pode redistribui-lo e/ou
# modifica-lo dentro dos termos da Licença Pública Geral GNU como
# publicada pela Fundação do Software Livre (FSF); na versão 2 da
# Licença, ou (na sua opinião) qualquer versão.
#
# Este programa é distribuído na esperança que possa ser  útil,
# mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO a
# qualquer MERCADO ou APLICAÇÃO EM PARTICULAR.
#
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: Download de imagem (manga) apartir do link da primeira imagem
#
# Última atualização: 05/01/2016
#

echo -e "\n\t# Wellcome to DlManga #"
echo -e "\n\t# This Script will download imagens from <folder(s)> link(s) sequentially #"

echo -ne "\n\nManga name (will be the folder name <download destination>): "
read name

echo -e "\nLink of Manga (imagens):"
read link

echo -en "\nChapter to start the download: "
read chapterStart

echo -en "\nChapter to end the download: "
read chapterEnd

echo -e "\nThe name of the imagens begin different from 00 (00, 01 etc)?"
echo -n "No <Hit Enter> | Yes <Type de difference, like Q_c00, type: Q_c>: "
read startImage

echo -e "\nSame imagens can have one difference in the middle"
echo -n "Possible difference (most common is a) <will try download with this difference in the last part>: "
read smallDifference

if [ $chapterStart -gt $chapterEnd ]; then
    echo -e "\n\nThe chapter to start the download is great than chapter end (Start: $chapterStart, End: $chapterEnd).\n\n"
    exit 1
fi

mkdir "$name" 2> /dev/null # create folder destination
cd "$name" # move to there

((chapterEnd+=1)) # to download the last chapter in the while condition

countImages=1000 # count of imagens, not for real, just for try

echo -e "\n\t#Please wait until the download finished#\n"

while [ $chapterStart -lt $chapterEnd ]; do # run until chapter download equal to end chapter to download
    i=0 # first image
    zero=0 # just for zero to 0 to 9, like (0<1,2,3,4,5,6,7,8,9>)
    goTONext=0 # to not try more and go for next chapter, when get 3 not found
    notZip=0 # just for not zip one incomplete chapter folder

    echo -e "Downloading the chapter $chapterStart ($link$chapterStart/$startImage<00|?end?>.<jpg|png|jpeg>).\n" # Current chapter download

    mkdir $chapterStart 2> /dev/null # create the folder to current chapter in download
    cd $chapterStart # move to download folder

    while [ $i -lt $countImages ]; do # try download all imagens, if has not foud tree times, go to next chapter
        flag=1 # just for print the status of download, if one will print ok
        dualPage=0 # just for print the status of download dual page

        if [ $i -gt 9 ]; then
            zero= # more then 9 (10, 11 etc) don't need zero in begin
        fi

        # C => Chapter, I => Image, S => Status
        echo -n " # C: $chapterStart # P: $zero$i # S: " # print the try download right now

        # Examples of download of a link
        # link=http://website.com/mangax/
        # chapterStart=10
        # startImage=1
        # i=0
        # wget -q -t 3 $link$chapterStart/$startImage$zero$i.jpg equals to
        # wget -q -t 3 link=http://website.com/mangax/10/01.jpg

        wget -q -t 3 $link$chapterStart/$startImage$zero$i.jpg # try download with extension jpg
 
        if [ $? != 0 ]; then # if fail try with another extension
            wget -q -t 3 $link$chapterStart/$zero$i.png

            if [ $? != 0 ]; then
                wget -q -t 3 $link$chapterStart/$startImage$zero$i.jpeg

                if [ $? != 0 ]; then # if fail try with dual page
                    i2=$i
                    ((i2+=1))
                    dualPage=1

                    if [ $i2 -gt 9 ]; then # more then 9 (10, 11 etc) don't need zero in begin
                        zero2=
                    else
                        zero2=$zero
                    fi

                    wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2.jpg

                    if [ $? != 0 ]; then
                        wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2.png

                        if [ $? != 0 ]; then
                            wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2.jpeg

############################ # Start "Try download with the smallDifference"

                            if [ $? != 0 ]; then # if fail try with another extension
                                dualPage=0
                                wget -q -t 3 $link$chapterStart/$startImage$zero$i$smallDifference.jpg # try download with extension jpg

                                if [ $? != 0 ]; then # if fail try with another extension
                                    wget -q -t 3 $link$chapterStart/$startImage$zero$i$smallDifference.png

                                    if [ $? != 0 ]; then
                                        wget -q -t 3 $link$chapterStart/$startImage$zero$i$smallDifference.jpeg

                                        if [ $? != 0 ]; then # if fail try with dual page
                                            i2=$i
                                            ((i2+=1))
                                            dualPage=1

                                            if [ $i2 -gt 9 ]; then # more then 9 (10, 11 etc) don't need zero in begin
                                                zero2=
                                            else
                                                zero2=$zero
                                            fi

                                            wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.jpg

                                            if [ $? != 0 ]; then
                                                wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.png

                                                if [ $? != 0 ]; then
                                                    wget -q -t 3 $link$chapterStart/$startImage$zero$i-$zero2$i2$smallDifference.jpeg
                                                fi
                                            fi
                                        fi
                                    fi
                                fi
                            fi

############################  # End "Try download with the smallDifference"

                        fi
                     fi
                fi
            fi
        fi

         if [ $? -eq 0 ]; then
            if [ $dualPage -eq 1 ]; then # if not fail, don't need try i+1, beacause i+1 is already download with i page (dual page)
                ((i+=1))
            fi

        else # if not found page
            echo " not found #"
            flag=0 # to not print ok below
            ((goTONext+=1)) # times for next chapter
        fi

        if [ $? -eq 0 ] && [ $flag -eq 1 ]; then # print ok if already download the image
            echo -n " ok #"

            if [ $dualPage -eq 1 ]; then # if download dual page
                ((i2-=1))
                echo " * Downloaded # P: \"$startImage$zero$i2-$zero2$i\"."
             else
                echo # create break of line
            fi

            if [ $goTONext -eq 1 ]; then
                i2=$i
                ((i2-=1))
                echo -e "\n Better look for the image [$startImage$i2].\n" # When not found only one image in the middle
                goTONext=0
                notZip=1
            fi

            if [ $goTONext -eq 2 ]; then
                i2=$i
                i3=$i
                ((i2-=1))
                ((i3-=2))
                echo -e "\n Better look for this imagens [$startImage$2 and $startImage$3].\n" # When not found only two image in the middle
                goTONext=0
                notZip=1
            fi
        fi

        if [ $goTONext -eq 3 ]; then # if get 3, go to next chapter
            i=1000
            echo -e "\nTried three times and not found any more image, so stop download this chapter."
        fi
        ((i+=1)) # increase the i to next page
    done

    cd .. # move to folder up, leaving the chapter folder

    listFiles=`ls $chapterStart`

    if [ -n "$listFiles" ] && [ $notZip -eq 0 ]; then
        zip -q -r $chapterStart.zip $chapterStart # zip the folder already download
        rm -r $chapterStart # delete the <open> folder and files
        echo -e "\nziped the folder \"$chapterStart\" ($chapterStart.zip) and delete the folder \"$chapterStart\".\n"
    elif [ $notZip -eq 1 ]; then
        echo -e "\nThe folder \"$chapterStart\" has some image(ns) not found, so this was not downloaded.\nThis <folder> was left to you be aware of them.\n"
    else
        echo -e "\nThe folder \"$chapterStart\" is empty, so none image was downloaded.\nThis <folder> was left to you be aware of them.\n"
    fi

    ((chapterStart+=1)) # increase to go to next chapter
done # end
cd .. # move to folder up, leaving the manga folder
#