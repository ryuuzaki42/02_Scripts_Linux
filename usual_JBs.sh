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
# Last update: 23/11/2016

colorDisableInput=$1
if [ "$colorDisableInput" == "noColor" ]; then
    echo -e "\nColors disabled"
    shift
else # Some colors for script output - Make it easier to follow
    BLACK='\e[1;30m'
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\033[0m' # reset/no color
    BLUE='\e[1;34m'
    PINK='\e[1;35m'
    CYAN='\e[1;36m'
    WHITE='\e[1;37m'
fi

notPrintInput=$1
if [ "$notPrintInput" != "notPrint" ]; then
    echo -e "$BLUE\n\t\t#___ Script to usual commands ___#$NC\n"
else
    shift
fi

testColorInput=$1
if [ "$testColorInput" == "testColor" ]; then
    echo -e "\n\tTest colors: $RED RED $WHITE WHITE $PINK PINK $BLACK BLACK $BLUE BLUE $GREEN GREEN $CYAN CYAN $NC NC\n"
    shift
fi

# Options text
optionVector=("ap-info      " "   - Show information about the AP connected"
"brigh-1      " " * - Set brightness percentage value (accept % value, up and down)"
"brigh-2      " " = - Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %)"
"cn-wifi      " " * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
"cpu-max      " "   - Show the 10 process with more CPU use"
"create-wifi  " " * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
"date-up      " " * - Update the date"
"day-install  " "   - The day the system are installed"
"dc-wifi      " " * - Disconnect to one Wi-Fi network"
"folder-diff  " "   - Show the difference between two folder and (can) make them equal (with rsync)"
"git-gc       " "   - Run git gc (|--auto|--aggressive) in the sub directories"
"help         " "   - Show this help message (the same result with --help, -h and h)"
"ip           " "   - Get your IP"
"l-iw         " " * - List the Wi-Fi AP around, with iw (show WPS and more infos)"
"l-iwlist     " "   - List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)"
"lpkg-c       " "   - Count of packages that are installed in the Slackware"
"lpkg-i       " "   - List last packages installed (accept 'n', where 'n' is a number of packages, the default is 10)"
"lpkg-r       " "   - List last packages removed (accept 'n', where 'n' is a number of packages, the default is 10)"
"mem-max      " "   - Show the 10 process with more memory RAM use"
"mem-use      " "   - Get the all (shared and specific) use of memory RAM from one process/pattern"
"mem-info     " "   - Show memory and swap percentage of use"
"nm-list      " " + - List the Wi-Fi AP around with the nmcli from NetworkManager"
"now          " " * - Run \"texlive-up\" \"date-up\" \"swap-clean\" \"slack-up n\" and \"up-db\" sequentially "
"pdf-r        " "   - Reduce a PDF file"
"ping-test    " "   - Ping test on domain (default is google.com)" 
"print-lines  " "   - Print part of file (lineStart to lineEnd)"
"screenshot   " "   - Screenshot from display :0"
"search-pwd   " "   - Search in this directory (recursive) for a pattern"
"slack-up     " " * - Slackware update"
"swap-clean   " " * - Clean up the Swap Memory"
"texlive-up   " " * - Update the texlive packages"
"up-db        " " * - Update the database for 'locate'"
"weather      " "   - Show the weather forecast (you can change the city in the script)"
"work-fbi     " "   - Write <zero>/<random> value in one ISO file to wipe trace of old deleted file"
"search-pkg   " "   - Search in the installed package folder (/var/log/packages/) for one pattern"
"w or ''      " "   - Menu with whiptail (where you can call the options above)")

## Functions
ap-info () {
    echo -e "$CYAN# Show information about the AP connected #$NC"
    echo -e "\n/usr/sbin/iw dev wlan0 link:"
    /usr/sbin/iw dev wlan0 link
    echo -e "\n/sbin/iwconfig wlan0:"
    /sbin/iwconfig wlan0
}

dateUpFunction() { # Need to be run as root
    ntpVector=("ntp.usp.br" "ntp1.ptb.de" "bonehed.lcs.mit.edu") # Ntp servers
    #ntpVectorSize=${#ntpVector[*]} # size of ntpVector
    #${ntpVector[$i]} # where $i is the index
    # ${ntpVector[@]} # all value of the vector

    tmpFileNtpError=`mktemp` # Create a TMP-file
    timeUpdated=false

    for ntpValue in ${ntpVector[@]}; do # Run until flagContinue is false and run the break or ntpVector get his end
        echo -e "Running: ntpdate -u -b $ntpValue\n"
        ntpdate -u -b $ntpValue 2> $tmpFileNtpError # Run ntpdate with one value of ntpVector and send the errors to a tmp file

        if ! cat $tmpFileNtpError | grep -q -v "no server"; then # Test if ntpdate got error "no server suitable for synchronization found"
            if ! cat $tmpFileNtpError | grep -q -v "time out"; then # Test if ntpdate got error "time out"
                if ! cat $tmpFileNtpError | grep -q -v "name server cannot be used"; then # Test if can name resolution works
                    echo -e "\nTime updated: `date`\n"
                    timeUpdated=true # Set true in the timeUpdated
                    break
                fi
            fi
        fi
    done

    if [ "$timeUpdated" == "false" ]; then
        echo -e "\nSorry, time not updated: `date`\n"
        if cat $tmpFileNtpError | grep -q "name server cannot be used"; then # Test if can name resolution works
            echo -e "No connection found - Check your network connections\n"
        fi
    fi

    rm $tmpFileNtpError # Delete the tmp file
}

date-up () {
    echo -e "$CYAN# Update the date #$NC\n"
    export -f dateUpFunction
    su root -c 'dateUpFunction' # In this case with out the hypen to no change the environment variables

    # It's advisable that users acquire the habit of always following the su command with a space and then a hyphen
    # The hyphen: (1) switches the current directory to the home directory of the new user (e.g., to /root in the case of the root user) and
    # (2) it changes the environmental variables to those of the new user
    # If the first argument to su is a hyphen, the current directory and environment will be changed to what would be expected if the new user had actually
    # logged on to a new session (rather than just taking over an existing session)
}

help() {
    echo -e "$CYAN# Show this help message (the same result with --help, -h and h) #$NC\n"
    echo -e "$CYAN    Options:\n
   $RED Obs$CYAN:$RED * root required,$PINK + NetworkManager required,$BLUE = X server required$CYAN\n"

    countOption=0
    optionVectorSize=${#optionVector[*]}
    while [ $countOption -lt $optionVectorSize ]; do
        if echo -e "${optionVector[$countOption+1]}" | grep -q "*"; then
            useColor=$RED
        elif echo -e "${optionVector[$countOption+1]}" | grep -q "="; then
            useColor=$BLUE
        elif echo -e "${optionVector[$countOption+1]}" | grep -q "+"; then
            useColor=$PINK
        else
            useColor=''
        fi

        echo -e "    $GREEN${optionVector[$countOption]}$CYAN $useColor${optionVector[$countOption+1]}$NC"

        countOption=$((countOption + 2))
    done
}

whiptailMenu() {
    echo -e "$CYAN# Menu with whiptail (where you can call others options) #$NC\n"
    eval `resize`
    itemSelected=$(whiptail --title "#___ Script to usual commands ___#" --menu "Obs: * root required, + NetworkManager required, = X server required

    Options:" $(( $LINES -5 )) $(( $COLUMNS -5 )) $(( $LINES -15 )) \
    "${optionVector[0]}" "${optionVector[1]}" \
    "${optionVector[2]}" "${optionVector[3]}" \
    "${optionVector[4]}" "${optionVector[5]}" \
    "${optionVector[6]}" "${optionVector[7]}" \
    "${optionVector[8]}" "${optionVector[9]}" \
    "${optionVector[10]}" "${optionVector[11]}" \
    "${optionVector[12]}" "${optionVector[13]}" \
    "${optionVector[14]}" "${optionVector[15]}" \
    "${optionVector[16]}" "${optionVector[17]}" \
    "${optionVector[18]}" "${optionVector[19]}" \
    "${optionVector[20]}" "${optionVector[21]}" \
    "${optionVector[22]}" "${optionVector[23]}" \
    "${optionVector[24]}" "${optionVector[25]}" \
    "${optionVector[26]}" "${optionVector[27]}" \
    "${optionVector[28]}" "${optionVector[29]}" \
    "${optionVector[30]}" "${optionVector[31]}" \
    "${optionVector[32]}" "${optionVector[33]}" \
    "${optionVector[34]}" "${optionVector[35]}" \
    "${optionVector[36]}" "${optionVector[37]}" \
    "${optionVector[38]}" "${optionVector[39]}" \
    "${optionVector[40]}" "${optionVector[41]}" \
    "${optionVector[42]}" "${optionVector[43]}" \
    "${optionVector[44]}" "${optionVector[45]}" \
    "${optionVector[46]}" "${optionVector[47]}" \
    "${optionVector[48]}" "${optionVector[49]}" \
    "${optionVector[50]}" "${optionVector[51]}" \
    "${optionVector[52]}" "${optionVector[53]}" \
    "${optionVector[54]}" "${optionVector[55]}" \
    "${optionVector[56]}" "${optionVector[57]}" \
    "${optionVector[58]}" "${optionVector[59]}" \
    "${optionVector[60]}" "${optionVector[61]}" \
    "${optionVector[62]}" "${optionVector[63]}" \
    "${optionVector[64]}" "${optionVector[65]}" \
    "${optionVector[66]}" "${optionVector[67]}" \
    "${optionVector[68]}" "${optionVector[69]}" \
    "${optionVector[70]}" "${optionVector[71]}" 3>&1 1>&2 2>&3)

    if [ "$itemSelected" != '' ]; then
        echo -e "$GREEN\nRunning: $0 notPrint $itemSelected $1 $2$CYAN\n"
        $0 notPrint $itemSelected $1 $2
    fi
}

optionInput=$1
case $optionInput in
    "ap-info" )
        ap-info ;;
    "date-up" )
        date-up ;;
    "--help" | "-h" | "help" | 'h' )
        help ;;
    '' | 'w' )
        whiptailMenu $2 $3 ;;
    "git-gc" )
        echo -e "$CYAN# Run git gc (|--auto|--aggressive) in the sub directories #$NC\n"
        ## All folder in one directory run "git gc --aggressive"
        echo "Commands \"git gc\" avaible:"
        echo "1 - \"git gc\""              # Cleanup unnecessary files and optimize the local repository
        echo "2 - \"git gc --auto\""       # Checks whether any housekeeping is required; if not, it exits without performing any work
        echo "3 - \"git gc --aggressive\"" # More aggressively, optimize the repository at the expense of taking much more time
        echo -n "Which option you want? (hit enter to insert 1): "
        read gitOptionComand

        if [ "$gitOptionComand" == '2' ]; then
            gitCommandRun="git gc --auto"
        elif [ "$gitOptionComand" == '3' ]; then
            gitCommandRun="git gc --aggressive"
        else
            gitCommandRun="git gc"
        fi

        for folderGit in `ls`; do
            echo -e "\nRunning \"$gitCommandRun\" inside: \"$folderGit/\"\n"
            cd $folderGit
            $gitCommandRun
            cd ..
        done
        ;;
     "mem-use" )
        echo -e "$CYAN# Get the all (shared and specific) use of memory RAM from one process/pattern #$NC\n"
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
            echo -e "$RED\nError: You need insert some pattern/process name to search, e.g., $0 mem-use opera$NC"
        fi
        ;;
     "search-pkg" )
        echo -e "$CYAN# Search in the installed package folder (/var/log/packages/) for one pattern #$NC\n"
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
        echo -e "$CYAN# Write <zero>/<random> value in one ISO file to wipe trace of old deleted file #$NC"
        echo -e "\nWarning: Depending on how big is the amount of free space, this can take a long time"

        freeSpace=`df . | awk '/[0-9]%/{print $(NF-2)}'` # Free space local/pwd folder
        freeSpaceMiB=`echo "scale=2; $freeSpace/1024" | bc` # Free space in MiB
        freeSpaceGiB=`echo "scale=2; $freeSpace/(1024*1024)" | bc` # Free space in GiB
        timeAvgMin=`echo "($freeSpaceMiB/30)/60" | bc`

        echo -e "\nThere are$GREEN $freeSpaceGiB$CYAN GiB$NC ($GREEN$freeSpaceMiB$CYAN MiB$NC) free in this folder/disk/partition (that will be write)"
        echo -e "Considering$CYAN 30 MiB/s$NC in speed of write, will take$GREEN $timeAvgMin min$NC to finish this job"
        echo -en "\nWant continue? (y)es - (n)o: "
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

            startAtSeconds=`date +%s`

            if [ "$continueRandomOrZero" == 'r' ]; then
                typeWriteDd="random"
            else
                typeWriteDd="zero"
            fi
            echo -en "\nWriting <$typeWriteDd> value in the \"$fileName\" tmp file. Please wait...\n\n"

            if [ "$continueRandomOrZero" == 'r' ]; then
                dd if=/dev/urandom of=$fileName iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <random> value to wipe the data
            else
                dd if=/dev/zero of=$fileName iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <zero> value to wipe the data
            fi

            endsAtSeconds=`date +%s`
            timeTakeMin=`echo "scale=2; ($endsAtSeconds - $startAtSeconds)/60" | bc`

            echo -e "\nFinished to write the file - this take $timeTakeMin min"

            rm $fileName # Delete the <big> file generated
            echo -e "\nThe \"$fileName\" tmp file was deleted and the end of the job"
        fi
        ;;
    "ip" )
        echo -e "$CYAN# Get your IP #$NC\n"
        localIP=`/sbin/ifconfig | grep broadcast | awk '{print $2}'`
        echo "Local IP: $localIP"

        externalIP=`wget -qO - icanhazip.com`
        echo "External IP: $externalIP"
        ;;
    "cpu-max" )
        echo -e "$CYAN# Show the 10 process with more CPU use #$NC\n"
        ps axo pid,%cpu,%mem,cmd --sort=-pcpu | head -n 11
        ;;
    "mem-max" )
        echo -e "$CYAN# Show the 10 process with more memory RAM use #$NC\n"
        ps axo pid,%cpu,%mem,cmd --sort -rss | head -n 11
        ;;
    "day-install" )
        echo -e "$CYAN# The day the system are installed #$NC"
        dayInstall=`ls -alct / | tail -n 1 | awk '{print $6, $7, $8}'`
        echo -e "\nThe system was installed at the time: $dayInstall"
        ;;
    "print-lines" )
        echo -e "$CYAN# Print part of file (lineStart to lineEnd) #$NC"
        inputFile=$2 # File to read

        if [ "$inputFile" == '' ]; then
            echo -e "$RED\nError: You need to pass the file name, e.g., $0 print-lines file.txt$NC"
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
                    echo -e "$RED\nError: lineStart must be smaller than lineEnd$NC"
                else
                    echo -e "\nPrint \"$inputFile\" line $lineStart to $lineEnd\n"
                    lineStartTmp=$((lineEnd-lineStart))
                    ((lineStartTmp++))

                    cat -n $inputFile | head -n $lineEnd | tail -n $lineStartTmp
                fi
            else
                echo -e "$RED\nError: lineStart and lineEnd must be number$NC"
            fi
        fi
        ;;
    "screenshot" )
        echo -e "$CYAN# Screenshot from display :0 #$NC\n"
        dateNow=`date`
        import -window root -display :0 screenshot_"$dateNow".jpg
        echo "Screenshot \"screenshot_"$dateNow".jpg\" saved"
        ;;
    "folder-diff" )
        echo -e "$CYAN# Show the difference between two folder and (can) make them equal (with rsync) #$NC"
        if [ $# -lt 3 ]; then
            echo -e "$RED\nError: Need two parameters, $0 folder-dif 'pathSource' 'pathDestination'$NC"
        else
            echo -e "\n$GREEN\t## An Important Note ##$BLUE\n"
            echo -e "The trailing slash (/) at the end of the first argument (source folder)"
            echo -e "For example: \"rsync -a dir1/ dir2\" is necessary to mean \"the contents of dir1\""
            echo -e "The alternative (without the trailing slash) would place dir1 (including the directory) within dir2"
            echo -e "This would create a hierarchy that looks like: dir2/dir1/[files]"
            echo -e "\n$CYAN## Please double-check your arguments before continue ##$NC"

            pathSource=$2
            pathDestination=$3
            echo -e "$CYAN\nSource folder:$GREEN $pathSource$CYAN"
            echo -e "Destination folder:$GREEN $pathDestination$NC"

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
                            echo -e "\nFiles to be deleted:"
                            echo "$filesDelete" | sort
                        fi

                        filesDifferent=`echo -e "$folderChanges" | grep "fcstp" | awk '{print substr($0, index($0,$2))}'`
                        if [ "$filesDifferent" != '' ]; then
                            echo -e "\nFiles different:"
                            echo "$filesDifferent" | sort
                        fi

                        filesNew=`echo -e "$folderChanges" | grep "f+++"| awk '{print substr($0, index($0,$2))}'`
                        if [ "$filesNew" != '' ]; then
                            echo -e "\nNew files:"
                            echo "$filesNew" | sort
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
                                echo -e "\nChanges are writing in "$pathDestination". Please wait..."
                                rsync -crvh --delete "$pathSource" "$pathDestination"
                            else
                                echo -e "\n\tNone change writes in disk"
                            fi
                        fi
                    else
                        echo -e "$RED\nError: The destination ($pathDestination) don't exist$NC"
                    fi
                else
                    echo -e "$RED\nError: The source ($pathSource) don't exist$NC"
                fi
            else
                echo -e "\n\tNone change writes in disk"
            fi
        fi
        ;;
    "search-pwd" )
        echo -e "$CYAN# Search in this directory (recursive) for a pattern #$NC"
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
        echo -e "$CYAN# Ping test on domain (default is google.com) #$NC\n"
        if [ $# -eq 1 ]; then
            domainPing="google.com"
        else
            domainPing=$2
        fi

        echo -e "\nRunning: ping -c 3 $domainPing\n"
        ping -c 3 $domainPing
        ;;
    "create-wifi" )
        echo -e "$CYAN# Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\n"
        su - root -c 'echo -n "Name of the network (SSID): "
        read netSSID

        echo -n "Password of this network: "
        read -s netPassword

        wpa_passphrase "$netSSID" "$netPassword" | grep -v "#psk" >> /etc/wpa_supplicant.conf'
        ;;
    "cn-wifi" )
        echo -e "$CYAN# Connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\n"
        if ps faux | grep "NetworkManager" | grep -v -q "grep"; then # Test if NetworkManager is running
            echo -e "$RED\nError: NetworkManager is running, please kill him with: killall NetworkManager$NC"
        else
            if [ "$LOGNAME" != "root" ]; then
                echo -e "$RED\nError: Execute as root user$NC"
            else
                killall wpa_supplicant # kill the previous wpa_supplicant "configuration"

                networkConfigAvailable=`cat /etc/wpa_supplicant.conf | grep "ssid"`
                if [ "$networkConfigAvailable" == '' ]; then
                    echo -e "$RED\nError: Not find configuration of anyone network (in /etc/wpa_supplicant.conf).\n Try: $0 create-wifi$NC"
                else
                    echo "Choose one network to connect"
                    cat /etc/wpa_supplicant.conf | grep "ssid$NC"
                    echo -n "Network name: "
                    read networkName

                    #sed -n '/Beginning of block/!b;:a;/End of block/!{$!{N;ba}};{/some_pattern/p}' fileName # sed in block text
                    wpaConf=`sed -n '/network/!b;:a;/}/!{$!{N;ba}};{/'$networkName'/p}' /etc/wpa_supplicant.conf`

                    if [ "$wpaConf" == '' ]; then
                        echo -e "$RED\nError: Not find configuration to network '$networkName' (in /etc/wpa_supplicant.conf).\n Try: $0 create-wifi$NC"
                    else
                        TMPFILE=`mktemp` # Create a TMP-file
                        cat /etc/wpa_supplicant.conf | grep -v -E "{|}|ssid|psk" > $TMPFILE

                        echo -e "$wpaConf" >> $TMPFILE # Save the configuration of the network on this file

                        echo -e "\n########### Network configuration ####################"
                        cat $TMPFILE
                        echo -e "$CYAN######################################################"

                        #wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -d -B wext # Normal command
                        wpa_supplicant -i wlan0 -c $TMPFILE -d -B wext # Connect with the network using the TMP-file

                        rm $TMPFILE # Delete the TMP-file

                        dhclient wlan0 # Get IP

                        iw dev wlan0 link # Show connection status
                    fi
                fi
            fi
        fi
        ;;
    "dc-wifi" )
        echo -e "$CYAN# Disconnect to one Wi-Fi network #$NC\n"
        su - root -c 'dhclient -r wlan0
        ifconfig wlan0 down
        iw dev wlan0 link'
        ;;
    "mem-info" )
        echo -e "$CYAN# Show memory and swap percentage of use #$NC"
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
    "l-iw" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iw (show WPS and more infos) #$NC\n"
        su - root -c '/usr/sbin/iw dev wlan0 scan | grep -E "wlan|SSID|signal|WPA|WEP|WPS|Authentication|WPA2"'
        ;;
    "l-iwlist" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos) #$NC\n"
        /sbin/iwlist wlan0 scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"
        ;;
    "texlive-up" )
        echo -e "$CYAN# Update the texlive packages #$NC\n"
        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "nm-list" )
        echo -e "$CYAN# List the Wi-Fi AP around with the nmcli from NetworkManager #$NC\n"
        nmcli device wifi list
        ;;
    "brigh-1" )
        echo -e "$CYAN# Set brightness percentage value (accept % value, up and down) #$NC"
        if [ $# -eq 1 ]; then
            brightnessValueOriginal=1
        else
            brightnessValueOriginal=$2
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
            echo -e "$RED\nError: File to set brightness not found$NC"
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
        echo -e "$CYAN# Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %) #$NC"
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
                    echo -e "$RED\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            fi
        else #elif [ $# -eq 3 ]; then # Option to two value of input to set
            if echo $3 | grep -q [[:digit:]]; then # Test if has only digit
                if [ "$2" == "up" ];then
                    xbacklight -inc $3
                elif [ "$2" == "down" ];then
                    xbacklight -dec $3
                else
                    echo -e "$RED\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            else
                echo -e "$RED\nError: Value must be only digit (e.g. $0 brigh-2 up 10 to set brightness up in 10 %)$NC"
            fi
        fi
        ;;
    "lpkg-c" )
        echo -e "$CYAN# Count of packages that are installed in the Slackware #$NC"
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
        echo -e "$CYAN# List last packages $functionWord (accept 'n', where 'n' is a number of packages, the default is 10) #$NC\n"

        if [ $# -eq 1 ]; then
            numberPackages=10
        else
            if echo $2 | grep -q [[:digit:]]; then # Test if has only digit
                numberPackages=$2
            else
                numberPackages=10
            fi
        fi

        ls -l --sort=time $workFolder | head -n $numberPackages | grep -v "total [[:digit:]]"
        ;;
    "pdf-r" ) # Need Ghostscript
        echo -e "$CYAN# Reduce a PDF file #$NC"
        if [ $# -eq 1 ]; then
            echo -e "$RED\nError: Use $0 pdf-r file.pdf$NC"
        else # Convert the file
            filePdfInput=$2
            if [ -e "$filePdfInput" ]; then
                filePdfOutput=${filePdfInput::-4}

                fileChangeOption=$3
                if ! echo "$fileChangeOption" | grep -q [[:digit:]]; then
                    echo -en "\nFile change options:\n1 - Small size\n2 - Better quality\n3 - Minimal changes\n4 - All 3 above\nWhat option you want? (hit enter to insert 3): "
                    read fileChangeOption
                fi

                if [ "$fileChangeOption" == '1' ]; then
                    sizeQuality="ebook"
                elif [ "$fileChangeOption" == '2' ]; then
                    sizeQuality="screen"
                elif [ "$fileChangeOption" == '4' ]; then
                    # $1 = pdf-r, $2 = fileName.pdf, $3 = fileChangeOption
                    echo
                    $0 notPrint $1 "$filePdfInput" 1
                    echo
                    $0 notPrint $1 "$filePdfInput" 2
                    echo
                    $0 notPrint $1 "$filePdfInput" 3
                else
                    fileChangeOption='3'
                fi

                if [ "$fileChangeOption" != '4' ]; then
                    fileNamePart="_rOp"$fileChangeOption".pdf"

                    if [ "$fileChangeOption" == '3' ]; then
                        midCode=''
                    else
                        midCode="-dCompatibilityLevel=1.4 -dPDFSETTINGS=/$sizeQuality"
                    fi

                    echo -e "\nRunning \"$0 $1 $filePdfInput $fileChangeOption\"\n"
                    gs -sDEVICE=pdfwrite $midCode -dNOPAUSE -dBATCH -sOutputFile="$filePdfOutput""$fileNamePart" "$filePdfInput"

                    echo -e "\nThe output PDF: \""$filePdfOutput""$fileNamePart"\" was saved"
                fi
            else
                echo -e "$RED\nError: The file \"$filePdfInput\" not exists$NC"
            fi
        fi
        ;;
    "swap-clean" )
        echo -e "$CYAN# Clean up the Swap Memory #$NC"
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
        echo -e "$CYAN# Slackware update #$NC"
        if [ "$2" == '' ]; then
            echo -en "\nUse blacklist?\n(y)es - (n)o (hit enter to no): "
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
        echo -e "$CYAN# Update the database for 'locate' #$NC\n"
        su - root -c "updatedb" # Update de database
        echo -e "\nDatabase updated"
        ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        echo -e "$CYAN# Show the weather forecast (you can change the city in the script) #$NC\n"
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos # Download the information weather
        ;;
     "now" )
        echo -e "$CYAN# now - Run \"texlive-up\" \"date-up\" \"swap-clean\" \"slack-up n\" and \"up-db\" sequentially #$NC"

        echo -e "$GREEN\nRunning: $0 notPrint texlive-up$NC\n"
        $0 notPrint texlive-up

        echo -e "$GREEN\nRunning: $0 notPrint date-u$NCp\n"
        $0 notPrint date-up

        echo -e "$GREEN\nRunning: $0 notPrint swap-clean y$NC\n"
        $0 notPrint swap-clean y

        echo -e "$GREEN\nRunning: $0 notPrint slack-up n$NC\n"
        $0 notPrint slack-up n

        echo -e "$GREEN\nRunning: $0 notPrint up-db$NC\n"
        $0 notPrint up-db
        ;;
    * )
        echo -e "\n\t$(basename "$0"): Error of parameters"
        echo -e "\tTry $0 '--help'"
        ;;
esac

if [ "$notPrintInput" != "notPrint" ]; then
    echo -e "$BLUE\n\t\t#___ So Long, and Thanks for All the Fish ___#$NC\n"
else
    shift
fi
