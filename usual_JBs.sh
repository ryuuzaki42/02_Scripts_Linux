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
# Script: funções comum do dia a dia
#
# Última atualização: 06/10/2016
#
echo -e "\n #___ Script to usual commands ___#\n"

option="$1"

help () {
    echo "Options:"
    echo "              folder-diff    - Show the difference between two folder"
    echo "              ping-test      - Ping test on domain (default is google.com)"
    echo "              search-pwd     - Search in this directory for same pattern"
    echo "              create-wifi  * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
    echo "              cn-wifi      * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
    echo "              dc-wifi      * - Disconnect to one Wi-Fi network"
    echo "              men-info       - Show memory and swap percentage of use"
    echo "              ap-info        - Show information about the AP connected"
    echo "              l-iw         * - List the Wi-Fi AP around with iw (show WPS and more)"
    echo "              l-iwlist       - List the Wi-Fi AP around with iwlist (show WPA/2 and more)"
    echo "              texlive-up   * - Update the texlive packages with the command iw and iwlist"
    echo "              nm-list      + - List the Wi-Fi AP around with the nmcli from NetworkManager"
    echo "              brigh-1      * - Set brightness value (accept % value, up and down)"
    echo "              brigh-2      = - Set brightness value with xbacklight (accept % value, up, down, up % and down %)"
    echo "              date         * - Update the date"
    echo "              lpkg-c         - Count of packages that are installed in the Slackware"
    echo "              lpkg           - List last packages installed"
    echo "              pdf-r          - Reduce a PDF"
    echo "              swap-clean   * - Clean up the Swap Memory"
    echo "              slack-up     * - Slackware update"
    echo "              up-db        * - Update the database for 'locate'"
    echo "              weather        - Show the weather forecast"
    echo "              now          * - Run texlive-up date swap-clean slack-up up-db"
    echo "Obs: * root required, + NetworkManager required, = X server required"
}

