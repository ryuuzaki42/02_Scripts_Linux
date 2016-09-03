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
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: funções comum do dia a dia
#
# Última atualização: 26/08/2016
#
echo -e "\n ## Script to usual command ##\n"

option="$1"

help () {
    echo "Options available:"
    echo "              -b              - Set brightness value"
    echo "              -d              - Update the date"
    echo "              -lpkg           - List last packages installed"
    echo "              -pdf            - Reduce a PDF"
    echo "              -swap           - Clean up the Swap Memory"
    echo "              -slackup        - Slackware update"
    echo "              -updb           - Update the database for 'locate'"
    echo "              -w              - Show the weather forecast"
}

case $option in
    "--help" )
        help
        ;;
    "" )
        help
        ;;
    "-b" )
        echo -e "\tSet brightness percentage value\n"
        if [ $# -eq 1 ]; then
            brightnessValueOriginal=1
        else
            brightnessValueOriginal="$2"
        fi

        if [ $brightnessValueOriginal -gt "100" ]; then
            brightnessValueOriginal=100
        fi

        # Set more 0.1 to appears the correct percentage value in the GUI interface
        brightnessValue=`echo "scale=1; $brightnessValueOriginal+0.1" | bc`

        # Choose the your path file brightness
        #pathFile="/sys/class/backlight/acpi_video0/brightness"

        pathFile="/sys/class/backlight/intel_backlight/brightness"
        brightnessMax=`cat /sys/class/backlight/intel_backlight/max_brightness`
        brightnessPercentage=`echo "scale=3; $brightnessMax/100" | bc`

        brightnessValueFinal=`echo "scale=0; $brightnessPercentage*$brightnessValue/1" | bc`

        if [ $brightnessValueOriginal -gt "99" ]; then
            brightnessValueFinal=$brightnessMax
        fi

        echo "Input value brightness: $brightnessValueOriginal"
        echo "Path: $pathFile"
        echo "Max brightness value: $brightnessMax"
        echo "Percentage value to 1% of brightness: $brightnessPercentage"
        echo -e "Final set brightness value: $brightnessValueFinalz\n"

        su - root -c "
        echo $brightnessValueFinal > $pathFile"
        ;;
    "-d" )
        echo -e "\tUpdate the date\n"
        su - root -c "ntpdate -u -b ntp1.ptb.de"
        ;;
    "-lpkg" )
        echo -e "\tList last packages installed\n"
        if [ $# -eq 1 ]; then
            line=10
        else
            line="$2"
        fi
        echo -e "Listing the last $line packages installed\n"
        ls -l --sort=time /var/log/packages/ | head -n $line
        echo
        ;;
    "-pdf" ) # Need Ghostscript
        echo -e "\tReduce a PDF\n"
        if [ $# -eq 1 ]; then
            echo -e "Error, use $0 pdf file.pdf\n"
        else
            arquivo="$2"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$arquivo"-r.pdf "$arquivo"
        fi
        ;;
    "-swap" )
        echo -e "\tClean up the Swap Memory\n"
        su - root -c 'swapoff -a
        swapon -a'
        ;;
    "-slackup" )
        echo -e "\tSlackware update\n"
        echo "Use blacklist?"
        echo -n "Yes <Hit Enter> | No <type n>: "
        read useBL
        if [ "$useBL" == "n" ]; then
            su - root -c "
            slackpkg update gpg
            slackpkg update
            USEBL=0 slackpkg upgrade-all"
        else
            su - root -c "
            slackpkg update gpg
            slackpkg update
            USEBL=1 slackpkg upgrade-all"
        fi
        ;;
    "-updb" )
        echo -e "\tUpdate the database for 'locate'\n"
        su - root -c "updatedb"
        ;;
    "-w" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos
        ;;
    * )
        echo -e "\t$(basename "$0"): error of parameters"
        echo -e "\tTry $0 '--help'"
        ;;
esac
echo -e "\n\tSo Long, and Thanks for All the Fish!\n"
#