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
# Última atualização: 07/09/2016
#
echo -e "\n ## Script to usual commands ##\n"

option="$1"

help () {
    echo "Options:"
    echo "              -men-info       - Show memory and swap percentage of use"
    echo "              -ap-info        - Show informations about the AP connected"
    echo "              -iw-l         * - List the Wi-Fi AP around with iw (show WPS and more)"
    echo "              -iwlist-l       - List the Wi-Fi AP around with iwlist (show WPA/2 and more)"
    echo "              -texlive-up   * - Update the texlive packages with the command iw and iwlist"
    echo "              -nm-list      + - List the Wi-Fi AP around with the nmcli from Network-Manager"
    echo "              -b1           * - Set brightness value (accept % value, up and down)"
    echo "              -b2             - Set brightness value with xbacklight (accept % value, up, down, up % and down %)"
    echo "              -date           - Update the date"
    echo "              -lpkg-i         - List of packages installed in the Slackware"
    echo "              -lpkg           - List last packages installed"
    echo "              -pdf            - Reduce a PDF"
    echo "              -swap         * - Clean up the Swap Memory"
    echo "              -slack-up     * - Slackware update"
    echo "              -up-db        * - Update the database for 'locate'"
    echo "              -w              - Show the weather forecast"
    echo "                     * - root required"
    echo "                     + - Network-Manager required"
}

