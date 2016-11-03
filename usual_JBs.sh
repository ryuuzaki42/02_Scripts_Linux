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
# Last update: 26/10/2016
#
optionTmp="$1"
if [ "$optionTmp" != "notPrint" ]; then
    echo -e "\n #___ Script to usual commands ___#\n"
else
    shift
fi

option="$1"

whiptailMenu() {
    eval `resize`
    item=$(whiptail --title "#___ Script to usual commands ___#" --menu "Obs: * root required, + NetworkManager required, = X server required

    Options:" $(( $LINES -5 )) $(( $COLUMNS -5 )) $(( $LINES -15 )) \
    "ap-info"      "   - Show information about the AP connected" \
    "brigh-1"      " * - Set brightness percentage value (accept % value, up and down)" \
    "brigh-2"      " = - Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %)" \
    "cn-wifi"      " * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)" \
    "cpu-max"      "   - Show the 10 process with more CPU use" \
    "create-wifi"  " * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)" \
    "date-up"      " * - Update the date" \
    "day-install"  "   - The day the system are installed" \
    "dc-wifi"      " * - Disconnect to one Wi-Fi network" \
    "folder-diff"  "   - Show the difference between two folder and (can) make them equal (with rsync)" \
    "ip"           "   - Get your IP" \
    "l-iw"         " * - List the Wi-Fi AP around, with iw (show WPS and more infos)" \
    "l-iwlist"     "   - List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)" \
    "lpkg-c"       "   - Count of packages that are installed in the Slackware" \
    "lpkg-i"       "   - List last packages installed (accept 'n', where 'n' is a number of packages, the default is 10)" \
    "lpkg-r"       "   - List last packages removed (accept 'n', where 'n' is a number of packages, the default is 10)" \
    "mem-max"      "   - Show the 10 process with more memory RAM use" \
    "mem-use"      "   - Get the all (shared and specific) use of memory RAM from one process/pattern" \
    "men-info"     "   - Show memory and swap percentage of use" \
    "nm-list"      " + - List the Wi-Fi AP around with the nmcli from NetworkManager" \
    "now"          " * - Run \"texlive-up\" \"date-up\" \"swap-clean\" \"slack-up n\" and \"up-db\" sequentially " \
    "pdf-r"        "   - Reduce a PDF file" \
    "ping-test"    "   - Ping test on domain (default is google.com)" \
    "print-lines"  "   - Print part of file (lineStart to lineEnd)" \
    "screenshot"   "   - Screenshot from display :0" \
    "search-pwd"   "   - Search in this directory (recursive) for a pattern" \
    "slack-up"     " * - Slackware update" \
    "swap-clean"   " * - Clean up the Swap Memory" \
    "texlive-up"   " * - Update the texlive packages" \
    "up-db"        " * - Update the database for 'locate'" \
    "weather"      "   - Show the weather forecast (you can change the city in the script)" \
    "work-fbi"     "   - Write <zero>/<random> value in one ISO file to wipe trace of old deleted file" \
    "search-pkg"   "   - Search in the installed package folder (/var/log/packages/) for one pattern" 3>&1 1>&2 2>&3)

    if [ "$item" != "" ]; then
        echo -e "\nRunning: $0 notPrint $item $1 $2\n"
        $0 notPrint $item $1 $2
    fi
}

