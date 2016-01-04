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
# Última atualização: 04/01/2015
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

if [ $chapterStart -gt $chapterEnd ]
    then
    echo -e "\n\nThe chapter to start the download is great than chapter end (Start: $chapterStart, End: $chapterEnd)\n\n"
    exit 1
fi

mkdir "$name" 2> /dev/null # create folder destination
cd "$name" # move to there

((chapterEnd+=1)) # to download the last chapter in the while condition

countImages=1000 # count of imagens, not for real, just for try

goTONext=0 # in 5 go to next

while [ $chapterStart -lt $chapterEnd ]; do # run until chapter download equal to end chapter to download
    i=0 # first image
    zero=0 # just for zero to 0 to 9, like (0<1,2,3,4,5,6,7,8,9>)
    goTONext=0 # to not try more and go for next chapter, when get 3 not found

    echo -e "\nDownloading the chapter: $link$chapterStart/$startImage<00|?end?>.<jpg|png|jpeg>\n" # Current chapter download

    mkdir $chapterStart 2> /dev/null # create the folder to current chapter in download
    cd $chapterStart # move to download folder

    while [ $i -lt $countImages ]; do # try download all imagens, if has not foud tree times, go to next chapter
        flag=1 # just for print the status of download, if one will print ok
        notZip=0 # just for not zip one incomplete chapter folder

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
        # wget -q -t 3  $link$chapterStart/$startImage$zero$i.jpg equals to
        # wget -q -t 3  link=http://website.com/mangax/10/01.jpg

        wget -q -t 3  $link$chapterStart/$startImage$zero$i.jpg # try download with extension jpg
 
        if [ $? != 0 ]; then # if fail try with another extension
            wget -q -t 3  $link$chapterStart/$zero$i.png

            if [ $? != 0 ]; then
                wget -q -t 3  $link$chapterStart/$startImage$zero$i.jpeg

                if [ $? != 0 ]; then # if fail try with dual page
                    i2=$i
                    ((i2+=1))
                    wget -q -t 3  $link$chapterStart/$startImage$zero$i-$zero$i2.jpg

                    if [ $? != 0 ]; then
                        wget -q -t 3  $link$chapterStart/$startImage$zero$i-$zero$i2.png

                        if [ $? != 0 ]; then
                            wget -q -t 3  $link$chapterStart/$startImage$zero$i-$zero$i2.jpeg
                        fi
                     fi

                    if [ $? -eq 0 ]; then # if not fail, don't need try i+1, beacause i+1 is already download with i page (dual page)
                        ((i+=1))
                    else # if not found page
                        echo " not found #"
                        flag=0 # to not print ok below
                        ((goTONext+=1)) # times for next chapter

                        if [ $goTONext -eq 3 ]; then # if get 3, go to next chapter
                            i=1000
                        fi
                    fi
                fi
            fi
        fi

        if [ $? -eq 0 ] && [ $flag -eq 1 ]; then # print ok if already download the image
            echo " ok #"
            if [ $goTONext -eq 1 ]; then
                echo -e "\n\n Better look for the image $link$chapterStart/$startImage<$i-1>.<jpg|png|jpeg>\n" # When not found only one image in the midle
                goTONext=0
                notZip=1
            fi

            if [ $goTONext -eq 2 ]; then
                echo -e "\n\n Better look for the image $link$chapterStart/$startImage<$i-1 and $i-2>.<jpg|png|jpeg>\n" # When not found only two image in the midle
                goTONext=1
                notZip=0
            fi
        fi

        ((i+=1)) # increase the i to next page
    done

    cd .. # move to folder up, leaving the chapter folder

    listFiles=`ls $chapterStart`

    if [ -n "$listFiles" ] && [ $notZip -eq 0 ]; then
        zip -q -r $chapterStart.zip $chapterStart # zip the folder already download
        rm -r $chapterStart # delete the <open> folder and files
        echo -e "\nziped the folder $chapterStart and delete the folder $chapterStart\n"
    else
        echo -e "\nThe folder $chapterStart is empty, so none image was download.\n It <folder> was left up to you be aware of them\n"
    fi

    ((chapterStart+=1)) # increase to go to next chapter
done # end
cd .. # move to folder up, leaving the manga folder
#