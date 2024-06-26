#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Last update: 21/03/2018
#
useColor() {
    BLACK='\e[1;30m'
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\033[0m' # reset/no color
    BLUE='\e[1;34m'
    PINK='\e[1;35m'
    CYAN='\e[1;36m'
    WHITE='\e[1;37m'
}

notUseColor() {
    unset BLACK RED GREEN NC BLUE PINK CYAN WHITE
}

colorPrint=$1
if [ "$colorPrint" == "noColor" ]; then
    echo -e "\\nColors disabled"
    shift
else # Some colors for script output - Make it easier to follow
    useColor
    colorPrint=''
fi

notPrintHeaderHeader=$1
if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE        #___ Script to usual commands ___#$NC\\n"
else
    shift
fi

testColorInput=$1
if [ "$testColorInput" == "testColor" ]; then
    echo -e "\\n    Test colors: $RED RED $WHITE WHITE $PINK PINK $BLACK BLACK $BLUE BLUE $GREEN GREEN $CYAN CYAN $NC NC\\n"
    shift
fi

loadDevWirelessInterface() {
    devInterface=$1

    if [ "$devInterface" == '' ]; then
        devInterface="wlan0"
    fi

    echo -e "\\nWorking with the dev interface: $devInterface"
    echo -e "You can pass other interface as a parameter\\n"
}

optionInput=$1
case $optionInput in
    "ap-info" )
        echo -e "$CYAN# Show information about the AP connected #$NC"

        loadDevWirelessInterface "$2"

        echo -e "\\n/usr/sbin/iw dev $devInterface link:"
        /usr/sbin/iw dev $devInterface link

        echo -e "\\n/sbin/iwconfig $devInterface:"
        /sbin/iwconfig $devInterface
        ;;
    "date-up" )
        echo -e "$CYAN# Update the date #$NC\\n"

        dateUpFunction() { # Need to be run as root
            ntpVector=("ntp1.ptb.de" "ntp.usp.br" "bonehed.lcs.mit.edu") # Ntp servers
            #${#ntpVector[*]} # size of ntpVector
            #${ntpVector[$i]} # value of the $i index in ntpVector
            #${ntpVector[@]} # all value of the vector

            tmpFileNtpError=$(mktemp) # Create a tmp file
            timeUpdated="false"

            for ntpValue in "${ntpVector[@]}"; do # Run until flagContinue is false and run the break or ntpVector get his end
                echo -e "Running: ntpdate -u -b $ntpValue\\n"
                ntpdate -u -b "$ntpValue" 2> "$tmpFileNtpError" # Run ntpdate with one value of ntpVector and send the errors to a tmp file

                if ! grep -q -v "no server" < "$tmpFileNtpError"; then # Test if ntpdate got error "no server suitable for synchronization found"
                    if ! grep -q -v "time out" < "$tmpFileNtpError"; then # Test if ntpdate got error "time out"
                        if ! grep -q -v "name server cannot be used" < "$tmpFileNtpError"; then # Test if can name resolution works
                            echo -e "\\nTime updated: $(date)\\n"
                            timeUpdated=true # Set true in the timeUpdated
                            break
                        fi
                    fi
                fi
            done

            if [ "$timeUpdated" == "false" ]; then
                echo -e "\\nSorry, time not updated: $(date)\\n"
                if grep -q "name server cannot be used" < "$tmpFileNtpError"; then # Test if can name resolution works
                    echo -e "No connection found - Check your network connections\\n"
                fi
            fi

            rm "$tmpFileNtpError" # Delete the tmp file
        }

        export -f dateUpFunction
        if [ "$(whoami)" != "root" ]; then
            echo -e "$CYAN\\nInsert the root Password to continue$NC"
        fi

        su root -c 'dateUpFunction' # In this case without the hyphen (su - root -c 'command') to no change the environment variables

        # It's advisable that users acquire the habit of always following the su command with a space and then a hyphen
        # The hyphen: (1) switches the current directory to the home directory of the new user (e.g., to /root in the case of the root user) and
        # (2) it changes the environmental variables to those of the new user
        # If the first argument to su is a hyphen, the current directory and environment will be changed to what would be expected if the new user had actually
        # logged on to a new session (rather than just taking over an existing session)
        ;;
    "--help" | "-h" | "help" | 'h' | '' | 'w' )
        if [ "$optionInput" == '' ] || [ "$optionInput" == 'w' ]; then # whiptailMenu()
            notUseColor
        fi

        # Options text
        optionVector=("ap-info      " "   - Show information about the AP connected"
        "brigh-1      " "$RED * - Set brightness percentage value (accept % value, up and down)"
        "brigh-2      " "$BLUE = - Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %)"
        "cn-wifi      " "$RED * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
        "cpu-max      " "   - Show the 10 process with more CPU use"
        "create-wifi  " "$RED * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
        "date-up      " "$RED * - Update the date"
        "day-install  " "   - The day the system are installed"
        "dc-wifi      " "$RED * - Disconnect to one Wi-Fi network"
        "file-equal   " "   - Look for equal files using md5sum"
        "folder-diff  " "   - Show the difference between two folder and (can) make them equal (with rsync)"
        "git-gc       " "   - Run git gc (|--auto|--aggressive) in the sub directories"
        "help         " "   - Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h')"
        "ip           " "   - Get your IP"
        "l-iw         " "$RED * - List the Wi-Fi AP around, with iw (show WPS and more infos)"
        "l-iwlist     " "   - List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)"
        "l-pkg-i      " "   - List the last package(s) installed (accept 'n', where 'n' is a number of packages, the default is 10)"
        "l-pkg-r      " "   - List the last package(s) removed (accept 'n', where 'n' is a number of packages, the default is 10)"
        "l-pkg-u      " "   - List the last package(s) upgrade (accept 'n', where 'n' is a number of packages, the default is 10)"
        "mem-max      " "   - Show the 10 process with more memory RAM use"
        "mem-use      " "   - Get the all (shared and specific) use of memory RAM from one process/pattern"
        "mem-info     " "   - Show memory and swap percentage of use"
        "nm-list      " "$PINK + - List the Wi-Fi AP around with the nmcli from NetworkManager"
        "mtr-test     " "$RED -  Run a mtr-test on a domain (default is google.com)"
        "now          " "$RED * - Run \"date-up\" \"swap-clean\" \"slack-up y y\" and \"up-db\" sequentially "
        "pdf-r        " "   - Reduce a PDF file"
        "ping-test    " "   - Run a ping-test on a domain (default is google.com)"
        "pkg-count    " "   - Count of packages that are installed your Slackware"
        "print-lines  " "   - Print part of file (lineStart to lineEnd)"
        "screenshot   " "   - Screenshot from display :0"
        "search-pwd   " "   - Search in this directory (recursive) for a pattern"
        "slack-up     " "$RED * - Slackware update"
        "sub-extract  " "   - Extract subtitle from a video file"
        "swap-clean   " "$RED * - Clean up the Swap Memory"
        "texlive-up   " "$RED * - Update the texlive packages"
        "up-db        " "$RED * - Update the database for the 'locate'"
        "weather      " "   - Show the weather forecast (you can pass the name of the city as parameter)"
        "work-fbi     " "   - Write <zero>/<random> value in one ISO file to wipe trace of old deleted file"
        "search-pkg   " "   - Search in the installed package folder (/var/log/packages/) for one pattern"
        "w            " "   - Menu with whiptail, where you can call the options above (the same result with 'w' or '')")

        if [ "$colorPrint" == '' ]; then # set useColor on again if the use not pass "noColor"
            useColor
        fi

        case $optionInput in
            "--help" | "-h" | "help" | 'h' )
                help() {
                    echo -e "$CYAN# Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h') $NC"
                    echo -e "$CYAN\\nOptions:\\n$RED    Obs$CYAN:$RED * root required,$PINK + NetworkManager required,$BLUE = X server required$CYAN\\n"

                    countOption='0'
                    optionVectorSize=${#optionVector[*]}
                    while [ "$countOption" -lt "$optionVectorSize" ]; do
                        echo -e "    $GREEN${optionVector[$countOption]}$CYAN ${optionVector[$countOption+1]}$NC"

                        countOption=$((countOption + 2))
                    done
                }

                help
                ;;
            '' | 'w' )
                whiptailMenu() {
                    echo -e "$CYAN# Menu with whiptail, where you can call the options above (the same result with 'w' or '') #$NC\\n"
                    eval "$(resize)"

                    heightWhiptail=$((LINES - 5))
                    widthWhiptail=$((COLUMNS - 5))

                    if [ "$LINES" -lt "16" ]; then
                        echo -e "$RED\\nTerminal with very small size. Use one terminal with at least 16 columns (actual size line: $LINES columns: $COLUMNS)$NC"
                        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader --help$CYAN\\n" | sed 's/  / /g'
                        $0 $colorPrint notPrintHeader --help
                    else
                        heightMenuBoxWhiptail=$((LINES - 15))

                        #whiptail --title "<título da caixa de menu>" --menu "<texto a ser exibido>" <altura> <largura> <altura da caixa de menu> \
                        #[ <tag> <item> ] [ <tag> <item> ] [ <tag> <item> ]

                        itemSelected=$(whiptail --title "#___ Script to usual commands ___#" --menu "Obs: * root required, + NetworkManager required, = X server required

                        Options:" $heightWhiptail $widthWhiptail $heightMenuBoxWhiptail \
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
                        "${optionVector[70]}" "${optionVector[71]}" \
                        "${optionVector[72]}" "${optionVector[73]}" \
                        "${optionVector[74]}" "${optionVector[75]}" \
                        "${optionVector[76]}" "${optionVector[77]}" \
                        "${optionVector[78]}" "${optionVector[79]}" 3>&1 1>&2 2>&3)

                        if [ "$itemSelected" != '' ]; then
                            itemSelected=${itemSelected// /} # Remove space in the end of selected item
                            echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader $itemSelected ${*} $CYAN\\n" | sed 's/  / /g'
                            $0 $colorPrint notPrintHeader "$itemSelected" "${*}"
                        fi
                    fi
                }

                whiptailMenu "${*:2}"
                ;;
        esac
        ;;
    "git-gc" )
        echo -e "$CYAN# Run git gc (|--auto|--aggressive) in the sub directories #$NC\\n"
        ## All folder in one directory run "git gc --aggressive"
        echo "Commands \"git gc\" available:"
        echo "1 - \"git gc\""              # Cleanup unnecessary files and optimize the local repository
        echo "2 - \"git gc --auto\""       # Checks whether any housekeeping is required; if not, it exits without performing any work
        echo "3 - \"git gc --aggressive\"" # More aggressively, optimize the repository at the expense of taking much more time
        echo -n "Which option you want? (hit enter to insert 1): "
        read -r gitOptionCommand

        if [ "$gitOptionCommand" == '2' ]; then
            gitCommandRun="git gc --auto"
        elif [ "$gitOptionCommand" == '3' ]; then
            gitCommandRun="git gc --aggressive"
        else
            gitCommandRun="git gc"
        fi

        folderLocal=$(ls -vd -- */) # List folder names
        folderLocalcount=$(echo "$folderLocal" | wc -l)

        folderRun='0'
        while [ "$folderRun" -lt "$folderLocalcount" ]; do
            folderRun=$((folderRun + 1))
            folderGit=$(echo -e "$folderLocal" | head -n "$folderRun" | tail -n 1)

            echo -e "\\nRunning \"$gitCommandRun\" inside: \"$folderGit/\"\\n"
            cd "$folderGit" || exit
            $gitCommandRun
            cd .. || exit
        done
        ;;
    "file-equal" )
        echo -e "$CYAN# Look for equal files using md5sum #$NC\\n"
        echo "Want check the files recursively (this folder and all his sub directories) or only this folder?"
        echo -n "1 to recursively - 2 to only this folder (hit enter to all folders): "
        read -r allFolderOrNot

        if [ "$allFolderOrNot" == '2' ]; then
            recursiveFolderValue="-maxdepth 1" # Set the max deep to 1, or just just folder
        else
            recursiveFolderValue=''
        fi

        echo -en "\\nRunning md5sum, can take a while. Please wait..."
        fileAndMd5=$(find . $recursiveFolderValue -type f -print0 | xargs -0 md5sum) # Get md5sum of the files
        fileAndMd5=$(echo "$fileAndMd5" | sort) # Sort by the md5sum

        md5Files=$(echo "$fileAndMd5" | cut -d " " -f1) # Get only de md5sum

        for value in $md5Files; do
            if [ "$valueBack" == "$value" ]; then # Look for all values equal
                equalFiles="$equalFiles$value|"
            fi
            valueBack=$value
        done

        equalFiles=${equalFiles::-1} # Remove the last | (the last character)

        if [ "$equalFiles" == '' ]; then
            echo -e "\\n\\nAll files are different by md5sum"
        else
            echo -e "\\n\\n### These file(s) are equal:"
            filesEqual=$(echo "$fileAndMd5" | grep -E "$equalFiles") # Grep all files equal

            IFS=$(echo -en "\\n\\b") # Change the Internal Field Separator (IFS) to "\\n\\b"

            for value in $filesEqual; do
                valueNow=$(echo "$value" | cut -d " " -f1)

                if [ "$valueNow" != "$valueBack" ]; then
                    echo # Add a new line between file different in the print on the terminal
                fi
                valueBack=$valueNow

                echo "$value"
            done

            echo -e "\\nWant to print the file(s) that are different?"
            echo -n "(y)es - (n)o (hit enter to yes): "
            read -r printDifferent

            if [ "$printDifferent" != 'n' ]; then
                echo -e "\\n### These file(s) are different:\\n"
                filesDifferent=$(echo "$fileAndMd5" | grep -vE "$equalFiles") # Grep all files different
                echo "$filesDifferent" | sort -k 2
            fi
        fi
    ;;
    "sub-extract" ) # Need ffmpeg
        echo -e "$CYAN# Extract subtitle from a video file #$NC\\n"
        fileName=$2
        if [ "$fileName" != '' ]; then
            subtitleInfoGeneral=$(ffmpeg -i "$fileName" 2>&1 | grep "Stream.*Subtitle")
            subtitleNumber=$(echo -e "$subtitleInfoGeneral" | cut -d":" -f2 | cut -d "(" -f1 | sed ':a;N;$!ba;s/\n/ /g')
            subtitleInfo=$(echo "$subtitleInfoGeneral" | cut -d":" -f2 | tr "(" " " | cut -d ")" -f1)

            if [ "$subtitleNumber" == '' ]; then
                echo -e "Not found any subtitle in the file: \"$fileName\""
            else
                echo -e "\\nSubtitles available in the file \"$fileName\":\\n$subtitleInfo"
                echo -en "\\nWhich one you want? (Only the number valid: $subtitleNumber): "
                read -r subNumber

                if echo "$subNumber" | grep -q "[[:digit:]]"; then
                    countSubtitleInfo=$(echo -e "$subtitleInfoGeneral" | wc -l)
                    countSubtitleInfo=$((countSubtitleInfo + 2))

                    if [ "$subNumber" -gt '1' ] && [ "$subNumber" -lt "$countSubtitleInfo" ]; then
                        lastPart=$(echo -e "$subtitleInfo" | grep "$subNumber")
                    else
                        lastPart=$(echo -e "$subtitleInfo" | head -n 1)
                        subNumber='2'
                    fi

                    echo -e "\\nExtracting the subtitle \"$lastPart\" from the file \"$fileName\""
                    fileNameTmp=$(echo "$fileName" | rev | cut -d "." -f2- | rev)
                    echo -e "That will be save as \"$fileNameTmp-$lastPart.srt\"\\n"

                    ffmpeg -i "$fileName" -an -vn -map 0:$subNumber -c:s:0 srt "${fileNameTmp}-${lastPart}.srt"

                    echo -e "\\nSubtitle \"$lastPart\" from \"$fileName\" \\nsaved as \"${fileNameTmp}-${lastPart}.srt\""
                else
                    echo -e "\\nError: The subtitle number must be a number\\n"
                fi
            fi
        else
            echo -e "\\nError: Need pass the file name\\n"
        fi
        ;;
     "mem-use" )
        echo -e "$CYAN# Get the all (shared and specific) use of memory RAM from one process/pattern #$NC\\n"
        if [ "$2" == '' ]; then
            echo -n "Insert the pattern (process name) to search: "
            read -r process
        else
            process=$2
        fi

        if  [ "$process" != '' ]; then
            processList=$(ps aux)
            processList=$(echo "$processList" | grep "$process" | grep -v -E "$0|grep")
            #ps -C chrome -o %cpu,%mem,cmd
            memPercentage=$(echo "$processList" | awk '{print $4}')

            memPercentageSum='0'
            for memPercentageNow in $memPercentage; do
                memPercentageSum=$(echo "scale=2; $memPercentageSum+$memPercentageNow" | bc)
            done

            totalMem=$(free -m | head -n 2 | tail -n 1 | awk '{print $2}')
            useMem=$(echo "($totalMem*$memPercentageSum)/100" | bc)

            echo -e "\\nThe process \"$process\" uses: $useMem MiB or $memPercentageSum % of $totalMem MiB\\n"

            echo -en "Show the process list?\\n(y)es - (n)o: "
            read -r showProcessList

            echo
            if [ "$showProcessList" == 'y' ]; then
                echo -e "$processList"
                echo
            fi
        else
            echo -e "$RED\\nError: You need insert some pattern/process name to search, e.g., $0 mem-use opera$NC"
        fi
        ;;
     "search-pkg" )
        echo -e "$CYAN# Search in the installed package folder (/var/log/packages/) for one pattern #$NC\\n"
        if [ "$2" == '' ]; then
            echo -n "Package file or pattern to search: "
            read -r filePackage
        else
            filePackage=$2
        fi

        echo -en "\\nSearching, please wait..."

        tmpFileName=$(mktemp) # Create a tmp file
        tmpFileFull=$(mktemp)

        for fileInTheFolder in /var/log/packages/*; do
            if grep -q "$filePackage" < "$fileInTheFolder"; then # Grep the "filePackage" from the file in /var/log/packages
                grep "PACKAGE NAME" < "$fileInTheFolder" >> "$tmpFileName" # Grep the package name from the has the "filePackage"
                cat "$fileInTheFolder" >> "$tmpFileFull" # Print all info about the package
                echo >> "$tmpFileFull" # Insert one new line
            fi
        done

        sizeResultFile=$(du "$tmpFileName")

        if [ "$sizeResultFile" != '0' ]; then
            echo -e "\\n\\nResults saved in \"$tmpFileName\" and \"$tmpFileFull\" tmp files\\n"

            echo -en "Open this files with kwrite or print them in the terminal?\\n(k)write - (t)erminal: "
            read -r openProgram

            if [ "$openProgram" == 'k' ]; then
                kwrite "$tmpFileName"
                kwrite "$tmpFileFull"
            else
                echo -e "\\nPackage(s) with '$filePackage':\\n"
                cat "$tmpFileName"

                echo -en "\\nPrint this package(s) in terminal?\\n(y)es - (p)artial, only the matches - (n)o: "
                read -r continuePrint
                echo
                if [ "$continuePrint" == 'y' ]; then
                    cat "$tmpFileFull"
                elif [ "$continuePrint" == 'p' ]; then
                    grep "$filePackage" < "$tmpFileFull"
                fi
            fi
        else
            echo -e "\\n\\n    No result was found"
        fi

        echo -e "\\nDeleting the log files used in this script"
        rm "$tmpFileName" "$tmpFileFull"
        ;;
    "work-fbi" )
        echo -e "$CYAN# Write <zero>/<random> value in one ISO file to wipe trace of old deleted file #$NC"
        echo -e "\\nWarning: Depending on how big is the amount of free space, this can take a long time"

        freeSpace=$(df . | awk '/[0-9]%/{print $(NF-2)}') # Free space local/pwd folder
        freeSpaceMiB=$(echo "scale=2; $freeSpace/1024" | bc) # Free space in MiB
        freeSpaceGiB=$(echo "scale=2; $freeSpace/(1024*1024)" | bc) # Free space in GiB
        timeAvgMin=$(echo "($freeSpaceMiB/30)/60" | bc)

        echo -e "\\nThere are$GREEN $freeSpaceGiB$CYAN GiB$NC ($GREEN$freeSpaceMiB$CYAN MiB$NC) free in this folder/disk/partition (that will be write)"
        echo -e "Considering$CYAN 30 MiB/s$NC in speed of write, will take$GREEN $timeAvgMin min$NC to finish this job"
        echo -en "\\nWant continue? (y)es - (n)o: "
        read -r contineDd

        if [ "$contineDd" == 'y' ]; then
            fileName="work-fbi_" # Create a ISO file with a random part name
            fileName+=$(date +%s | md5sum | head -c 10)
            fileName+=".iso"

            echo "You can use <zero> or <random> value"
            echo "Using <random> value is better to overwrite your deleted file"
            echo "Otherwise, is slower (almost 10 times) then use <zero> value"
            echo "Long story short, use <zero> if you has not deleted pretty good sensitive data"
            echo -en "\\nUse random or zero value?\\n(r)andom - (z)ero: "
            read -r continueRandomOrZero

            startAtSeconds=$(date +%s)

            if [ "$continueRandomOrZero" == 'r' ]; then
                typeWriteDd="random"
            else
                typeWriteDd="zero"
            fi
            echo -en "\\nWriting <$typeWriteDd> value in the \"$fileName\" tmp file. Please wait...\\n\\n"

            if [ "$continueRandomOrZero" == 'r' ]; then
                dd if=/dev/urandom of=$fileName iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <random> value to wipe the data
            else
                dd if=/dev/zero of=$fileName iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <zero> value to wipe the data
            fi

            endsAtSeconds=$(date +%s)
            timeTakeMin=$(echo "scale=2; ($endsAtSeconds - $startAtSeconds)/60" | bc)

            echo -e "\\nFinished to write the file - this take $timeTakeMin min"

            rm $fileName # Delete the <big> file generated
            echo -e "\\nThe \"$fileName\" tmp file was deleted and the end of the job"
        fi
        ;;
    "ip" )
        echo -e "$CYAN# Get your IP #$NC\\n"
        localIP=$(/sbin/ifconfig | grep broadcast | awk '{print $2}')
        echo "Local IP: $localIP"

        externalIP=$(wget -qO - icanhazip.com)
        echo "External IP: $externalIP"
        ;;
    "cpu-max" )
        echo -e "$CYAN# Show the 10 process with more CPU use #$NC\\n"
        ps axo pid,%cpu,%mem,cmd --sort=-pcpu | head -n 11
        ;;
    "mem-max" )
        echo -e "$CYAN# Show the 10 process with more memory RAM use #$NC\\n"
        ps axo pid,%cpu,%mem,cmd --sort -rss | head -n 11
        ;;
    "day-install" )
        echo -e "$CYAN# The day the system are installed #$NC"
        dayInstall=$(stat -c %z / | sort | head -n 1 | cut -d '.' -f1)
        echo -e "\\nThe system was installed in: $dayInstall"
        ;;
    "print-lines" )
        echo -e "$CYAN# Print part of file (lineStart to lineEnd) #$NC"
        inputFile=$2 # File to read

        if [ "$inputFile" == '' ]; then
            echo -e "$RED\\nError: You need to pass the file name, e.g., $0 print-lines file.txt$NC"
        else
            lineStart=$3
            lineEnd=$4

            if [ "$lineStart" == '' ] || [ "$lineEnd" == '' ]; then
                echo -n "Line to start: "
                read -r lineStart
                echo -n "Line to end: "
                read -r lineEnd
            fi

            if echo "$lineStart" | grep -q "[[:digit:]]" && echo "$lineEnd" | grep -q "[[:digit:]]"; then
                if [ "$lineStart" -gt "$lineEnd" ]; then
                    lineStartTmp=$lineEnd
                    lineEnd=$lineStart
                    lineStart=$lineStartTmp
                fi

                echo -e "\\nPrint \"$inputFile\" line $lineStart to $lineEnd\\n"
                lineStartTmp=$((lineEnd-lineStart))
                ((lineStartTmp++))

                cat -n "$inputFile" | head -n "$lineEnd" | tail -n "$lineStartTmp"
            else
                echo -e "$RED\\nError: lineStart and lineEnd must be number$NC"
            fi
        fi
        ;;
    "screenshot" )
        echo -e "$CYAN# Screenshot from display :0 #$NC\\n"

        echo -n "Delay before the screenshot (in seconds): "
        read -r secondsBeforeScrenshot

        if echo "$secondsBeforeScrenshot" | grep -q "[[:digit:]]"; then
            sleep "$secondsBeforeScrenshot"
        fi

        dateNow=$(date +%s)
        import -window root -display :0 "screenshot_${dateNow}.jpg"

        echo -e "\\nScreenshot \"screenshot_${dateNow}.jpg\"\\nsaved in the folder \"$(pwd)/\""
        ;;
    "folder-diff" )
        echo -e "$CYAN# Show the difference between two folder and (can) make them equal (with rsync) #$NC"
        if [ $# -lt 3 ]; then
            echo -e "$RED\\nError: Need two parameters, $0 folder-diff 'pathSource' 'pathDestination'$NC"
        else
            echo -e "\\n$GREEN    ## An Important Note ##$BLUE\\n"
            echo -e "The trailing slash (/) at the end of the first argument (source folder)"
            echo -e "For example: \"rsync -a dir1/ dir2\" is necessary to mean \"the contents of dir1\""
            echo -e "The alternative (without the trailing slash) would place dir1 (including the directory) within dir2"
            echo -e "This would create a hierarchy that looks like: dir2/dir1/[files]"
            echo -e "\\n$CYAN## Please double-check your arguments before continue ##$NC"

            pathSource=$2
            pathDestination=$3
            echo -e "$CYAN\\nSource folder:$GREEN $pathSource$CYAN"
            echo -e "Destination folder:$GREEN $pathDestination$NC"

            echo -en "$CYAN\\nWant continue and use these source and destination folders?\\n(y)es - (n)o:$NC "
            read -r continueRsync

            if [ "$continueRsync" == 'y' ]; then
                if [ -e "$pathSource" ]; then # Test if "source" exists
                    if [ -e "$pathDestination" ]; then # Test if "destination" exists
                        echo -e "\\n\\t$RED#-----------------------------------------------------------------------------#"
                        echo -en "$CYAN$GREEN\\t 1$CYAN Just see differences or$GREEN 2$CYAN Make them equal now? $GREEN(enter to see differences)$NC: "
                        read -r syncNowOrNow

                        if [ "$syncNowOrNow" == "2" ]; then
                            echo -e "$CYAN\\nMaking the files equal.$NC Please wait..."
                            rsync -crvh --delete "$pathSource" "$pathDestination"
                        else
                            echo -en "$CYAN\\nPlease wait until all files are compared...$NC"
                            folderChangesFull=$(rsync -aicn --delete "$pathSource" "$pathDestination")
                            # -a archive mode; -i output a change-summary for all updates
                            # -c skip based on checksum, not mod-time & size; -n perform a trial run with no changes made
                            # --delete delete extraneous files from destination directories

                            folderChangesClean=$(echo -e "$folderChangesFull" | grep -E "^>|^*deleting|^c|/$")

                            echo # just a new blank line
                            foldersNew=$(echo -e "$folderChangesClean" | grep "^c" | awk '{print substr($0, index($0,$2))}') # "^c" - new folders
                            if [ "$foldersNew" != '' ]; then
                                echo -e "$BLUE\\nFolders new:$NC"
                                echo "$foldersNew" | sort
                            fi

                            filesDelete=$(echo -e "$folderChangesClean" | grep "^*deleting" | awk '{print substr($0, index($0,$2))}') # "*deleting" - files deleted
                            if [ "$filesDelete" != '' ]; then
                                echo -e "$BLUE\\nFiles to be deleted:$NC"
                                echo "$filesDelete" | sort
                            fi

                            filesDifferent=$(echo -e "$folderChangesClean" | grep "^>fc" | awk '{print substr($0, index($0,$2))}') # ">fc" - all files changed
                            if [ "$filesDifferent" != '' ]; then
                                echo -e "$BLUE\\nFiles different:$NC"
                                echo "$filesDifferent" | sort
                            fi

                            filesNew=$(echo -e "$folderChangesClean" | grep "^>f++++"| awk '{print substr($0, index($0,$2))}') # ">f++++" - New files
                            if [ "$filesNew" != '' ]; then
                                echo -e "$BLUE\\nNew files:$NC"
                                echo "$filesNew" | sort
                            fi

                            if [ "$foldersNew" == '' ] && [ "$filesDelete" == '' ] && [ "$filesDifferent" == '' ] && [ "$filesNew" == '' ]; then
                                echo -e "$GREEN\\nThe source folder ($pathSource) and the destination folder ($pathDestination) don't have any difference$NC"
                            else
                                echo -en "$CYAN\\nShow full rsync change-summary?\\n(y)es - (n)o:$NC "
                                read -r showRsyncS
                                if [ "$showRsyncS" == 'y' ]; then
                                    echo -e "\\n$folderChangesFull"
                                fi

                                echo -en "$CYAN\\nShow clean rsync change-summary?\\n(y)es - (n)o:$NC "
                                read -r showRsyncS
                                if [ "$showRsyncS" == 'y' ]; then
                                    echo -e "\\n$folderChangesClean"
                                fi

                                echo -e "\\n\\t$RED#------------------------------#"
                                echo -en "$CYAN\\t Make this change on the disk?\\n\\t (y)es - (n)o:$NC "
                                read -r continueWriteDisk
                                if [ "$continueWriteDisk" == 'y' ]; then
                                    echo -e "$CYAN\\nChanges are writing in $pathDestination.$NC Please wait..."
                                    rsync -crvh --delete "$pathSource" "$pathDestination"
                                else
                                    echo -e "$CYAN\\n    None change writes in disk$NC"
                                fi
                            fi
                        fi
                    else
                        echo -e "$RED\\nError: The destination ($pathDestination) don't exist$NC"
                    fi
                else
                    echo -e "$RED\\nError: The source ($pathSource) don't exist$NC"
                fi
            else
                echo -e "$CYAN\\n    None change writes on the disk$NC"
            fi
        fi
        ;;
    "search-pwd" )
        echo -e "$CYAN# Search in this directory (recursive) for a pattern #$NC"
        if [ "$2" == '' ]; then
            echo -en "\\nPattern to search: "
            read -r patternSearch
        else
            patternSearch=$2
        fi

        echo -e "\\nSearching, please wait...\\n\\n"
        grep -rn "$patternSearch"
        # -r recursive, -n print line number with output lines
        ;;
    "ping-test" | "mtr-test" )
        echo -e "$CYAN# Running $optionInput to a domain (default is google.com) #$NC\\n"

        domainToWork=$2
        if [ "$domainToWork" == '' ]; then
            domainToWork="google.com"
        fi

        if [ "$optionInput" == "ping-test" ]; then
            commandToRun="ping -c 3 $domainToWork"
        else
            commandToRun="su root -c 'mtr $domainToWork'"
        fi

        echo -en "\\nRunning: $commandToRun\\n"
        eval "$commandToRun"
        ;;
    "create-wifi" )
        echo -e "$CYAN# Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\\n"
        createWifiConfig() {
            echo -en "\\nName of the network (SSID): "
            read -r netSSID

            echo -en "\\nPassword of this network: "
            read -r -s netPassword

            wpa_passphrase "$netSSID" "$netPassword" | grep -v "#psk" >> /etc/wpa_supplicant.conf
        }

        export -f createWifiConfig
        if [ "$(whoami)" != "root" ]; then
            echo -e "$CYAN\\nInsert the root Password to continue$NC"
        fi

        su root -c 'createWifiConfig' # In this case without the hyphen (su - root -c 'command') to no change the environment variables
        ;;
    "cn-wifi" )
        echo -e "$CYAN# Connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\\n"
        if pgrep -f "NetworkManager" > /dev/null; then # Test if NetworkManager is running
            echo -e "$RED\\nError: NetworkManager is running, please kill him with: killall NetworkManager$NC"
        else
            if [ "$LOGNAME" != "root" ]; then
                echo -e "$RED\\nError: Execute as root user$NC"
            else
                killall wpa_supplicant # kill the previous wpa_supplicant "configuration"

                networkConfigAvailable=$(grep "ssid" < /etc/wpa_supplicant.conf)
                if [ "$networkConfigAvailable" == '' ]; then
                    echo -e "$RED\\nError: Not find configuration of anyone network (in /etc/wpa_supplicant.conf).\\n Try: $0 create-wifi$NC"
                else
                    echo "Choose one network to connect:"
                    grep "ssid" < /etc/wpa_supplicant.conf
                    echo -n "Network name: "
                    read -r networkName

                    #sed -n '/Beginning of block/!b;:a;/End of block/!{$!{N;ba}};{/some_pattern/p}' fileName # sed in block text
                    wpaConf=$(sed -n '/network/!b;:a;/}/!{$!{N;ba}};{/'"$networkName"'/p}' /etc/wpa_supplicant.conf)

                    if [ "$wpaConf" == '' ]; then
                        echo -e "$RED\\nError: Not find configuration to network '$networkName' (in /etc/wpa_supplicant.conf).\\n Try: $0 create-wifi$NC"
                    else
                        TMPFILE=$(mktemp) # Create a tmp file
                        grep -v -E "{|}|ssid|psk" < /etc/wpa_supplicant.conf > "$TMPFILE"

                        echo -e "$wpaConf" >> "$TMPFILE" # Save the configuration of the network on this file

                        echo -e "\\n########### Network configuration ####################"
                        cat "$TMPFILE"
                        echo -e "######################################################"

                        #wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -d -B wext # Normal command

                        loadDevWirelessInterface "$2"

                        wpa_supplicant -i $devInterface -c "$TMPFILE" -d -B wext # Connect with the network using the tmp file

                        rm "$TMPFILE" # Delete the tmp file

                        dhclient $devInterface # Get IP

                        iw dev $devInterface link # Show connection status
                    fi
                fi
            fi
        fi
        ;;
    "dc-wifi" )
        echo -e "$CYAN# Disconnect of one Wi-Fi network #$NC\\n"

        loadDevWirelessInterface "$2"

        su - root -c "dhclient -r $devInterface
        ifconfig $devInterface down
        iw dev $devInterface link"
        ;;
    "mem-info" )
        echo -e "$CYAN# Show memory and swap percentage of use #$NC"
        memTotal=$(free -m | grep Mem | awk '{print $2}') # Get total of memory RAM
        memUsed=$(free -m | grep Mem | awk '{print $3}') # Get total of used memory RAM
        memUsedPercentage=$(echo "scale=0; ($memUsed*100)/$memTotal" | bc) # Get the percentage "used/total", |valueI*100/valueF|
        echo -e "\\nMemory used: ~ $memUsedPercentage % ($memUsed of $memTotal MiB)"

        testSwap=$(free -m | grep Swap | awk '{print $2}') # Test if has Swap configured
        if [ "$testSwap" -eq '0' ]; then
            echo "Swap is not configured in this computer"
        else
            swapTotal=$(free -m | grep Swap | awk '{print $2}')
            swapUsed=$(free -m | grep Swap | awk '{print $3}')
            swapUsedPercentage=$(echo "scale=0; ($swapUsed*100)/$swapTotal" | bc) # |valueI*100/valueF|
            echo "Swap used: ~ $swapUsedPercentage % ($swapUsed of $swapTotal MiB)"
        fi
        ;;
    "l-iw" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iw (show WPS and more infos) #$NC\\n"

        loadDevWirelessInterface "$2"

        su - root -c "/usr/sbin/iw dev $devInterface scan | grep -E '$devInterface|SSID|signal|WPA|WEP|WPS|Authentication|WPA2|: channel'"
        ;;
    "l-iwlist" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos) #$NC\\n"

        loadDevWirelessInterface "$2"

        /sbin/iwlist $devInterface scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"
        ;;
    "texlive-up" )
        echo -e "$CYAN# Update the texlive packages #$NC\\n"
        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "nm-list" )
        echo -e "$CYAN# List the Wi-Fi AP around with the nmcli from NetworkManager #$NC\\n"
        nmcli device wifi list
        ;;
    "brigh-1" )
        echo -e "$CYAN# Set brightness percentage value (accept % value, up and down) #$NC"
        if [ "$#" -eq '1' ]; then
            brightnessValueOriginal='1'
        else
            brightnessValueOriginal=$2
        fi

        if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
            if [ "$brightnessValueOriginal" -gt "100" ]; then # Test max percentage
                brightnessValueOriginal="100"
            fi
        fi

        if [ -f /sys/class/backlight/acpi_video0/brightness ]; then # Choose the your path from "files brightness"
            pathFile="/sys/class/backlight/acpi_video0"
        elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
            pathFile="/sys/class/backlight/intel_backlight"
        else
            echo -e "$RED\\nError: File to set brightness not found$NC"
        fi

        if [ "$pathFile" != '' ]; then
            brightnessMax=$(cat $pathFile/max_brightness) # Get max_brightness
            brightnessPercentage=$(echo "scale=3; $brightnessMax/100" | bc) # Get the percentage of 1% from max_brightness

            actualBrightness=$(cat $pathFile/actual_brightness) # Get actual_brightness
            actualBrightness=$(echo "scale=2; $actualBrightness/$brightnessPercentage" | bc)

            brightnessValue=$actualBrightness
            if [ "$2" == "up" ]; then # More 1 % (more 0.1 to appears correct percentage value in the GUI interface)
                brightnessValue=$(echo "scale=2; $brightnessValue" + 1.1 | bc)
            elif [ "$2" == "down" ]; then # Less 1 % (more 0.1 to appears correct percentage value in the GUI interface)
                brightnessValue=$(echo "scale=2; $brightnessValue" - 1.1 | bc)
            else # Set Input value more 0.1 to appears correct percentage value in the GUI interface
                brightnessValue=$(echo "scale=1; $brightnessValueOriginal+0.1" | bc)
            fi

            brightnessValueFinal=$(echo "scale=0; $brightnessPercentage*$brightnessValue/1" | bc) # Get no value percentage vs Input value brightness

            if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
                if [ $brightnessValueOriginal -gt "99" ]; then # If Input value brightness more than 99%, set max_brightness to brightness final
                    brightnessValueFinal=$brightnessMax
                fi
            fi

            echo -e "\\nFile to set brightness: $pathFile/brightness"
            echo "Actual brightness: $actualBrightness %"
            echo "Input value brightness: $brightnessValueOriginal"
            echo "Final percentage brightness value: $brightnessValue"
            echo -e "Final set brightness value: $brightnessValueFinal\\n"

            # Only for test
            #echo "Max brightness value: $brightnessMax"
            #echo "Percentage value to 1% of brightness: $brightnessPercentage"

            # Set the final percentage brightness
            su - root -c "echo $brightnessValueFinal > $pathFile/brightness"
        fi
        ;;
    "brigh-2" )
        echo -e "$CYAN# Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %) #$NC"
        if [ "$#" -eq '1' ]; then # Option without value set brightness in 1%
            xbacklight -set 1
        elif [ "$#" -eq '2' ]; then # Option to one value of input to set
            if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
                brightnessValue=$2
                if [ "$brightnessValue" -gt "100" ]; then # Test max percentage
                    brightnessValue="100"
                fi
                xbacklight -set "$brightnessValue"
            else
                if [ "$2" == "up" ];then
                    xbacklight -inc 1
                elif [ "$2" == "down" ];then
                    xbacklight -dec 1
                else
                    echo -e "$RED\\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            fi
        else #elif [ "$#" -eq '3' ]; then # Option to two value of input to set
            if echo "$3" | grep -q "[[:digit:]]"; then # Test if has only digit
                if [ "$2" == "up" ];then
                    xbacklight -inc "$3"
                elif [ "$2" == "down" ];then
                    xbacklight -dec "$3"
                else
                    echo -e "$RED\\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            else
                echo -e "$RED\\nError: Value must be only digit (e.g. $0 brigh-2 up 10 to set brightness up in 10 %)$NC"
            fi
        fi
        ;;
    "pkg-count" )
        echo -e "$CYAN# Count of packages that are installed your Slackware #$NC"
        countPackages=$(find /var/log/packages/ | wc -l)
        echo -e "\\nThere are $countPackages packages installed"
        ;;
    "l-pkg-i" | "l-pkg-r" | "l-pkg-u" )

        if [ "$optionInput" == "l-pkg-i" ]; then
            functionWord="installed"
            workFolder="/var/log/packages/"
            commandPart2=''
        else
            workFolder="/var/log/removed_packages/"

            if [ "$optionInput" == "l-pkg-r" ]; then
                functionWord="removed"
                commandPart2=' | grep -v "upgrade"'
            else
                functionWord="upgrade"
                commandPart2=' | grep "upgrade"'
            fi
        fi

        echo -e "$CYAN# List the last package(s) $functionWord (accept 'n', where 'n' is a number of packages, the default is 10) #$NC\\n"

        if [ "$#" -eq '1' ]; then
            numberPackages="10"
        else
            if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
                numberPackages=$2
            else
                numberPackages="10"
            fi
        fi

        commandPart1='ls -ltc '"$workFolder"' | grep -v "total [[:digit:]]"'
        commandPart3=' | head -n '"$numberPackages"''

        commandFinal=$commandPart1$commandPart2$commandPart3
        echo -e "\\nRunning: $commandFinal\\n"
        eval "$commandFinal"
        ;;
    "pdf-r" ) # Need Ghostscript
        echo -e "$CYAN# Reduce a PDF file #$NC"
        if [ "$#" -eq '1' ]; then
            echo -e "$RED\\nError: Use $0 pdf-r file.pdf$NC"
        else # Convert the file
            filePdfInput=$2
            if [ -e "$filePdfInput" ]; then
                filePdfOutput=${filePdfInput::-4}

                fileChangeOption=$3
                if ! echo "$fileChangeOption" | grep -q "[[:digit:]]"; then
                    echo -en "\\nFile change options:\\n1 - Small size\\n2 - Better quality\\n3 - Minimal changes\\n4 - All 3 above\\nWhich option you want? (hit enter to insert 4): "
                    read -r fileChangeOption
                fi

                if [ "$fileChangeOption" == '1' ]; then
                    sizeQuality="ebook"
                elif [ "$fileChangeOption" == '2' ]; then
                    sizeQuality="screen"
                elif [ "$fileChangeOption" == '4' ] || [ "$fileChangeOption" == '' ]; then
                    # $1 = pdf-r, $2 = fileName.pdf, $3 = fileChangeOption
                    echo
                    $0 $colorPrint notPrintHeader "$1" "$filePdfInput" 1
                    echo
                    $0 $colorPrint notPrintHeader "$1" "$filePdfInput" 2
                    echo
                    $0 $colorPrint notPrintHeader "$1" "$filePdfInput" 3
                else
                    fileChangeOption='3'
                fi

                if [ "$fileChangeOption" != '4' ]; then
                    fileNamePart="_rOp${fileChangeOption}.pdf"

                    echo -e "$CYAN\\nRunning: $0 $1 $filePdfInput $fileChangeOption\\n$NC"
                    if [ "$fileChangeOption" == '3' ]; then
                        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$filePdfOutput$fileNamePart" "$filePdfInput"
                    else
                        gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/$sizeQuality -dNOPAUSE -dBATCH -sOutputFile="$filePdfOutput$fileNamePart" "$filePdfInput"
                    fi

                    echo -e "\\nThe output PDF: \"$filePdfOutput$fileNamePart\" was saved"
                fi
            else
                echo -e "$RED\\nError: The file \"$filePdfInput\" not exists$NC"
            fi
        fi
        ;;
    "swap-clean" )
        echo -e "$CYAN# Clean up the Swap Memory #$NC"
        testSwap=$(free -m | grep Swap | awk '{print $2}') # Test if has Swap configured
        if [ "$testSwap" -eq '0' ]; then
            echo -e "\\nSwap is not configured in this computer"
        else
            swapTotal=$(free -m | grep Swap | awk '{print $2}')
            swapUsed=$(free -m | grep Swap | awk '{print $3}')
            swapUsedPercentage=$(echo "scale=0; ($swapUsed*100)/$swapTotal" | bc) # |valueI*100/valueF|

            echo -e "\\nSwap used: ~ $swapUsedPercentage % ($swapUsed of $swapTotal MiB)"

            if [ "$swapUsed" -eq '0' ]; then
                echo -e "\\nSwap is already clean"
            else
                if [ "$2" == '' ]; then
                    echo -en "\\nTry clean the Swap? \\n(y)es - (n)o: "
                    read -r cleanSwap
                else
                    cleanSwap='y'
                fi

                if [ "$cleanSwap" == 'y' ]; then
                    su - root -c 'echo -e "\\nCleaning swap. Please wait..."
                    swapoff -a
                    swapon -a'
                fi
            fi
        fi
        ;;
    "slack-up" )
        echo -e "$CYAN# Slackware update #$NC"
        slackwareUpdate() {
            USEBL=$1
            installNew=$2

            if [ "$USEBL" == '' ]; then
                echo -en "\\nUse blacklist?\\n(y)es - (n)o (hit enter to no): "
                read -r USEBL
            fi

            echo -en "\\nUsing blacklist: "
            if [ "$USEBL" == 'y' ]; then # Using blacklist
                echo "Yes"
                USEBL='1'
            else # Not using blacklist
                echo "No"
                USEBL='0'
            fi

            if [ "$installNew" == '' ]; then
                echo -en "\\nRun \"slackpkg install-new\" for safe profuse?\\n(y)es - (n)o (hit enter to no): "
                read -r installNew
            fi

            slackpkg update -batch=on

            if [ "$installNew" == 'y' ]; then
                slackpkg install-new
            fi

            USEBL=$USEBL slackpkg upgrade-all
        }

        USEBL=$2
        installNew=$3
        export -f slackwareUpdate

        su root -c "slackwareUpdate $USEBL $installNew" # In this case without the hyphen (su - root -c 'command') to no change the environment variables
        ;;
    "up-db" )
        echo -e "$CYAN# Update the database for the 'locate' #$NC\\n"
        su - root -c "updatedb" # Update database
        echo -e "\\nDatabase updated"
        ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        echo -e "$CYAN# Show the weather forecast (you can pass the name of the city as parameter) #$NC\\n"
        cityName=${*:2} # Get the second parameter to the end

        if [ "$cityName" == '' ]; then
            cityName="Rio Paranaíba"
        fi

        wget -qO - "wttr.in/$cityName" # Get the weather information
        ;;
     "now" )
        echo -e "$CYAN# now - Run \"date-up\" \"swap-clean\" \"slack-up y y\" and \"up-db\" sequentially #$NC"

        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader date-up$NC\\n" | sed 's/  / /g'
        $0 $colorPrint notPrintHeader date-up

        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader swap-clean y$NC\\n" | sed 's/  / /g'
        $0 $colorPrint notPrintHeader swap-clean y

        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader slack-up y y$NC\\n" | sed 's/  / /g'
        $0 $colorPrint notPrintHeader slack-up y y

        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader up-db$NC\\n" | sed 's/  / /g'
        $0 $colorPrint notPrintHeader up-db
        ;;
    * )
        echo -e "\\n    $(basename "$0") - Error: Option \"$1\" not recognized"
        echo -e "    Try: $0 '--help'"
        ;;
esac

if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE\\n        #___ So Long, and Thanks for All the Fish ___#$NC"
else
    shift
fi