help() {
    echo "Options:

    Obs: * root required, + NetworkManager required, = X server required

    ap-info        - Show information about the AP connected
    brigh-1      * - Set brightness percentage value (accept % value, up and down)
    brigh-2      = - Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %)
    cn-wifi      * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)
    cpu-max        - Show the 10 process with more CPU use
    create-wifi  * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)
    date-up      * - Update the date
    day-install    - The day the system are installed
    dc-wifi      * - Disconnect to one Wi-Fi network
    folder-diff    - Show the difference between two folder and (can) make them equal (with rsync)
    ip             - Get your IP
    l-iw         * - List the Wi-Fi AP around, with iw (show WPS and more infos)
    l-iwlist       - List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)
    lpkg-c         - Count of packages that are installed in the Slackware
    lpkg-i         - List last packages installed (accept 'n', where 'n' is a number of packages, the default is 10)
    lpkg-r         - List last packages removed (accept 'n', where 'n' is a number of packages, the default is 10)
    mem-max        - Show the 10 process with more memory RAM use
    mem-use        - Get the all (shared and specific) use of memory RAM from one process/pattern
    men-info       - Show memory and swap percentage of use
    nm-list      + - List the Wi-Fi AP around with the nmcli from NetworkManager
    now          * - Run \"texlive-up\" \"date-up\" \"swap-clean\" \"slack-up n\" and \"up-db\" sequentially
    pdf-r          - Reduce a PDF file
    ping-test      - Ping test on domain (default is google.com)
    print-lines    - Print part of file (lineStart to lineEnd)
    screenshot     - Screenshot from display :0
    search-pkg     - Search in the installed package folder (/var/log/packages/) for one pattern
    search-pwd     - Search in this directory (recursive) for a pattern
    slack-up     * - Slackware update
    swap-clean   * - Clean up the Swap Memory
    texlive-up   * - Update the texlive packages
    up-db        * - Update the database for 'locate'
    weather        - Show the weather forecast (you can change the city in the script)
    work-fbi       - Write <zero>/<random> value in one ISO file to wipe trace of old deleted file
    w or ''        - Menu with whiptail (where you can call another options)"
}