case $option in
    "" | "--help" | "-h" )
        help
        ;;
    "-men-info" )
        echo -e "\tShow memory and swap percentage of use\n"

        memTotal=`free -m | grep Mem | awk '{print $2}'` # Get total of memory RAM
        memUsed=`free -m | grep Mem | awk '{print $3}'` # Get total of used memory RAM
        memUsedPercentage=`echo "scale=2; ($memUsed*100)/$memTotal" | bc` # Get the percentage "used/total"
        echo "Memory used: $memUsedPercentage % ($memUsed/$memTotal MiB)"

        testSwap=`free -m | grep Swap | awk '{print $2}'` # Test if has Swap configured

        if [ $testSwap -eq 0 ]; then
            echo "Swap is not configured in this computer"
        else
            swapTotal=`free -m | grep Swap | awk '{print $2}'`
            swapUsed=`free -m | grep Swap | awk '{print $3}'`
            swapUsedPercentage=`echo "scale=2; ($swapUsed*100)/$swapTotal" | bc`
            echo "Swap used: $swapUsedPercentage % ($swapUsed/$swapTotal MiB)"
        fi
        ;;
    "-ap-info" )
        echo -e "\tShow informations about the AP connected\n"

        /usr/sbin/iw dev wlan0 link
        ;;
    "-iw-l" )
        echo -e "\tList the Wi-Fi AP around, with iw (show WPS and more infos)\n"

        su - root -c '/usr/sbin/iw dev wlan0 scan | grep -E "wlan|SSID|signal|WPA|WEP|WPS|Authentication|WPA2"'
        ;;
    "-iwlist-l" )
        echo -e "\tList the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)\n"

        /sbin/iwlist wlan0 scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"
        ;;
    "-texlive-up" )
        echo -e "\tUpdate the texlive packages\n"

        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "-nm-list" )
        echo -e "\tList the Wi-Fi AP around with the nmcli from Network-Manager\n"

        nmcli device wifi list
        ;;
    "-b1" )
        echo -e "\tSet brightness percentage value\n"

        if [ $# -eq 1 ]; then
            brightnessValueOriginal=1
        else
            brightnessValueOriginal="$2"
        fi

        if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
            if [ $brightnessValueOriginal -gt "100" ]; then # Test max percentage
                brightnessValueOriginal=100
            fi
        fi

        # Choose the your path from "files brightness"
        if [ -f /sys/class/backlight/acpi_video0/brightness ]; then
            pathFile="/sys/class/backlight/acpi_video0"
        elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
            pathFile="/sys/class/backlight/intel_backlight"
        else
            echo -e "\n\tError, file to set brightness no found!\n"
        fi

        brightnessMax=`cat $pathFile/max_brightness` # Get max_brightness
        brightnessPercentage=`echo "scale=3; $brightnessMax/100" | bc` # Get the percentage of 1% from max_brightness

        actualBrightness=`cat $pathFile/actual_brightness`  # Get actual_brightness
        actualBrightness=`echo "scale=2; $actualBrightness/$brightnessPercentage" | bc`

        brightnessValue=$actualBrightness
        if [ "$2" == "up" ]; then # More 1 % (more 0.1 to appears correct percentage value in the GUI interface)
            brightnessValue=`scale=2; echo $brightnessValue + 1.1 | bc`
        elif [ "$2" == "down" ]; then # Less 1 % (more 0.1 to appears correct percentage value in the GUI interface)
            brightnessValue=`scale=2; echo $brightnessValue - 1.1 | bc`
        else # Set Input value more 0.1 to appears correct percentage value in the GUI interface
            brightnessValue=`echo "scale=1; $brightnessValueOriginal+0.1" | bc`
        fi

        brightnessValueFinal=`echo "scale=0; $brightnessPercentage*$brightnessValue/1" | bc` # Get no value percentage vs Input value brightness

        if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
            if [ $brightnessValueOriginal -gt "99" ]; then # If Input value brightness more than 99%, set max_brightness to brightness final
                brightnessValueFinal=$brightnessMax
            fi
        fi

        echo "File to set brightness: $pathFile/brightness"
        echo "Actual brightness: $actualBrightness %"
        echo "Input value brightness: $brightnessValueOriginal"
        echo "Final percentage brightness value: $brightnessValue"
        echo -e "Final set brightness value: $brightnessValueFinal\n"

        # Only for test
        #echo "Max brightness value: $brightnessMax" 
        #echo "Percentage value to 1% of brightness: $brightnessPercentage"

        # Set the final percentage brightness
        su - root -c "echo $brightnessValueFinal > $pathFile/brightness"
        ;;
    "-b2" )
        echo -e "\tSet brightness percentage value with xbacklight\n"

        if [ $# -eq 1 ]; then # Option without value set brightness in 1%
            xbacklight -set 1
        elif [ $# -eq 2 ]; then # Option to one value of input to set
            if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
                brightnessValue=$2
                if [ $brightnessValue -gt "100" ]; then # Test max percentage
                    brightnessValue=100
                fi
                xbacklight -set $brightnessValue
            else
                if [ "$2" == "up" ];then
                    xbacklight -inc 1
                elif [ "$2" == "down" ];then
                    xbacklight -dec 1
                else
                    echo -e "\n\tError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)\n"
                fi
            fi
        else #elif [ $# -eq 3 ]; then # Option to two value of input to set
            if echo $3 | grep -q [[:digit:]]; then # Test if has only digit
                if [ "$2" == "up" ];then
                    xbacklight -inc $3
                elif [ "$2" == "down" ];then
                    xbacklight -dec $3
                else
                    echo -e "\n\tError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)\n"
                fi
            else
                echo -e "\n\tError: Value must be only digit (e.g. $0 -b2 up 10 to set brightness up in 10 %)\n"
            fi
        fi
        ;;
    "-date" )
        echo -e "\tUpdate the date\n"

        /usr/sbin/ntpdate -u -b ntp1.ptb.de
        ;;
    "-lpkg-i" )
        echo -e "\tList of packages installed in the Slackware\n"

        countPackages=`ls -l /var/log/packages/ | cat -n | tail -n 1 | awk '{print $1}'`
        echo "There are $countPackages packages installed"
        ;;
    "-lpkg" )
        echo -e "\tList last packages installed\n"

        if [ $# -eq 1 ]; then
            numberPackages=10
        else
            if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
                numberPackages="$2"
            else
                numberPackages=10
            fi
        fi

        echo -e "List of the last $numberPackages packages installed\n"
        ls -l --sort=time /var/log/packages/ | head -n $numberPackages
        ;;
    "-pdf" ) # Need Ghostscript
        echo -e "\tReduce a PDF file\n"

        if [ $# -eq 1 ]; then
            echo -e "Error: Use $0 -pdf file.pdf\n" # Pdf not found
        else # Convert the file
            file="$2"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$file"-r.pdf "$file"
        fi
        ;;
    "-swap" )
        echo -e "\tClean up the Swap Memory\n"

        testSwap=`free -m | grep Swap | awk '{print $2}'` # Test if has Swap configured

        if [ $testSwap -eq 0 ]; then
            echo "Swap is not configured in this computer"
        else
            swapTotal=`free -m | grep Swap | awk '{print $2}'`
            swapUsed=`free -m | grep Swap | awk '{print $3}'`
            swapUsedPercentage=`echo "scale=2; ($swapUsed*100)/$swapTotal" | bc`

            echo -e "Swap used: $swapUsedPercentage % ($swapUsed/$swapTotal MiB)\n"

            if [ $swapUsedPercentage -eq 0 ]; then
                echo -e "\tSwap is alreday clean!"
            else
                su - root -c 'swapoff -a
                swapon -a'
            fi
        fi

        ;;
    "-slack-up" )
        echo -e "\tSlackware update\n"

        echo -en "Use blacklist?\nYes <Hit Enter> | No <type n>: "
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