case $option in
    "" | "--help" | "-h" )
        help
        ;;
    "folder-diff" )
        echo "# Show the difference between two folder #"
        if [ $# -lt 3 ]; then
            echo -e "\n\tError: Need two parameters, $0 folder-dif 'pathSource' 'pathDestination'"
        else
            pathSource=$2
            pathDestination=$3
            echo -e "\nSource: $pathSource"
            echo "Destination: $pathDestination"

            if [ -x $pathSource ]; then # Test if 'source' exists
                if [ -x $pathDestination ]; then # Test if 'destination' exists
                    echo -e "\nPlease wait until all files are compared ...\n"
                    folderChanges=`rsync -aicn --delete $pathSource $pathDestination` # | grep ">"`
                    # -a archive mode; # -i output a change-summary for all updates
                    # -c skip based on checksum, not mod-time & size; # -n perform a trial run with no changes made
                    # --delete delete extraneous files from destination directories

                    filesDelete=`echo -e "$folderChanges" | grep "*deleting" | awk '{print substr($0, index($0,$2))}'`
                    if [ "$filesDelete" != "" ]; then
                        echo -e "\nFiles to be delete:\n$filesDelete"
                    fi

                    filesDifferent=`echo -e "$folderChanges" | grep "fcstp" | awk '{print substr($0, index($0,$2))}'`
                    if [ "$filesDifferent" != "" ]; then
                        echo -e "\nFiles different:\n$filesDifferent"
                    fi

                    filesNew=`echo -e "$folderChanges" | grep "f+++"| awk '{print substr($0, index($0,$2))}'`
                    if [ "$filesNew" != "" ]; then
                        echo -e "\nNew files:\n$filesNew"
                    fi

                    if [ "$filesDelete" == "" ] && [ "$filesDifferent" == "" ] && [ "$filesNew" == "" ]; then
                        echo -e "\nThe source and the destination don't have difference\nSource: $pathSource\nDestination: $pathDestination\n"
                    else
                        echo -en "\nShow rsync change-summary?\n(y)es or (N)o: "
                        read showRsyncS
                        if [ "$showRsyncS" == "y" ]; then
                            echo -e "\n$folderChanges"
                        fi

                        echo -en "\nMake this change in disk?\n(y)es or (N)o: "
                        read continueWriteDisk
                        if [ "$continueWriteDisk" == y ]; then
                            echo -e "Changes are writing in $pathDestination\nPlease wait...\n"
                            rsync -crvh --delete $pathSource $pathDestination
                        else
                            echo -e "\n\tAny change write in disk"
                        fi
                    fi
                else
                    echo -e "\n\tError: The destination ($pathDestination) don't exists"
                fi
            else
                echo -e "\n\tError: The source ($pathSource) don't exists"
            fi
        fi
        ;;
    "search-pwd" )
        echo "# Search in this directory for same pattern #"
        echo -en "\nPattern to search: "
        read patternSearch

        echo
        grep -rn $PWD -e $patternSearch
        ;;
    "ping-test" )
        echo -e "# Ping test on domain (default is google.com) #\n"
        if [ $# -eq 1 ]; then
            domainPing="google.com"
        else
            domainPing="$2"
        fi

        ping -c 3 $domainPing
        ;;
    "create-wifi" )
        echo -e "# Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #\n"
        su - root -c 'echo -n "Name of the network (SSID): "
        read netSSID

        echo -n "Password of this network: "
        read -s netPassword

        wpa_passphrase "$netSSID" "$netPassword" | grep -v "#psk" >> /etc/wpa_supplicant.conf'
        ;;
    "cn-wifi" )
        echo -e "# Connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #\n"
        if ps faux | grep "NetworkManager" | grep -v -q "grep"; then # Test if NetworkManager is running
            echo -e "\n\tError: NetworkManager is running, please kill him with: killall NetworkManager"
        else
            if [ "$LOGNAME" != "root" ]; then
                echo -e "\n\tError: Execute as root user"
            else
                killall wpa_supplicant # kill the previous wpa_supplicant "configuration"

                networkConfigAvaiable=`cat /etc/wpa_supplicant.conf | grep "ssid"`
                if [ "$networkConfigAvaiable" == "" ]; then
                    echo -e "\n\tError: Not find configuration of anyone network (in /etc/wpa_supplicant.conf). Try: $0 create-wifi"
                else
                    echo "Choose one network to connect"
                    cat /etc/wpa_supplicant.conf | grep "ssid"
                    echo -n "Network name: "
                    read networkName

                    # sed -n '/Beginning of block/!b;:a;/End of block/!{$!{N;ba}};{/some_pattern/p}' filename # sed in block text
                    wpaConf=`sed -n '/network/!b;:a;/}/!{$!{N;ba}};{/'$networkName'/p}' /etc/wpa_supplicant.conf`

                    if [ "$wpaConf" == "" ]; then
                        echo -e "\n\tError: Not find configuration to network '$networkName' (in /etc/wpa_supplicant.conf). Try: $0 create-wifi"
                    else
                        TMPFILE=`mktemp` # Create a TMP-file
                        cat /etc/wpa_supplicant.conf | grep -v -E  "{|}|ssid|psk" > $TMPFILE

                        echo -e "$wpaConf" >> $TMPFILE # Save the configuration of the network on this file

                        echo -e "\n########### Network configuration ####################"
                        cat $TMPFILE
                        echo -e "######################################################"

                        #wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -d -B wext # Normal command
                        wpa_supplicant -i wlan0 -c $TMPFILE -d -B wext # Connect with the network using the TMP-file

                        rm $TMPFILE # Delete the TMP-file

                        dhclient wlan0 # Get IP

                        iw dev wlan0 link # Show status of the connection
                    fi
                fi
            fi
        fi
        ;;
    "dc-wifi" )
        echo -e "# Desconnect to one Wi-Fi network #\n"
        su - root -c 'dhclient -r wlan0
        ifconfig wlan0 down
        iw dev wlan0 link'
        ;;
    "men-info" )
        echo "# Show memory and swap percentage of use #"
        memTotal=`free -m | grep Mem | awk '{print $2}'` # Get total of memory RAM
        memUsed=`free -m | grep Mem | awk '{print $3}'` # Get total of used memory RAM
        memUsedPercentage=`echo "scale=0; ($memUsed*100)/$memTotal" | bc` # Get the percentage "used/total", |valueI*100/valueF|
        echo -e "\nMemory used: ~ $memUsedPercentage % ($memUsed of $memTotal MiB)"

        testSwap=`free -m | grep Swap | awk '{print $2}'` # Test if has Swap configured
        if [ $testSwap -eq 0 ]; then
            echo "Swap is not configured in this computer"
        else
            swapTotal=`free -m | grep Swap | awk '{print $2}'`
            swapUsed=`free -m | grep Swap | awk '{print $3}'`
            swapUsedPercentage=`echo "scale=0; ($swapUsed*100)/$swapTotal" | bc` # |valueI*100/valueF|
            echo "Swap used: ~ $swapUsedPercentage % ($swapUsed of $swapTotal MiB)"
        fi
        ;;
    "ap-info" )
        echo -e "# Show information about the AP connected #\n"
        echo -e "\n/usr/sbin/iw dev wlan0 link:"
        /usr/sbin/iw dev wlan0 link
        echo -e "\n/sbin/iwconfig wlan0:"
        /sbin/iwconfig wlan0
        ;;
    "l-iw" )
        echo -e "# List the Wi-Fi AP around, with iw (show WPS and more infos) #\n"
        su - root -c '/usr/sbin/iw dev wlan0 scan | grep -E "wlan|SSID|signal|WPA|WEP|WPS|Authentication|WPA2"'
        ;;
    "l-iwlist" )
        echo -e "# List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos) #\n"
        /sbin/iwlist wlan0 scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"
        ;;
    "texlive-up" )
        echo -e "# Update the texlive packages #\n"
        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "nm-list" )
        echo -e "# List the Wi-Fi AP around with the nmcli from NetworkManager #\n"
        nmcli device wifi list
        ;;
    "brigh-1" )
        echo "# Set brightness percentage value #"
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

        if [ -f /sys/class/backlight/acpi_video0/brightness ]; then # Choose the your path from "files brightness"
            pathFile="/sys/class/backlight/acpi_video0"
        elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
            pathFile="/sys/class/backlight/intel_backlight"
        else
            echo -e "\n\tError, file to set brightness not found"
        fi

        if [ "$pathFile" != "" ]; then
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

            echo -e "\nFile to set brightness: $pathFile/brightness"
            echo "Actual brightness: $actualBrightness %"
            echo "Input value brightness: $brightnessValueOriginal"
            echo "Final percentage brightness value: $brightnessValue"
            echo -e "Final set brightness value: $brightnessValueFinal\n"

            # Only for test
            #echo "Max brightness value: $brightnessMax" 
            #echo "Percentage value to 1% of brightness: $brightnessPercentage"

            # Set the final percentage brightness
            su - root -c "echo $brightnessValueFinal > $pathFile/brightness"
        fi
        ;;
    "brigh-2" )
        echo "# Set brightness percentage value with xbacklight #"
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
                    echo -e "\n\tError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)"
                fi
            fi
        else #elif [ $# -eq 3 ]; then # Option to two value of input to set
            if echo $3 | grep -q [[:digit:]]; then # Test if has only digit
                if [ "$2" == "up" ];then
                    xbacklight -inc $3
                elif [ "$2" == "down" ];then
                    xbacklight -dec $3
                else
                    echo -e "\n\tError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)"
                fi
            else
                echo -e "\n\tError: Value must be only digit (e.g. $0 brigh-2 up 10 to set brightness up in 10 %)"
            fi
        fi
        ;;
    "date" )
        echo -e "# Update the date #\n"
        su - root -c 'ntpdate -u -b ntp1.ptb.de'
        ;;
    "lpkg-c" )
        echo "# Count of packages that are installed in the Slackware #"
        countPackages=`ls -l /var/log/packages/ | cat -n | tail -n 1 | awk '{print $1}'`
        echo -e "\nThere are $countPackages packages installed"
        ;;
    "lpkg" )
        echo "# List last packages installed #"
        if [ $# -eq 1 ]; then
            numberPackages=10
        else
            if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
                numberPackages="$2"
            else
                numberPackages=10
            fi
        fi

        echo -e "\nList of the last $numberPackages packages installed\n"
        ls -l --sort=time /var/log/packages/ | head -n $numberPackages | grep -v "total [[:digit:]]"
        ;;
    "pdf-r" ) # Need Ghostscript
        echo -e "# Reduce a PDF file #\n"
        if [ $# -eq 1 ]; then
            echo -e "\n\tError: Use $0 pdf-r file.pdf"
        else # Convert the file
            filePdfInput="$2"
            if [ -e "$filePdfInput" ]; then
                filePdfOutput=${filePdfInput::-4}
                gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$filePdfOutput"_r.pdf "$filePdfInput"
                echo -e "\nThe output pdf file: \""$filePdfOutput"_r.pdf\" was saved"
            else # Pdf not found
                echo -e "\n\tError: The file $filePdfInput not exists"
            fi
        fi
        ;;
    "swap-clean" )
        echo "# Clean up the Swap Memory #"
        testSwap=`free -m | grep Swap | awk '{print $2}'` # Test if has Swap configured
        if [ $testSwap -eq 0 ]; then
            echo "\nSwap is not configured in this computer"
        else
            swapTotal=`free -m | grep Swap | awk '{print $2}'`
            swapUsed=`free -m | grep Swap | awk '{print $3}'`
            swapUsedPercentage=`echo "scale=0; ($swapUsed*100)/$swapTotal" | bc` # |valueI*100/valueF|

            echo -e "\nSwap used: ~ $swapUsedPercentage % ($swapUsed of $swapTotal MiB)"

            if [ $swapUsed -eq 0 ]; then
                echo -e "\nSwap is already clean!"
            else
                echo -en "\nTry clean the Swap? \n(y)es - (n)o: "
                read cleanSwap

                if [ "$cleanSwap" == "y" ]; then
                    su - root -c 'echo -e "\nCleanning swap\nPlease wait..."
                    swapoff -a
                    swapon -a'
                fi
            fi
        fi
        ;;
    "slack-up" )
        echo "# Slackware update #"
        echo -en "\nUse blacklist?\nYes <Hit Enter> | No <type n>: "
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
    "up-db" )
        echo -e "# Update the database for 'locate' #\n"
        su - root -c "updatedb" # Update de database
        echo -e "\nDatabase updated"
        ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos # Download the information weather
        ;;
     "now" )
        echo -e "# now * - Run texlive-up date swap-clean slack-up up-db #\n"

        $0 texlive-up
        $0 date
        $0 swap-clean
        $0 slack-up
        $0 up-db
        ;;
    * )
        echo -e "\n\t$(basename "$0"): Error of parameters"
        echo -e "\tTry $0 '--help'"
        ;;
esac
echo -e "\n#___ So Long, and Thanks for All the Fish ___#\n"