case $option in
    '' | 'w' )
        whiptailMenu $2 $3
        ;;
    "--help" | "-h" )
        help
        ;;
     "mem-use" )
        echo -e "# Get the all (shared and specific) use of memory RAM from one process/pattern #\n"
        if [ "$2" == '' ]; then
            echo -n "Insert the pattern (process name) to search: "
            read process
        else
            process=$2
        fi

        if  [ "$process" != '' ]; then
            processList=`ps aux | grep $process`
            #ps -C chrome -o %cpu,%mem,cmd

            memPercentage=`echo "$processList" | awk '{print $4}'`

            memPercentageSum=0
            for memPercentageNow in $memPercentage; do
                memPercentageSum=`echo "scale=2; $memPercentageSum+$memPercentageNow" | bc`
            done

            totalMem=`free -m | head -n 2 | tail -n 1 | awk '{print $2}'`
            useMem=`echo "($totalMem*$memPercentageSum)/100" | bc`

            echo -e "\nThe process \"$process\" uses: $useMem MiB or $memPercentageSum % of $totalMem MiB\n"

            echo -en "Show the process list?\n(y)es - (n)o: "
            read showProcessList

            echo
            if [ "$showProcessList" == 'y' ]; then
                echo -e "$processList"
                echo
            fi
        else
            echo -e "\n\tError: You need insert some pattern/process name to search, e.g., $0 mem-use opera"
        fi
        ;;
     "search-pkg" )
        echo -e "# Search in the installed package folder (/var/log/packages/) for one pattern #\n"
        if [ "$2" == '' ]; then
            echo -n "Package file or pattern to search: "
            read filePackage
        else
            filePackage=$2
        fi

        echo -en "\nSearching, please wait..."

        tmpFileName=`mktemp` # Create a TMP-file
        tmpFileFull=`mktemp` # Create a TMP-file

        for fileInTheFolder in /var/log/packages/*; do
            if cat $fileInTheFolder | grep -q $filePackage; then # Grep the "filePackage" from the file in /var/log/packages
                cat $fileInTheFolder | grep "PACKAGE NAME" >> $tmpFileName # Grep the package name from the has the "filePackage"
                cat $fileInTheFolder >> $tmpFileFull # Print all info about the package
                echo >> $tmpFileFull # Insert one new line
            fi
        done

        sizeResultFile=`ls -l $tmpFileName | awk '{print $5}'`

        if [ "$sizeResultFile" != '0' ]; then
            echo -e "\n\nResults saved in \"$tmpFileName\" and \"$tmpFileFull\" tmp files\n"

            echo -en "Open this files with kwrite or print them in the terminal?\n(k)write - (t)erminal: "
            read openProgram

            if [ "$openProgram" == 'k' ]; then
                kwrite $tmpFileName
                kwrite $tmpFileFull
            else
                echo -e "\nPackage(s) with '$filePackage':\n"
                cat $tmpFileName

                echo -en "\nPrint this package(s) in terminal?\n(y)es - (p)artial, only the matches - (n)o: "
                read continuePrint
                echo
                if [ "$continuePrint" == 'y' ]; then
                    cat $tmpFileFull
                elif [ "$continuePrint" == 'p' ]; then
                    cat $tmpFileFull | grep "$filePackage"
                fi
            fi
        else
            echo -e "\n\n\tNo result was found"
        fi

        echo -e "\nDeleting the log files used in this script"
        rm $tmpFileName $tmpFileFull
        ;;
    "work-fbi" )
        echo "# Write <zero>/<random> value in one ISO file to wipe trace of old deleted file #"
        echo -e "\nWarning: depending on how big is your Hard drive, this can take a long time"
        echo -en "Want continue?\n(y)es - (n)o: "
        read contineDd

        if [ "$contineDd" == 'y' ]; then
            fileName="work-fbi_" # Create a iso file with a random part name
            fileName+=`date +%s | md5sum | head -c 10`
            fileName+=".iso"

            echo "You can use <zero> or <random> value"
            echo "Using <random> value is better to overwrite your deleted file"
            echo "Otherwise, is slower (almost 10 times) then use <zero> value"
            echo "Long story short, use <zero> if you has not deleted pretty good sensitive data"
            echo -en "\nUse random or zero value?\n(r)andom - (z)ero: "
            read continueRandomOrZero

            if [ "$continueRandomOrZero" == 'r' ]; then
                dd if=/dev/urandom of=$fileName iflag=nocache oflag=direct bs=1M  conv=notrunc status=progress # Write <random> value to wipe the data
                echo -en "\nWriting <random> value in the \"$fileName\" tmp file\nPlease wait...\n\n"
            else
                echo -en "\nWriting <zero> value in the \"$fileName\" tmp file\nPlease wait...\n\n"
                dd if=/dev/zero of=$fileName iflag=nocache oflag=direct bs=1M  conv=notrunc status=progress # Write <zero> value to wipe the data
            fi

            rm $fileName # Delete the <big> file generated
            echo -e "\nThe \"$fileName\" tmp file was deleted"
        fi
        ;;
    "ip" )
        echo -e "# Get your IP #\n"
        localIP=`/sbin/ifconfig | grep broadcast | awk '{print $2}'`
        echo "Local IP: $localIP"

        externalIP=`wget -qO - icanhazip.com`
        echo "External IP: $externalIP"
        ;;
    "cpu-max" )
        echo -e "# Show the 10 process with more CPU use #\n"
        ps axo pid,%cpu,%mem,cmd --sort=-pcpu | head -n 11
        ;;
    "mem-max" )
        echo -e "# Show the 10 process with more memory RAM use #\n"
        ps axo pid,%cpu,%mem,cmd --sort -rss | head -n 11
        ;;
    "day-install" )
        echo -e "# The day the system are installed #"
        dayInstall=`ls -alct / | tail -n 1 | awk '{print $6, $7, $8}'`
        echo -e "\nThe system was installed at the time: $dayInstall"
        ;;
    "print-lines" )
        echo -e "# Print part of file (lineStart to lineEnd) #"
        inputFile=$2 # File to read

        if [ "$inputFile" == '' ]; then
            echo -e "\n\tError: You need to pass the file name, e.g., $0 print-lines file.txt"
        else
            lineStart=$3
            lineEnd=$4

            if [ "$lineStart" == '' ] || [ "$lineEnd" == '' ]; then
                echo -n "Line to start: "
                read lineStart
                echo -n "Line to end: "
                read lineEnd
            fi

            if echo $lineStart | grep -q [[:digit:]] && echo $lineEnd | grep -q [[:digit:]]; then
                if [ $lineStart -gt $lineEnd ]; then
                    echo -e "\n\tError: lineStart must be smaller than lineEnd"
                else
                    echo -e "\nPrint \"$inputFile\" line $lineStart to $lineEnd\n"
                    lineStartTmp=$((lineEnd-lineStart))
                    ((lineStartTmp++))

                    cat -n $inputFile | head -n $lineEnd | tail -n $lineStartTmp
                fi
            else
                echo -e "\n\tError: lineStart and lineEnd must be number"
            fi
        fi
        ;;
    "screenshot" )
        echo -e "# Screenshot from display :0 #\n"
        dateNow=`date`
        import -window root -display :0 screenshot_"$dateNow".jpg
        echo "Screenshot \"screenshot_"$dateNow".jpg\" saved"
        ;;
    "folder-diff" )
        echo "# Show the difference between two folder and (can) make them equal (with rsync) #"
        if [ $# -lt 3 ]; then
            echo -e "\n\tError: Need two parameters, $0 folder-dif 'pathSource' 'pathDestination'"
        else
            echo -e "\n\t## An Important Note ##\n"
            echo "The trailing slash (/) at the end of the first argument (source folder). For example: \"rsync -a dir1/ dir2\""
            echo "This is necessary to mean \"the contents of dir1\". The alternative, without the trailing slash, would place dir1,"
            echo -e "including the directory, within dir2. This would create a hierarchy that looks like: dir2/dir1/[files]"
            echo "## Please double-check your arguments before continue ##"

            pathSource=$2
            pathDestination=$3
            echo -e "\nSource folder: $pathSource"
            echo "Destination folder: $pathDestination"

            echo -en "\nWant continue and use these source and destination folders?\n(y)es - (n)o: "
            read continueRsync

            if [ "$continueRsync" == 'y' ]; then
                if [ -e "$pathSource" ]; then # Test if 'source' exists
                    if [ -e "$pathDestination" ]; then # Test if 'destination' exists
                        echo -en "\nPlease wait until all files are compared..."
                        folderChanges=`rsync -aicn --delete "$pathSource" "$pathDestination"`
                        # -a archive mode; -i output a change-summary for all updates
                        # -c skip based on checksum, not mod-time & size; -n perform a trial run with no changes made
                        # --delete delete extraneous files from destination directories

                        echo # just a new blank line
                        filesDelete=`echo -e "$folderChanges" | grep "*deleting" | awk '{print substr($0, index($0,$2))}'`
                        if [ "$filesDelete" != '' ]; then
                            echo -e "\nFiles to be deleted:\n$filesDelete"
                        fi

                        filesDifferent=`echo -e "$folderChanges" | grep "fcstp" | awk '{print substr($0, index($0,$2))}'`
                        if [ "$filesDifferent" != '' ]; then
                            echo -e "\nFiles different:\n$filesDifferent"
                        fi

                        filesNew=`echo -e "$folderChanges" | grep "f+++"| awk '{print substr($0, index($0,$2))}'`
                        if [ "$filesNew" != '' ]; then
                            echo -e "\nNew files:\n$filesNew"
                        fi

                        if [ "$filesDelete" == '' ] && [ "$filesDifferent" == '' ] && [ "$filesNew" == '' ]; then
                            echo -e "\nThe source folder ("$pathSource") and the destination folder ("$pathDestination") don't any difference"
                        else
                            echo -en "\nShow rsync change-summary?\n(y)es - (n)o: "
                            read showRsyncS
                            if [ "$showRsyncS" == 'y' ]; then
                                echo -e "\n$folderChanges"
                            fi

                            echo -en "\nMake this change in the disk?\n(y)es - (n)o: "
                            read continueWriteDisk
                            if [ "$continueWriteDisk" == 'y' ]; then
                                echo -e "Changes are writing in "$pathDestination"\nPlease wait..."
                                rsync -crvh --delete "$pathSource" "$pathDestination"
                            else
                                echo -e "\n\tAny change writes in disk"
                            fi
                        fi
                    else
                        echo -e "\n\tError: The destination ($pathDestination) don't exist"
                    fi
                else
                    echo -e "\n\tError: The source ($pathSource) don't exist"
                fi
            else
                echo -e "\n\tAny change writes in disk"
            fi
        fi
        ;;
    "search-pwd" )
        echo "# Search in this directory (recursive) for a pattern #"
        if [ "$2" == '' ]; then
            echo -en "\nPattern to search: "
            read patternSearch
        else
            patternSearch=$2
        fi

        echo -e "\nSearching, please wait..."
        grep -rn $patternSearch .
        # -r, --recursive, -n, --line-number print line number with output lines, '.' is equal to $PWD or `pwd`
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

                networkConfigAvailable=`cat /etc/wpa_supplicant.conf | grep "ssid"`
                if [ "$networkConfigAvailable" == '' ]; then
                    echo -e "\n\tError: Not find configuration of anyone network (in /etc/wpa_supplicant.conf). Try: $0 create-wifi"
                else
                    echo "Choose one network to connect"
                    cat /etc/wpa_supplicant.conf | grep "ssid"
                    echo -n "Network name: "
                    read networkName

                    #sed -n '/Beginning of block/!b;:a;/End of block/!{$!{N;ba}};{/some_pattern/p}' fileName # sed in block text
                    wpaConf=`sed -n '/network/!b;:a;/}/!{$!{N;ba}};{/'$networkName'/p}' /etc/wpa_supplicant.conf`

                    if [ "$wpaConf" == '' ]; then
                        echo -e "\n\tError: Not find configuration to network '$networkName' (in /etc/wpa_supplicant.conf). Try: $0 create-wifi"
                    else
                        TMPFILE=`mktemp` # Create a TMP-file
                        cat /etc/wpa_supplicant.conf | grep -v -E "{|}|ssid|psk" > $TMPFILE

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
        echo -e "# Disconnect to one Wi-Fi network #\n"
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
        echo -e "# Show information about the AP connected #"
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
        echo "# Set brightness percentage value (accept % value, up and down) #"
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

        if [ "$pathFile" != '' ]; then
            brightnessMax=`cat $pathFile/max_brightness` # Get max_brightness
            brightnessPercentage=`echo "scale=3; $brightnessMax/100" | bc` # Get the percentage of 1% from max_brightness

            actualBrightness=`cat $pathFile/actual_brightness` # Get actual_brightness
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
        echo "# Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %) #"
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
    "date-up" )
        echo -e "# Update the date #\n"
        su - root -c '
        ntpVector=("ntp.usp.br" "ntp1.ptb.de" "bonehed.lcs.mit.edu") # Ntp servers
        ntpVectorSize=${#ntpVector[*]} # size of ntpVector

        tmpFileNtpError=`mktemp` # Create a TMP-file
        i=0 # Initialize variables
        flagContinue=true

        while $flagContinue && [ $i -lt $ntpVectorSize ]; do # Run until flagContinue is false or ntpVector get his end
            echo "Running: ntpdate -u -b ${ntpVector[$i]}" # Print what will be running
            ntpdate -u -b ${ntpVector[$i]} 2> $tmpFileNtpError # Run ntpdate with one value of ntpVector and send the errors to a tmp file

            if ! cat $tmpFileNtpError | grep -q "no server"; then # Test if ntpdate got error "no server suitable for synchronization found"
                if ! cat $tmpFileNtpError | grep -q "time out"; then # Test if ntpdate got error "time out"
                    if ! cat $tmpFileNtpError | grep -q "name server cannot be used"; then # Test if can name resolution works
                        echo -e "\nTime updated: `date`\n"
                        flagContinue=false # Set false in flagContinue, because time is updated
                    fi
                fi
            fi

            ((i++)) # Add 1 in the variable $i

            if [ $i -eq $ntpVectorSize ]; then # Test if $i is equal of size ntpVector
                if [ $flagContinue ]; then # if true, no ntp server worked
                    echo -e "\nSorry, time not updated: `date`\n"
                    if cat $tmpFileNtpError | grep -q "name server cannot be used"; then # Test if can name resolution works
                        echo -e "No connection found - Check your network connections\n"
                    fi
                fi
            fi
        done
        rm $tmpFileNtpError # Delete the tmp file
        '
        ;;
    "lpkg-c" )
        echo "# Count of packages that are installed in the Slackware #"
        countPackages=`ls -l /var/log/packages/ | cat -n | tail -n 1 | awk '{print $1}'`
        echo -e "\nThere are $countPackages packages installed"
        ;;
    "lpkg-i" | "lpkg-r" )
        if [ "$1" == "lpkg-i" ]; then
            functionWord="installed"
            workFolder="/var/log/packages/"
        elif [ "$1" == "lpkg-r" ]; then
            functionWord="removed"
            workFolder="/var/log/removed_packages/"
        fi
        echo -e "# List last packages $functionWord (accept 'n', where 'n' is a number of packages, the default is 10) #\n"

        if [ $# -eq 1 ]; then
            numberPackages=10
        else
            if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
                numberPackages="$2"
            else
                numberPackages=10
            fi
        fi

        ls -l --sort=time $workFolder | head -n $numberPackages | grep -v "total [[:digit:]]"
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
                echo -e "\nSwap is already clean"
            else
                if [ "$2" == '' ]; then
                    echo -en "\nTry clean the Swap? \n(y)es - (n)o: "
                    read cleanSwap
                else
                    cleanSwap='y'
                fi

                if [ "$cleanSwap" == 'y' ]; then
                    su - root -c 'echo -e "\nCleaning swap. Please wait..."
                    swapoff -a
                    swapon -a'
                fi
            fi
        fi
        ;;
    "slack-up" )
        echo "# Slackware update #"
        if [ "$2" == '' ]; then
            echo -en "\nUse blacklist?\nYes <Hit Enter> | No <type n>: "
            read useBL
        else
            useBL=$2
        fi
        echo "Use blacklist: $useBL"

        if [ "$useBL" == 'n' ]; then # slackpkg not using USEBL
            su - root -c "slackpkg update gpg
            slackpkg update -batch=on
            USEBL=0 slackpkg upgrade-all"
        else # slackpkg using USEBL
            su - root -c "slackpkg update gpg
            slackpkg update -batch=on
            USEBL=1 slackpkg upgrade-all"
        fi
        ;;
    "up-db" )
        echo -e "# Update the database for 'locate' #\n"
        su - root -c "updatedb" # Update de database
        echo -e "\nDatabase updated"
        ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        echo -e "# Show the weather forecast (you can change the city in the script) #\n"
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos # Download the information weather
        ;;
     "now" )
        echo -e "# now - Run \"texlive-up\" \"date-up\" \"swap-clean\" \"slack-up n\" and \"up-db\" sequentially"

        echo -e "\nRunning: $0 notPrint texlive-up\n"
        $0 notPrint texlive-up

        echo -e "\nRunning: $0 notPrint date-up\n"
        $0 notPrint date-up

        echo -e "\nRunning: $0 notPrint swap-clean y\n"
        $0 notPrint swap-clean y

        echo -e "\nRunning: $0 notPrint slack-up n\n"
        $0 notPrint slack-up n

        echo -e "\nRunning: $0 notPrint up-db\n"
        $0 notPrint up-db
        ;;
    * )
        echo -e "\n\t$(basename "$0"): Error of parameters"
        echo -e "\tTry $0 '--help'"
        ;;
esac

if [ "$optionTmp" != "notPrint" ]; then
    echo -e "\n#___ So Long, and Thanks for All the Fish ___#\n"
else
    shift
fi
