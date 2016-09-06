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
# Última atualização: 06/09/2016
#
echo -e "\n ## Script to usual commands ##\n"

option="$1"

help () {
    echo "Options:"
    echo "              -ap-info        - Show informations about the AP connected"
    echo "              -wifi-list      - List the Wi-Fi AP arround"
    echo "              -texlive-up     - Update the texlive packages with the comand iw and iwlist"
    echo "              -nm-list        - List the Wi-Fi AP arround with the nmcli from Network-Manager"
    echo "              -b              - Set brightness value"
    echo "              -date           - Update the date"
    echo "              -lpkg           - List last packages installed"
    echo "              -pdf            - Reduce a PDF"
    echo "              -swap           - Clean up the Swap Memory"
    echo "              -slack-up       - Slackware update"
    echo "              -up-db          - Update the database for 'locate'"
    echo "              -w              - Show the weather forecast"
}

case $option in
    "" | "--help" | "-h" )
        help
        ;;
    "-ap-info" )
        echo -e "\tShow informations about the AP connected\n"
        su - root -c "iw dev wlan0 link"
        ;;
    "-wifi-list" )
        echo -e "\tList the Wi-Fi AP arround\n"
        echo -e "\n\t\t\tWith iw (show WPS and more infos)\n\n"
        su - root -c 'iw dev wlan0 scan | grep -E "wlan|SSID|signal|WPA|WEP|WPS|Authentication|WPA2"'
        echo -e "\n\n\n\t\t\tWith iwlist (show WPA/2 and more infos)\n\n"
        su - root -c 'iwlist wlan0 scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"'
        ;;
    "-texlive-up" )
        echo -e "\tUpdate the texlive packages\n"
        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "-nm-list" )
        echo -e "\tList the Wi-Fi AP arround with the nmcli from Network-Manager\n"
        nmcli device wifi list
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

        # Choose the your path from "files brightness"
        if [ -f /sys/class/backlight/acpi_video0/brightness ]; then
            pathFile="/sys/class/backlight/acpi_video0/"
        elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
            pathFile="/sys/class/backlight/intel_backlight/"
        else
            echo -e "\n\tError, file to set brightness no found!\n"
            exit 1
        fi

        brightnessMax=`cat $pathFile/max_brightness` # Get max_brightness
        brightnessPercentage=`echo "scale=3; $brightnessMax/100" | bc` # Get the percentage of 1% from max_brightness

        brightnessValueFinal=`echo "scale=0; $brightnessPercentage*$brightnessValue/1" | bc` # Get no value percentage vs Input value brightness

        if [ $brightnessValueOriginal -gt "99" ]; then # If Input value brightness more than 99%, set max_brightness to brightness final
            brightnessValueFinal=$brightnessMax
        fi

        echo "Input value brightness: $brightnessValueOriginal"
        echo "Path: $pathFile"
        echo "Max brightness value: $brightnessMax"
        echo "Percentage value to 1% of brightness: $brightnessPercentage"
        echo -e "Final set brightness value: $brightnessValueFinalz\n"

        # Set the final percentage
        su - root -c "
        echo $brightnessValueFinal > $pathFile/brightness"
        ;;
    "-date" )
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
            echo -e "Error, use $0 pdf file.pdf\n" # Pdf not found
        else # Convert the file
            arquivo="$2"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$arquivo"-r.pdf "$arquivo"
        fi
        ;;
    "-swap" )
        echo -e "\tClean up the Swap Memory\n"
        su - root -c 'swapoff -a
        swapon -a'
        ;;
    "-slack-up" )
        echo -e "\tSlackware update\n"
        echo "Use blacklist?"
        echo -n "Yes <Hit Enter> | No <type n>: "
        read useBL
        if [ "$useBL" == "n" ]; then # slackpkg not using USEBL
            su - root -c "slackpkg update gpg
            slackpkg update
            USEBL=0 slackpkg upgrade-all"
        else # slackpkg using USEBL
            su - root -c "slackpkg update gpg
            slackpkg update
            USEBL=1 slackpkg upgrade-all"
        fi
        ;;
    "-up-db" )
        echo -e "\tUpdate the database for 'locate'\n"
        su - root -c "updatedb" # Update de database
        ;;
    "-w" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos # Download the information weather
        ;;
    * )
        echo -e "\t$(basename "$0"): error of parameters"
        echo -e "\tTry $0 '--help'"
        ;;
esac
echo -e "\n\tSo Long, and Thanks for All the Fish!\n"
#