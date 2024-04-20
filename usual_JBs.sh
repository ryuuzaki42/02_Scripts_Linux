#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
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
# Script: usual / common day-to-day functions general
#
# Last update: 17/04/2024
#
useColor() {
    #BLACK='\e[1;30m'
    RED='\e[1;31m'
    GREEN='\e[1;32m'
    NC='\033[0m' # reset/no color
    BLUE='\e[1;34m'
    #PINK='\e[1;35m'
    CYAN='\e[1;36m'
    #WHITE='\e[1;37m'
}

notUseColor() {
    #unset BLACK RED GREEN NC BLUE PINK CYAN WHITE
    unset RED GREEN NC BLUE CYAN
}

emptySpaces=$1 # Remove empty space form calls in this script to itself with $colorPrint empty
if [ "$emptySpaces" == '' ]; then
    shift
fi

colorPrint=$1
if [ "$colorPrint" == "noColor" ]; then
    echo -e "\nColors disabled"
    shift
else # Some colors for script output - Make it easier to follow
    useColor
    colorPrint=''
fi

notPrintHeaderHeader=$1
if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE        #___ Script to usual commands ___#$NC\n"
else
    shift
fi

testColorInput=$1
if [ "$testColorInput" == "testColor" ]; then
    #echo -e "\n    Test colors: $BLACK BLACK $RED RED $GREEN GREEN $NC NC $BLUE BLUE $PINK PINK $CYAN CYAN $WHITE WHITE\n"
    echo -e "\n    Test colors: $RED RED $GREEN GREEN $NC NC $BLUE BLUE $CYAN CYAN\n"
    shift
fi

optionInput=$1
case $optionInput in
    "date-up" )
        echo -e "$CYAN# Update the date #$NC"

        dateUpFunction() { # Need to be run as root
            ntpVector=("pool.ntp.org" "ntp1.ptb.de" "ntp.usp.br" "200.20.186.75" "bonehed.lcs.mit.edu") # Ntp servers
            #${#ntpVector[*]} # size of ntpVector
            #${ntpVector[$i]} # value of the $i index in ntpVector
            #${ntpVector[@]} # all value of the vector

            tmpFileNtpError=$(mktemp) # Create a tmp file
            timeUpdated="false"

            for ntpValue in "${ntpVector[@]}"; do # Run until flagContinue is false and run the break or ntpVector get his end
                echo -e "\nRunning: ntpdate -u -b $ntpValue"
                ntpdate -u -b "$ntpValue" 2> "$tmpFileNtpError" # Run ntpdate with one value of ntpVector and send the errors to a tmp file

                if ! grep -q -v "no server" "$tmpFileNtpError"; then # Test if ntpdate got error "no server suitable for synchronization found"
                    if ! grep -q -v "time out" "$tmpFileNtpError"; then # Test if ntpdate got error "time out"
                        if ! grep -q -v "name server cannot be used" "$tmpFileNtpError"; then # Test if can name resolution works
                            echo -e "\n${CYAN}Time updated:$GREEN $(date)$NC"
                            timeUpdated="true" # Set true in the timeUpdated
                            break
                        fi
                    fi
                fi
            done

            if [ "$timeUpdated" == "false" ]; then
                echo -e "\nSorry,$RED time not updated$NC: $(date)"
                if grep -q "name server cannot be used" "$tmpFileNtpError"; then # Test if can name resolution works
                    echo -e "\nError:$RED No connection found$NC - Check your network connection"
                fi
            fi

            #cat $tmpFileNtpError
            rm "$tmpFileNtpError" # Delete the tmp file
        }

        export -f dateUpFunction
        export CYAN NC GREEN RED
        if [ "$(whoami)" != "root" ]; then
            echo -e "$CYAN\nInsert the root Password to continue$NC"
        fi

        su root -c 'dateUpFunction' # In this case without the hyphen (su - root -c 'command') to no change the environment variables

        # It's advisable that users acquire the habit of always following the su command with a space and then a hyphen
        # The hyphen: (1) switches the current folder to the home folder of the new user (e.g., to /root in the case of the root user) and
        # (2) it changes the environmental variables to those of the new user
        # If the first argument to su is a hyphen, the current folder and environment will be changed to what would be expected if the new user had actually
        # logged on to a new session (rather than just taking over an existing session)
        ;;
    "--help" | "-h" | "help" | 'h' | '' | 'w' )
        if [ "$optionInput" == '' ] || [ "$optionInput" == 'w' ]; then # whiptailMenu()
            notUseColor
        fi

        # Options text
        optionVector=("audio-extract " "   - Extract audio from a video file"
        "brigh-1     " "$RED * - Set brightness percentage value (accept % value, up and down)"
        "brigh-2     " "$BLUE = - Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %)"
        "check-pkg-i " "   - Check if all packages in a folder (and subfolders) are installed"
        "cpu-max     " "   - Show the 10 process with more CPU use"
        "date-up     " "$RED * - Update the date"
        "day-s-i     " "$RED * - The day the system was installed"
        "file-equal  " "   - Look for equal files using md5sum in the current folder (and subfolders)"
        "folder-diff " "   - Show the difference between two folders and (can) make them equal (with rsync)"
        "folder-equal" "   - Look for equal files in \"folder2\" that are in \"folder1\" using md5sum"
        "git-gc      " "   - Run git gc (|--auto|--aggressive) in the subfolders"
        "git-up      " "   - Run git pull and force update to the local files (deleting changes) with the remote in the subfolders"
        "help        " "   - Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h')"
        "ip          " "   - Get your IP"
        "kill        " "   - Search for program with pattern/name and (can) kill it"
        "l-pkg-i     " "   - List the last package(s) installed (accept 'n', where 'n' is a number of packages, the default is 10)"
        "l-pkg-r     " "   - List the last package(s) removed (accept 'n', where 'n' is a number of packages, the default is 10)"
        "l-pkg-u     " "   - List the last package(s) upgrade (accept 'n', where 'n' is a number of packages, the default is 10)"
        "mem-info    " "   - Show memory and swap percentage of use"
        "mem-max     " "   - Show the 10 process with more memory RAM use"
        "mem-use     " "   - Get the all (shared and specific) use of memory RAM from one process/pattern"
        "mtr-test    " "$RED * - Run a mtr-test on a domain (default is google.com)"
        "pdf-r       " "   - Reduce a PDF file"
        "ping-test   " "   - Run a ping-test on a domain (default is google.com)"
        "pkg-count   " "   - Count of packages that are installed your Slackware"
        "pkg-i       " "$RED * - Install package(s) from a folder (and subfolders) in the Slackware"
        "pkg-r       " "$RED * - Remove package(s) from a folder (and subfolders) in the Slackware"
        "pkg-u       " "$RED * - Upgrade package(s) from a folder (and subfolders) in the Slackware"
        "print-lines " "   - Print part of file (lineStart to lineEnd)"
        "s-pkg-f     " "   - Search in the installed package folder (/var/log/packages/) for one pattern (-f of fast)"
        "s-pkg-s     " "   - Search in the installed package folder (/var/log/packages/) for one pattern (-r of summary files)"
        "screenshot  " "   - Screenshot from display :0"
        "search-pwd  " "   - Search in this folder (recursive) for a pattern"
        "shred       " "   - shred files in local folder (and subfolders)"
        "slack-up    " "$RED * - Slackware update"
        "sub-extract " "   - Extract subtitle from a video file"
        "swap-clean  " "$RED * - Clean up the Swap Memory"
        "texlive-up  " "$RED * - Update the texlive packages"
        "up-db       " "$RED * - Update the database for the 'locate'"
        "w           " "   - Menu with whiptail, where you can call the others options (the same result with 'w' or '')"
        "weather     " "   - Show the weather forecast (you can pass the name of the city as parameter)"
        "work-fbi    " "   - Write <zero>/<random> value in one ISO file to wipe trace of old deleted file")

        if [ "$colorPrint" == '' ]; then # set useColor on again if the use not pass "noColor"
            useColor
        fi

        case $optionInput in
            "--help" | "-h" | "help" | 'h' )
                help() {
                    echo -e "$CYAN# Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h') #$NC"
                    echo -e "\n$RED    Obs$CYAN:$RED * root required,$BLUE = X server required$CYAN\nOptions:"

                    countOption=0
                    optionVectorSize=${#optionVector[*]}
                    while [ "$countOption" -lt "$optionVectorSize" ]; do
                        echo -e "    $GREEN${optionVector[$countOption]}$CYAN${optionVector[$countOption+1]}"

                        countOption=$((countOption + 2))
                    done
                }

                help
                ;;
            '' | 'w' )
                whiptailMenu() {
                    echo -e "$CYAN# Menu with whiptail, where you can call the options above (the same result with 'w' or '') #$NC"
                    eval "$(resize)"

                    heightWhiptail=$((LINES - 5))
                    widthWhiptail=$((COLUMNS - 5))

                    if [ "$LINES" -lt 16 ]; then
                        echo -e "$RED\nTerminal with very small size. Use one terminal with at least 16 columns (actual size line: $LINES columns: $COLUMNS)$NC"
                        echo -e "$GREEN\nRunning: $0 $colorPrint notPrintHeader --help$CYAN\n" | sed 's/  / /g'
                        $0 "$colorPrint" notPrintHeader --help
                    else
                        heightMenuBoxWhiptail=$((LINES - 15))

                        #whiptail --title "<title of box menu>" --menu "<text to be show>" <height> <width> <height of box menu> \
                        #[ <tag> <item> ] [ <tag> <item> ] [ <tag> <item> ]

                        itemSelected=$(whiptail --title "#___ Script to usual commands ___#" --menu "Obs.: * root required, = X server required

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
                        "${optionVector[78]}" "${optionVector[79]}" \
                        "${optionVector[80]}" "${optionVector[81]}" \
                        "${optionVector[82]}" "${optionVector[83]}" 3>&1 1>&2 2>&3)

                        if [ "$itemSelected" != '' ]; then
                            itemSelected=${itemSelected// /} # Remove space in the end of selected item
                            echo -e "$GREEN\nRunning: $0 $colorPrint notPrintHeader $itemSelected ${*} $CYAN\n" | sed 's/  / /g'

                            if [ "${*}" != '' ]; then # Check if has more parameters
                                $0 "$colorPrint" notPrintHeader "$itemSelected" "${*}"
                            else # If has no more parameters, pass with . (PWD)
                                $0 "$colorPrint" notPrintHeader "$itemSelected" "."
                            fi
                        fi
                    fi
                }

                whiptailMenu "${*:2}"
                ;;
        esac
        ;;
    "check-pkg-i" )
        echo -e "$CYAN# Check if all packages in a folder (and subfolders) are installed #$NC"

        folderWork=$2
        if [ "$folderWork" == '' ]; then
            echo -e "$RED\nError: You need pass the folder to work"
        elif [ ! -d "$folderWork" ]; then
            echo -e "$RED\nError: The folder \"$folderWork\" not exist"
        else
            echo -e "\n$CYAN Folder to work with: $folderWork$NC"
            files=$(find "$folderWork" -type f | grep -E "txz$|tgz$")
            filesName=$(echo "$files" | rev | cut -d '.' -f2- | cut -d '/' -f1 | rev)

            echo -e "$CYAN\nPackages not installed:$NC"
            linePkg=1
            pkgInstalled=''
            pkgNotInstalled=''
            for pkg in $filesName; do
                locatePkg=$(ls "/var/log/packages/$pkg" 2> /dev/null)

                if [ "$locatePkg" == '' ]; then
                    pkgNotInstalled=$pkgNotInstalled$(echo "$files" | sed -n ${linePkg}p)"\n"
                else
                    pkgInstalled=$pkgInstalled$(echo "$files" | sed -n ${linePkg}p)"\n"
                fi

                ((linePkg++))
            done
            echo -e "$pkgNotInstalled" | sort

            echo -en "$CYAN\nPrint the packages installed? (y)es or (n)o: $NC"
            read -r printPkg
            if [ "$printPkg" == 'y' ]; then
                echo -e "$pkgInstalled" | sort
            fi
        fi
        ;;
    "git-gc" )
        echo -e "$CYAN# Run git gc (|--auto|--aggressive) in the subfolders #$NC"

        echo -e "\nCommands available:"
        echo "1 - \"git gc\""              # Cleanup unnecessary files and optimize the local repository
        echo "2 - \"git gc --auto\""       # Checks whether any housekeeping is required; if not, it exits without performing any work
        echo "3 - \"git gc --aggressive\"" # More aggressively, optimize the repository at the expense of taking much more time
        echo -n "Which option you want? (hit enter to insert 1): "
        read -r git_option

        git_command="git gc"
        if [ "$git_option" == 2 ]; then
            git_command="$git_command --auto"
        elif [ "$git_option" == 3 ]; then
            git_command="$git_command --aggressive"
        fi

        for folder in $(find . -maxdepth 1 -type d | grep -v "^.$"| sort); do
            echo -e "\n$BLUE Folder: $GREEN$folder/$NC"
            cd "$folder/" || exit

            if [ -d ".git/" ]; then
                echo -e "$BLUE Running: $GREEN$git_command$NC\n"
                $git_command
            else
                echo -e "$RED Not a git folder$NC"
            fi

            cd ../ || exit
        done
        ;;

    "git-up")
        echo -e "$CYAN# Run git pull and force update to the local files (deleting changes) with the remote in the subfolders #$NC"

        IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
        for folder in $(find . -maxdepth 1 -type d | grep -v "^.$"| sort); do
            echo -e "\n$BLUE Folder: $GREEN$folder/$NC"
            cd "$folder/" || exit

            if [ -d ".git/" ]; then
                if ! git pull; then # $? != 0
                    echo -en "\n$CYAN Local files with changes. Force the update? (y)es or n(o):$NC "
                    read -r force_up

                    if [ "$force_up" == "y" ]; then
                        git fetch --all # Fetch all changes

                        git reset --hard origin/master # Reset the master

                        git pull # Pull/update
                    else
                        echo -e "$RED Repository not updated$NC"
                    fi

                fi
            else
                echo -e "$RED Not a git folder$NC"
            fi

            cd ../ || exit
        done
        ;;
    "file-equal" )
        echo -e "$CYAN# Look for equal files using md5sum in the current folder (and subfolders) #$NC"

        IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
        fileType=$2
        if [ "$fileType" == '' ]; then
            echo -e "$CYAN\nWant check all files or just a type of files?$NC"
            echo -en "${CYAN}Hit enter to all files or the type (e.g. txt or pdf):$NC "
            read -r fileType
        fi

        echo -e "$BLUE\n    Tip: use the option \"auto\" to automatic run the code (use default options)$NC"
        autoOnOff=$3

        echo -e "$CYAN\nWant check the files recursively (this folder and all his subfolders) or only this folder?$NC"
        echo -en "${CYAN}1 to recursively - 2 to only this folder (hit enter to all folders):$NC "
        if [ "$autoOnOff" != "auto" ]; then
            read -r allFolderOrNot
        else
            allFolderOrNot=1
        fi

        if [ "$allFolderOrNot" == 2 ]; then
            recursiveFolderValue="-maxdepth 1" # Set the max deep to 1, or just this folder
        else
            recursiveFolderValue=''
        fi

        echo -en "$GREEN\nRunning md5sum, can take a while. Please wait, checking "
        if [ "$fileType" == '' ]; then
            echo -en "all files...$NC"
            fileAndMd5=$(eval find . "$recursiveFolderValue" -type f -print0 | xargs -0 md5sum) # Get md5sum of the files
        else
            echo -en "the files with \"$fileType\" in the name...$NC"
            fileAndMd5Tmp=$(eval find . "$recursiveFolderValue" -type f | grep "$fileType")

            if [ "$fileAndMd5Tmp" == '' ]; then
                echo -e "\n\n${RED}Error: not found any file with \"$fileType\"!$NC\n"
                exit 1
            fi

            for file in $fileAndMd5Tmp; do
                fileAndMd5=$fileAndMd5"\n"$(md5sum "$file")
            done

            fileAndMd5=$(echo -e "$fileAndMd5") # "Create" the new lines
        fi
        fileAndMd5=$(echo -e "$fileAndMd5" | sed 's/.\///1') # Remove ./ from begin of files names

        fileAndMd5=$(echo "$fileAndMd5" | sort) # Sort by the md5sum

        md5Files=$(echo "$fileAndMd5" | cut -d " " -f1) # Get only the md5sum

        for value in $md5Files; do
            if [ "$valueBack" == "$value" ]; then # Look for all values that are equal
                equalFiles="$equalFiles$value|"
            fi
            valueBack=$value
        done

        equalFiles=${equalFiles::-1} # Remove the last | (the last character)

        if [ "$equalFiles" == '' ]; then
            echo -e "$GREEN\n\n### All files are different by md5sum! ###$NC"
        else
            echo -en "$BLUE\n\n### These file(s) are equal:$NC"
            filesEqual=$(echo "$fileAndMd5" | grep -E "$equalFiles") # Grep all files equal

            valueBack='' # Clean the value in valueBack
            for value in $filesEqual; do
                valueNow=$(echo "$value" | cut -d " " -f1)

                if [ "$valueNow" != "$valueBack" ]; then
                    echo # Add a new line between file different in the print on the terminal
                else
                    fileTmp=$(echo "$value" | cut -d "/" -f2-)
                    FilesToWork=$FilesToWork$(echo -e "\n$fileTmp")
                fi
                valueBack=$valueNow

                echo "$value"
            done

            filesDifferent=$(echo "$fileAndMd5" | grep -vE "$equalFiles") # Grep all files different
            if [ "$filesDifferent" != '' ]; then
                echo -e "$CYAN\nWant to print the file(s) that are different?$NC"
                echo -en "$CYAN(y)es - (n)o (hit enter to yes):$NC "
                if [ "$autoOnOff" != "auto" ]; then
                    read -r printDifferent
                else
                    printDifferent='y'
                fi

                if [ "$printDifferent" != 'n' ]; then
                    echo -e "$BLUE\n### These file(s) are different:$NC"
                    echo "$filesDifferent" | sort -k 2
                fi
            else
                echo -e "$BLUE\n### There is no unique file(s)! ###$NC"
            fi

            tmpFolder="equal_files_"$RANDOM

            echo -en "\n$RED### Files to be moved:$GREEN"
            echo "$FilesToWork" | sort -k 2

            echo -e "$RED\nWant to move (leave one) the equal file(s) to a TMP folder $GREEN($tmpFolder)?"
            echo -en "$RED(y)es - (n)o (hit enter to no):$NC "
            if [ "$autoOnOff" != "auto" ]; then
                read -r moveEqual
            else
                moveEqual='y'
            fi

            if [ "$moveEqual" == 'y' ]; then
                mkdir "$tmpFolder" 2> /dev/null

                FilesToWork_Name=$(echo "$FilesToWork" | cut -d ' ' -f3) # Only file name
                for value in $FilesToWork_Name; do
                    createFolder=$(echo "$value" | grep "/")

                    if [ "$createFolder" != '' ]; then
                        folderToCreate=$(echo "$value" | rev | cut -d "/" -f2- | rev)
                        folderToCreate=$tmpFolder"/"$folderToCreate

                        mkdir -p "$folderToCreate" 2> /dev/null
                    else
                        folderToCreate=$tmpFolder
                    fi

                    mv "$value" "$folderToCreate"
                done

                echo -e "$BLUE\n\tFiles moved to: $GREEN$PWD/$tmpFolder/$NC"
            else
                echo -e "$BLUE\n\tFiles not moved!"
            fi
        fi
        ;;
    "folder-equal" )
        echo -e "$CYAN# Look for equal files in \"folder2\" that are in \"folder1\" using md5sum #$NC"

        IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
        folder1=$2
        folder2=$3

        echo -e "\n${BLUE}folder1: $GREEN\"$folder1\"$NC\n${BLUE}folder2: $GREEN\"$folder2\"$NC"

        if [ "$folder1" == '' ] || [ "$folder2" == '' ]; then
            echo -e "$RED\nError: You need pass the folders to work: you pass: \"$folder1\" and \"$folder2\"$NC"
        elif [ ! -d "$folder1" ] || [ ! -d "$folder2" ]; then
            echo -e "$RED\nError: The folder \"$folder1\" or \"$folder2\" not exist$NC"
        else
            folder1=${folder1// /\\ } # Change the empty spaces " " in the name to "\ "
            folder2=${folder2// /\\ }

            fileType=$4
            if [ "$fileType" == '' ]; then
                echo -e "$CYAN\nWant check all files or just a type of files?$NC"
                echo -en "${CYAN}Hit enter to all files or the type (e.g., txt or pdf):$NC "
                read -r fileType
            fi

            echo -e "$BLUE\n    Tip: use the option \"auto\" to automatic run the code (use default options)$NC"
            if [ "$fileType" == "auto" ]; then # If there is no file type, but has parameter "auto"
                autoOnOff=$4
            else
                autoOnOff=$5
            fi

            echo -e "$CYAN\nWant check the files recursively (this source folders and all subfolders) or only in the source folders?$NC"
            echo -en "${CYAN}1 to recursively - 2 to only in source folder (hit enter to all folders):$NC "
            if [ "$autoOnOff" != "auto" ]; then
                read -r allFolderOrNot
            else
                allFolderOrNot=1
            fi

            if [ "$allFolderOrNot" == 2 ]; then
                recursiveFolderValue="-maxdepth 1" # Set the max deep to 1, or just this folder
            else
                recursiveFolderValue=''
            fi

            echo -en "$GREEN\nRunning md5sum, can take a while. Please wait, checking "
            if [ "$fileType" == '' ]; then
                echo -en "${BLUE}all files...$NC"
                fileAndMd5F1=$(eval find "$folder1" "$recursiveFolderValue" -type f -print0 | xargs -0 md5sum) # Get md5sum of the files
                fileAndMd5F2=$(eval find "$folder2" "$recursiveFolderValue" -type f -print0 | xargs -0 md5sum) # Get md5sum of the files
            else
                echo -en "${BLUE}the files with $GREEN\"$fileType\"$BLUE in the name...$NC"
                fileAndMd5TmpF1=$(eval find "$folder1" "$recursiveFolderValue" -type f | grep "$fileType")
                fileAndMd5TmpF2=$(eval find "$folder2" "$recursiveFolderValue" -type f | grep "$fileType")

                for file in $fileAndMd5TmpF1; do
                    fileAndMd5F1=$fileAndMd5F1"\n"$(md5sum "$file")
                done

                for file in $fileAndMd5TmpF2; do
                    fileAndMd5F2=$fileAndMd5F2"\n"$(md5sum "$file")
                done

                fileAndMd5F1=$(echo -e "$fileAndMd5F1") # "Create" the new lines
                fileAndMd5F2=$(echo -e "$fileAndMd5F2")
            fi

            fileAndMd5F1=$(echo "$fileAndMd5F1" | sort) # Sort by the md5sum
            fileAndMd5F2=$(echo "$fileAndMd5F2" | sort) # Sort by the md5sum

            fileAndMd5FAll=$(echo -e "$fileAndMd5F1\n$fileAndMd5F2" | sort)

            md5FilesF1=$(echo "$fileAndMd5F1" | cut -d " " -f1) # Get only de md5sum
            md5FilesF2=$(echo "$fileAndMd5F2" | cut -d " " -f1) # Get only de md5sum

            for valueF1 in $md5FilesF1; do
                for valueF2 in $md5FilesF2; do
                    if [ "$valueF1" == "$valueF2" ]; then # Look for all values equal
                        equalFiles="$equalFiles$valueF2|"
                    fi
                done
            done

            equalFiles=${equalFiles::-1} # Remove the last | (the last character)

            if [ "$equalFiles" == '' ]; then
                echo -e "$GREEN\n\n### All files are different by md5sum ###$NC\n"
            else
                echo -en "$BLUE\n\n### These file(s) in $GREEN\"$folder2\"$BLUE are equal in $GREEN\"$folder1\"$BLUE:$NC"
                filesEqual=$(echo "$fileAndMd5FAll" | grep -E "$equalFiles") # Grep all files equal

                valueBack='' # Clean the value in valueBack
                for value in $filesEqual; do
                    valueNow=$(echo "$value" | cut -d " " -f1)

                    if [ "$valueNow" != "$valueBack" ]; then
                        echo # Add a new line between file different in the print on the terminal
                    fi
                    valueBack=$valueNow

                    echo "$value"
                done

                filesEqual=$(echo "$fileAndMd5F2" | grep -E "$equalFiles") # Grep all files equal

                echo -e "$BLUE\n### File(s) equal summary (only the equal file(s) in $GREEN\"$folder2\"$BLUE):$NC\n$filesEqual"

                for value in $filesEqual; do
                    fileTmp=$(echo "$value" | cut -d " " -f3-) # Cut the second space from md5sum to end
                    FilesToWork=$FilesToWork$(echo -e "\n$fileTmp")

                done

                filesDifferent=$(echo -e "$fileAndMd5F1\n$fileAndMd5F2" | grep -vE "$equalFiles") # Grep all files different
                if [ "$filesDifferent" != '' ]; then
                    echo -e "$CYAN\nWant to print the file(s) that are different?$NC"
                    echo -en "$CYAN(y)es - (n)o (hit enter to yes):$NC "
                    if [ "$autoOnOff" != "auto" ]; then
                        read -r printDifferent
                    else
                        printDifferent='y'
                    fi

                    if [ "$printDifferent" != 'n' ]; then
                        echo -e "$BLUE\n### These file(s) are different:$NC"
                        echo "$filesDifferent" | sort -k 2
                    fi
                else
                    echo -e "$BLUE\n### There is no unique file(s) ###$NC"
                fi

                tmpFolder="equal_files_"$RANDOM

                echo -en "\n$RED### Files to be moved:$GREEN"
                echo "$FilesToWork" | sort -k 2

                echo -e "$RED\nWant to move (leave one) the equal file(s) to a TMP folder $GREEN($tmpFolder)?"
                echo -en "$RED(y)es - (n)o (hit enter to no):$NC "
                if [ "$autoOnOff" != "auto" ]; then
                    read -r moveEqual
                else
                    moveEqual='y'
                fi

                if [ "$moveEqual" == 'y' ]; then
                    mkdir "$tmpFolder" 2> /dev/null

                    for value in $FilesToWork; do
                        createFolder=$(echo "$value" | grep "/")

                        if [ "$createFolder" != '' ]; then
                            folderToCreate=$(echo "$value" | rev | cut -d "/" -f2- | rev)
                            folderToCreate=$tmpFolder"/"$folderToCreate

                            mkdir -p "$folderToCreate" 2> /dev/null
                        else
                            folderToCreate=$tmpFolder
                        fi

                        mv "$value" "$folderToCreate"
                    done

                    echo -e "$BLUE\n\tFiles moved to: $GREEN$PWD/$tmpFolder/$NC"
                else
                    echo -e "$BLUE\n\tFiles not moved!"
                fi
            fi
        fi
        ;;
     "kill" )
        echo -e "$CYAN# Search for program with pattern/name and (can) kill it #$NC"

        program_name=$2
        if [ "$program_name" == '' ]; then
            echo -en "\nInsert the program name: "
            read -r program_name
        fi

        list_process=$(ps aux | grep -i "$program_name" | grep -vE "grep|$0")
        if [ "$list_process" != '' ]; then

            echo -e "\n$BLUE List of process:$NC"
            echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
            echo "$list_process"

            PID=$(echo "$list_process" | awk '{print $2}')
            echo -e "\n$BLUE PID(s):\n$NC$PID"

            for process in $PID; do
                echo -e "\n$CYAN PID: $RED$process$NC"
                echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
                echo -e "$list_process" | grep "  $process "

                echo -en "$RED\nKill this process?\n(y)es - (n)o (hit enter to no or t no end function):$NC "
                read -r kill_process

                if [ "$kill_process" == 'y' ]; then
                    echo " + kill -9 $process"
                    kill -9 "$process"

                elif [ "$kill_process" == 't' ]; then
                    break
                fi
            done
        else
            echo -e "$RED\nError: Not found any process with \"$program_name\"."
        fi
        ;;
    "sub-extract" ) # Need ffmpeg
        echo -e "$CYAN# Extract subtitle from a video file #$NC"

        fileName=$2
        if [ "$fileName" != '' ]; then
            subtitleInfoGeneral=$(ffmpeg -i "$fileName" 2>&1 | grep "Stream.*Subtitle") # Grep information about subtitles in the file
            subtitleNumber=$(echo -e "$subtitleInfoGeneral" | cut -d":" -f2 | cut -d "(" -f1 | sed ':a;N;$!ba;s/\n/ /g') # Grep subtitles numbers
            subtitleInfo=$(echo "$subtitleInfoGeneral" | cut -d":" -f2 | tr "(" " " | cut -d ")" -f1) # Grep subtitles number and language

            if [ "$subtitleNumber" == '' ]; then # Empty if not found any subtitle in the file
                echo -e "$RED\nError: Not found any subtitle in the file: $GREEN\"$fileName\""
            else
                echo -e "$CYAN\nSubtitles available in the file $GREEN\"$fileName\"$CYAN:$GREEN\n$subtitleInfo"
                echo -en "$CYAN\nWhich one you want? (only valid numbers: $GREEN$subtitleNumber$CYAN): $NC"
                read -r subNumber

                if echo "$subNumber" | grep -q "[[:digit:]]"; then # Test if was insert only number
                    lastPart=$(echo "$subtitleInfo" | grep "^$subNumber ") # Grep the info (number language) about the subtitle wanted, if exists
                    if [ "$lastPart" != '' ]; then
                        echo -e "\nExtracting the subtitle \"$lastPart\" from the file \"$fileName\""
                        fileNameTmp=$(echo "$fileName" | rev | cut -d "." -f2- | rev)
                        echo -e "That will be save as \"$fileNameTmp-$lastPart.srt\"\n"

                        echo -e "${GREEN}Running:\nffmpeg -i \"$fileName\" -an -vn -map 0:$subNumber -c:s:0 srt \"${fileNameTmp}-${lastPart}.srt\"\n$NC"
                        ffmpeg -i "$fileName" -an -vn -map 0:"$subNumber" -c:s:0 srt "${fileNameTmp}-${lastPart}.srt"
                        echo -e "$CYAN\nSubtitle $GREEN\"$lastPart\"$CYAN from $GREEN\"$fileName\"$CYAN saved as $GREEN\"${fileNameTmp}-${lastPart}.srt\"$NC"
                    else
                        echo -e "$RED\nError: Not found the subtitle $GREEN\"$subNumber\"$RED in the file: $GREEN\"$fileName\"\n$CYAN one of: $GREEN$subtitleNumber$NC"
                    fi
                else
                    echo -e "$RED\nError: The subtitle number must be a number$NC"
                fi
            fi
        else
            echo -e "$RED\nError: Need pass the file name$NC"
        fi
        ;;
     "audio-extract" ) # Need ffmpeg
        echo -e "$CYAN# Extract audio from a video file #$NC"

        fileName=$2
        if [ "$fileName" != '' ]; then
            audioInfoGeneral=$(ffmpeg -i "$fileName" 2>&1 | grep "Stream.*Audio") # Grep information about audio in the file
            audioNumber=$(echo -e "$audioInfoGeneral" | cut -d":" -f2 | cut -d "(" -f1 | sed ':a;N;$!ba;s/\n/ /g') # Grep audio numbers
            audioInfo=$(echo "$audioInfoGeneral" | cut -d":" -f2 | tr "(" " " | cut -d ")" -f1) # Grep audio number and language

            if [ "$audioNumber" == '' ]; then # Empty if not found any audio in the file
                echo -e "$RED\nError: Not found any audio in the file: $GREEN\"$fileName\""
            else
                echo -e "$CYAN\nAudio available in the file $GREEN\"$fileName\"$CYAN:$GREEN\n$audioInfo"
                echo -en "$CYAN\nWhich one you want? (only valid numbers: $GREEN$audioNumber$CYAN): $NC"
                read -r audioNumber

                if echo "$audioNumber" | grep -q "[[:digit:]]"; then # Test if was insert only number
                    lastPart=$(echo "$audioInfo" | grep "^$audioNumber ") # Grep the info (number language) about the audio wanted, if exists
                    if [ "$lastPart" != '' ]; then
                        echo -e "\nExtracting the audio \"$lastPart\" from the file \"$fileName\""
                        fileNameTmp=$(echo "$fileName" | rev | cut -d "." -f2- | rev)
                        echo -e "That will be save as \"$fileNameTmp-$lastPart.mp3\"\n"

                        echo -e "${GREEN}Running:\nffmpeg -i \"$fileName\" -map 0:a:$audioNumber \"${fileNameTmp}-${lastPart}.mp3\"\n$NC"
                        ffmpeg -i "$fileName" -map 0:a:"$audioNumber" "${fileNameTmp}-${lastPart}.mp3"

                        echo -e "$CYAN\nAudio $GREEN\"$lastPart\"$CYAN from $GREEN\"$fileName\"$CYAN saved as $GREEN\"${fileNameTmp}-${lastPart}.srt\"$NC"
                    else
                        echo -e "$RED\nError: Not found the audio $GREEN\"$audioNumber\"$RED in the file: $GREEN\"$fileName\"\n$CYAN one of: $GREEN$audioNumber$NC"
                    fi
                else
                    echo -e "$RED\nError: The audio number must be a number$NC"
                fi
            fi
        else
            echo -e "$RED\nError: Need pass the file name$NC"
        fi
        ;;
    "mem-use" )
        echo -e "$CYAN# Get the all (shared and specific) use of memory RAM from one process/pattern #$NC"
        if [ "$2" == '' ]; then
            echo -en "\nInsert the pattern (process name) to search: "
            read -r process_pattern
        else
            process_pattern=$2
        fi

        if  [ "$process_pattern" != '' ]; then
            process_list=$(ps aux)
            process_pattern_list=$(echo "$process_list" | grep -E "USER|$process_pattern" | grep -v -E "$0|grep")
            mem_percentage=$(echo "$process_pattern_list" | grep -v "USER" | awk '{print $4}')

            if [ "$mem_percentage" == '' ]; then
                echo -e "$RED\nError: Not found any process with the pattern $BLUE\"$process_pattern\"$RED. Try with another."
            else
                mem_percentage_sum=0
                for mem_now in $mem_percentage; do
                    mem_percentage_sum=$(echo "scale=2; $mem_percentage_sum+$mem_now" | bc)
                done

                total_mem=$(free -m | head -n 2 | tail -n 1 | awk '{print $2}')
                use_mem=$(echo "($total_mem*$mem_percentage_sum)/100" | bc)

                if [ "$(echo "$mem_percentage_sum < 1" | bc -l)" == 1 ]; then
                    mem_percentage_sum="0$mem_percentage_sum"
                fi

                echo -en "\nThe process $BLUE\"$process_pattern\"$NC is using: $RED$use_mem$NC MiB"
                echo -e " or $RED$mem_percentage_sum$NC % of $GREEN$total_mem MiB$NC\n"
                echo -e "$process_pattern_list\n"
            fi
        else
            echo -e "$RED\nError: You need insert some pattern/process name to search, e.g., $0 mem-use opera$NC"
        fi
        ;;
    "s-pkg-f" )
        echo -e "$CYAN# Search in the installed package folder (/var/log/packages/) for one pattern (-f of fast) #$NC"
        if [ "$2" == '' ]; then
            echo -en "$CYAN\nPackage file or pattern to search:$NC "
            read -r filePackage
        else
            filePackage=$2
        fi

        echo -en "$CYAN\nSearching, please wait...$NC\n"
        grep -rn "$filePackage" /var/log/packages/* --color=auto
        ;;
    "s-pkg-s" )
        echo -e "$CYAN# Search in the installed package folder (/var/log/packages/) for one pattern (-r of summary files) #$NC"
        if [ "$2" == '' ]; then
            echo -en "$CYAN\nPackage file or pattern to search:$NC "
            read -r filePackage
        else
            filePackage=$2
        fi

        echo -en "$CYAN\nSearching, please wait...$NC"

        tmpFileName=$(mktemp) # Create a tmp file
        tmpFileFull=$(mktemp)

        for fileInTheFolder in /var/log/packages/*; do
            if grep -q "$filePackage" < "$fileInTheFolder"; then # Grep the "filePackage" from the file in /var/log/packages
                grep "PACKAGE NAME" < "$fileInTheFolder" >> "$tmpFileName" # Grep the package name from the has the "filePackage"
                cat "$fileInTheFolder" >> "$tmpFileFull" # Print all info about the package
                echo >> "$tmpFileFull" # Insert one new line
            fi
        done

        sizeResultFile=$(du "$tmpFileName" | cut -f1)

        if [ "$sizeResultFile" != 0 ]; then
            echo -e "\n\nResults saved in \"$tmpFileName\" and \"$tmpFileFull\" tmp files\n"

            echo -en "Open this files with kwrite or print them in the terminal?\n(k)write - (t)erminal: "
            read -r openProgram

            if [ "$openProgram" == 'k' ]; then
                kwrite "$tmpFileName"
                kwrite "$tmpFileFull"
            else
                echo -e "\nPackage(s) with '$filePackage':\n"
                cat "$tmpFileName"

                echo -en "\nPrint this package(s) in terminal?\n(y)es - (p)artial, only the matches - (n)o: "
                read -r continuePrint
                echo
                if [ "$continuePrint" == 'y' ]; then
                    cat "$tmpFileFull"
                elif [ "$continuePrint" == 'p' ]; then
                    grep "$filePackage" < "$tmpFileFull"
                fi
            fi
        else
            echo -e "\n\n    No result was found"
        fi

        echo -e "\nDeleting the log files used in this script\n"
        rm "$tmpFileName" "$tmpFileFull"
        ;;
    "work-fbi" )
        echo -e "$CYAN# Write <zero>/<random> value in one ISO file to wipe trace of old deleted file #$NC"
        echo -e "\nWarning: Depending on how big is the amount of free space, this can take a long time"

        freeSpace=$(df . | awk '/[0-9]%/{print $(NF-2)}') # Free space local/pwd folder
        freeSpaceMiB=$(echo "scale=2; $freeSpace/1024" | bc) # Free space in MiB
        freeSpaceGiB=$(echo "scale=2; $freeSpace/(1024*1024)" | bc) # Free space in GiB
        timeAvgMin=$(echo "($freeSpaceMiB/30)/60" | bc)

        echo -e "\nThere are$GREEN $freeSpaceGiB$CYAN GiB$NC ($GREEN$freeSpaceMiB$CYAN MiB$NC) free in this folder/disk/partition (that will be write)"
        echo -e "Considering$CYAN 30 MiB/s$NC in speed of write, will take$GREEN $timeAvgMin min$NC to finish this job"
        echo -en "\nWant continue? (y)es - (n)o: "
        read -r continueDd

        if [ "$continueDd" == 'y' ]; then
            fileName="work-fbi_" # Create a ISO file with a random part name
            fileName+=$(date +%s | md5sum | head -c 10)
            fileName+=".iso"

            echo "You can use <zero> or <random> value"
            echo "Using <random> value is better to overwrite your deleted file"
            echo "Otherwise, is slower (almost 10 times) then use <zero> value"
            echo "Long story short, use <zero> if you has not deleted pretty good sensitive data"
            echo -en "\nUse random or zero value?\n(r)andom - (z)ero: "
            read -r continueRandomOrZero

            startAtSeconds=$(date +%s)

            if [ "$continueRandomOrZero" == 'r' ]; then
                typeWriteDd="random"
            else
                typeWriteDd="zero"
            fi
            echo -en "\nWriting <$typeWriteDd> value in the \"$fileName\" tmp file. Please wait...\n\n"

            if [ "$continueRandomOrZero" == 'r' ]; then
                dd if=/dev/urandom of="$fileName" iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <random> value to wipe the data
            else
                dd if=/dev/zero of="$fileName" iflag=nocache oflag=direct bs=1M conv=notrunc status=progress # Write <zero> value to wipe the data
            fi

            endsAtSeconds=$(date +%s)
            timeTakeMin=$(echo "scale=2; ($endsAtSeconds - $startAtSeconds)/60" | bc)

            echo -e "\nFinished to write the file - this take $timeTakeMin min"

            rm "$fileName" # Delete the <big> file generated
            echo -e "\nThe \"$fileName\" tmp file was deleted and the end of the job"
        fi
        ;;
    "ip" )
        echo -e "$CYAN# Get your IP #$NC"
        localIP=$(/sbin/ifconfig | grep broadcast | awk '{print $2}')
        echo -e "$CYAN\nLocal IP:$GREEN $localIP$CYAN"

        externalIP=$(wget -qO - icanhazip.com)
        echo -e "External IP:$GREEN $externalIP$NC"
        ;;
    "cpu-max" )
        echo -e "$CYAN# Show the 10 process with more CPU use #$NC\n"
        ps axo pid,%cpu,%mem,cmd --sort=-pcpu | head -n 11 | cut -d "-" -f1
        ;;
    "mem-max" )
        echo -e "$CYAN# Show the 10 process with more memory RAM use #$NC\n"
        ps axo pid,%cpu,%mem,rss,cmd --sort -rss | head -n 11 | cut -d "-" -f1 | \
        awk '{
                for (x=1; x<=NF; x++) {
                    if (x == 1) {
                        printf("%-8s ", $x)
                    }else if (x == 2 || x == 3) {
                        printf("%-6s ", $x)
                    }else if (x == 4) {
                        if ($x == "RSS") {
                            printf("%8s     ", $x)
                        } else {
                            printf("%8.2f MiB ", $x/1024)
                        }
                    } else {
                        printf("%-8s ", $x)
                    }
                }
                print("")
            }'
        ;;
    "day-s-i" )
        echo -e "$CYAN# The day the system was installed #$NC"

        dayInstall() {
            # tune2fs -l /dev/sda1 or dumpe2fs /dev/sda1
            partitionRoot=$(mount | grep "on / t" | cut -d ' ' -f1)
            dayCreated=$(dumpe2fs "$partitionRoot" 2> /dev/null | grep "Filesystem created" | cut -d ' ' -f9-)
            echo -e "$CYAN\nThe system was installed in:$GREEN $dayCreated$NC"
            echo -e "Obs.: In some of the cases is just the day partition was created"
        }

        export -f dayInstall
        export CYAN NC GREEN RED
        su root -c 'dayInstall'
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

                echo -e "\nPrint \"$inputFile\" line $lineStart to $lineEnd\n"
                lineStartTmp=$((lineEnd-lineStart))
                ((lineStartTmp++))

                cat -n "$inputFile" | head -n "$lineEnd" | tail -n "$lineStartTmp"
            else
                echo -e "$RED\nError: lineStart and lineEnd must be number$NC"
            fi
        fi
        ;;
    "screenshot" )
        echo -e "$CYAN# Screenshot from display :0 #$NC"

        echo -en "$CYAN\nDelay before the screenshot (in seconds):$NC "
        read -r secondsBeforeScrenshot

        if echo "$secondsBeforeScrenshot" | grep -q "[[:digit:]]"; then
            sleep "$secondsBeforeScrenshot"
        fi

        dateNow=$(date +%s)
        import -window root -display :0 "screenshot_${dateNow}.jpg"

        echo -e "\nScreenshot \"screenshot_${dateNow}.jpg\"\nsaved in the folder \"$(pwd)/\""
        ;;
    "folder-diff" )
        echo -e "$CYAN# Show the difference between two folders and (can) make them equal (with rsync) #$NC"
        if [ $# -lt 3 ]; then
            echo -e "$RED\nError: Need two parameters, $0 folder-diff 'pathSource' 'pathDestination'$NC"
        else
            pathSource=$2
            pathDestination=$3

            continueOrNot='y'
            if [ "${pathSource:0-1}" != '/' ]; then # Check if last caracter of $pathSource is /
                echo -e "\n$GREEN    ## An Important Note ##$BLUE\n"
                echo -e "The trailing slash (/) at the end of the first argument (source folder)"
                echo -e "For example: \"rsync -a folder1/ folder2\" is necessary to mean \"the contents of folder1\""
                echo -e "The alternative (without the trailing slash) would place folder1 (including the folder) within folder2"
                echo -e "This would create a hierarchy that looks like: folder2/folder1/[files]"
                echo -e "\n$CYAN## Please double-check your arguments before continue ##$NC"

                echo -en "$CYAN\nThis is the correct desire?\n(y)es - (n)o (yes to continue or no to exit):$NC "
                read -r continueOrNot
            fi

            if [ "$continueOrNot" == 'y' ]; then # Check if wants to continue after '/' test
                echo -e "$CYAN\nSource folder:$GREEN $pathSource$CYAN"
                echo -e "Destination folder:$GREEN $pathDestination$NC"

                echo -en "$CYAN\nWant continue and use these source and destination folders?\n(y)es - (n)o:$NC "
                read -r continueRsync
            else
                continueRsync='n'
            fi


            if [ "$continueRsync" == 'y' ]; then
                if [ -e "$pathSource" ]; then # Test if "source" exists
                    if [ -e "$pathDestination" ]; then # Test if "destination" exists

                        echo -en "$CYAN\nWant to use checksum to check/compare the files?:$NC "
                        echo -en "$CYAN\nMuch more slower, but more security, especially to USB flash drive.\n(y)es - (n)o:$NC "
                        read -r useChecksum

                        echo -e "\n\t$RED#-----------------------------------------------------------------------------#"
                        echo -en "$CYAN$GREEN\t 1$CYAN Just see differences or$GREEN 2$CYAN Make them equal now? $GREEN(enter to see differences):$NC "
                        read -r syncNowOrNow

                        if [ "$useChecksum" == 'y' ]; then
                            rsyncCommand="rsync -achv --delete --progress" # check based on checksum, not mod-time & size
                        else
                            rsyncCommand="rsync -ahv --delete --progress" # check based on mod-time & size
                        fi

                        # -a archive mode, equivalent to -rlptgoD - recursion and want to preserve almost everything
                        # -h output numbers in a human-readable format; -v increase verbosity
                        # --delete delete extraneous files from destination folders
                        # -n perform a trial run with no changes made; -i output a change-summary for all updates

                        if [ "$syncNowOrNow" == "2" ]; then
                            echo -e "$CYAN\nMaking the files equal.$NC Please wait..."
                            $rsyncCommand "$pathSource" "$pathDestination"
                        else
                            echo -en "$CYAN\nPlease wait until all files are compared...$NC"
                            folderChangesFull=$($rsyncCommand -in "$pathSource" "$pathDestination")

                            folderChangesClean=$(echo -e "$folderChangesFull" | grep -E "^>|^*deleting|^c|/$")

                            echo # just a new blank line
                            foldersNew=$(echo -e "$folderChangesClean" | grep "^c" | awk '{print substr($0, index($0,$2))}') # "^c" - new folders
                            if [ "$foldersNew" != '' ]; then
                                echo -e "$BLUE\nFolders new:$NC"
                                echo "$foldersNew" | sort
                            fi

                            filesDelete=$(echo -e "$folderChangesClean" | grep "^*deleting" | awk '{print substr($0, index($0,$2))}') # "^*deleting" - files deleted
                            if [ "$filesDelete" != '' ]; then
                                echo -e "$BLUE\nFiles to be deleted:$NC"
                                echo "$filesDelete" | sort
                            fi

                            filesDifferent=$(echo -e "$folderChangesClean" | grep -E "^>fc|^>f.st|^>f..t" | awk '{print substr($0, index($0,$2))}') # "^>fc|^>f.st|^>f..t" - all files changed
                            if [ "$filesDifferent" != '' ]; then
                                echo -e "$BLUE\nFiles different:$NC"
                                echo "$filesDifferent" | sort
                            fi

                            filesNew=$(echo -e "$folderChangesClean" | grep "^>f++++"| awk '{print substr($0, index($0,$2))}') # "^>f++++" - New files
                            if [ "$filesNew" != '' ]; then
                                echo -e "$BLUE\nNew files:$NC"
                                echo "$filesNew" | sort
                            fi

                            if [ "$foldersNew" == '' ] && [ "$filesDelete" == '' ] && [ "$filesDifferent" == '' ] && [ "$filesNew" == '' ]; then
                                echo -e "$GREEN\nSource folder ($pathSource) and the destination folder ($pathDestination) don't have any difference$NC"
                            else
                                echo -en "$CYAN\nShow full rsync change-summary?\n(y)es - (n)o:$NC "
                                read -r showRsyncS
                                if [ "$showRsyncS" == 'y' ]; then
                                    echo -e "\n$folderChangesFull"
                                fi

                                echo -en "$CYAN\nShow clean rsync change-summary?\n(y)es - (n)o:$NC "
                                read -r showRsyncS
                                if [ "$showRsyncS" == 'y' ]; then
                                    echo -e "\n$folderChangesClean"
                                fi

                                echo -e "\n\t$RED#------------------------------#"
                                echo -en "\t Make this change on the disk?\n\t (y)es - (n)o:$NC "
                                read -r continueWriteDisk
                                if [ "$continueWriteDisk" == 'y' ]; then
                                    echo -e "$CYAN\nChanges are writing in $pathDestination.$NC Please wait..."
                                    $rsyncCommand "$pathSource" "$pathDestination"
                                else
                                    echo -e "$CYAN\n    No changes has made to disk$NC"
                                fi
                            fi
                        fi
                    else
                        echo -e "$RED\nError: The destination ($pathDestination) don't exist$NC"
                    fi
                else
                    echo -e "$RED\nError: The source ($pathSource) don't exist$NC"
                fi
            else
                echo -e "$CYAN\n    Just existing. No changes has made to disk$NC"
            fi
        fi
        ;;
    "search-pwd" )
        echo -e "$CYAN# Search in this folder (recursive) for a pattern #$NC"
        if [ "$2" == '' ]; then
            echo -en "$CYAN\nPattern to search: $NC"
            read -r patternSearch
        else
            patternSearch=$2
        fi

        echo -e "$CYAN\nSearching, please wait...$NC\n\n"
        grep -rn "$patternSearch" --color=auto
        # -r recursive, -n print line number with output lines
        ;;
    "ping-test" | "mtr-test" )
        echo -e "$CYAN# Running $optionInput to a domain (default is google.com) #$NC"

        domainToWork=$2
        if [ "$domainToWork" == '' ]; then
            domainToWork="google.com"
        fi

        if [ "$optionInput" == "ping-test" ]; then
            commandToRun="ping -c 3 $domainToWork"
        else
            commandToRun="su root -c 'mtr $domainToWork'"
        fi

        echo -en "$CYAN\nRunning: $commandToRun$NC\n"
        eval "$commandToRun"
        ;;
    "mem-info" )
        echo -e "$CYAN# Show memory and swap percentage of use #$NC"
        memTotal=$(free -m | grep Mem | awk '{print $2}') # Get total of memory RAM
        memUsed=$(free -m | grep Mem | awk '{print $3}') # Get total of used memory RAM
        memUsedPercentage=$(echo "scale=0; ($memUsed*100)/$memTotal" | bc) # Get the percentage "used/total", |valueI*100/valueF|
        echo -e "$CYAN\nMemory used: ~ $GREEN$memUsedPercentage % ($memUsed of $memTotal MiB)$CYAN"

        testSwap=$(free -m | grep Swap | awk '{print $2}') # Test if has Swap configured
        if [ "$testSwap" -eq 0 ]; then
            echo -e "Swap is not configured in this computer$NC"
        else
            swapTotal=$(free -m | grep Swap | awk '{print $2}')
            swapUsed=$(free -m | grep Swap | awk '{print $3}')
            swapUsedPercentage=$(echo "scale=0; ($swapUsed*100)/$swapTotal" | bc) # |valueI*100/valueF|
            echo -e "Swap used: ~ $GREEN$swapUsedPercentage % ($swapUsed of $swapTotal MiB)$NC"
        fi
        ;;
    "texlive-up" )
        echo -e "$CYAN# Update the texlive packages #$NC\n"
        su - root -c "tlmgr update --self
        tlmgr update --all"
        ;;
    "brigh-1" )
        echo -e "$CYAN# Set brightness percentage value (accept % value, up and down) #$NC"
        if [ "$#" -eq 1 ]; then
            brightnessValueOriginal=1
        else
            brightnessValueOriginal=$2
        fi

        if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
            if [ "$brightnessValueOriginal" -gt 100 ]; then # Test max percentage
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
            brightnessMax=$(cat "$pathFile"/max_brightness) # Get max_brightness
            brightnessPercentage=$(echo "scale=3; $brightnessMax/100" | bc) # Get the percentage of 1% from max_brightness

            actualBrightness=$(cat "$pathFile"/actual_brightness) # Get actual_brightness
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
                if [ "$brightnessValueOriginal" -gt 99 ]; then # If Input value brightness more than 99%, set max_brightness to brightness final
                    brightnessValueFinal=$brightnessMax
                fi
            fi

            echo -e "$CYAN\nFile to set brightness: $pathFile/brightness"
            echo "Actual brightness: $actualBrightness %"
            echo "Input value brightness: $brightnessValueOriginal"
            echo "Final percentage brightness value: $brightnessValue"
            echo -e "Final set brightness value: $brightnessValueFinal$NC\n"

            # Only for test
            #echo "Max brightness value: $brightnessMax"
            #echo "Percentage value to 1% of brightness: $brightnessPercentage"

            # Set the final percentage brightness
            su - root -c "echo $brightnessValueFinal > $pathFile/brightness"
        fi
        ;;
    "brigh-2" )
        echo -e "$CYAN# Set brightness percentage value with xbacklight (accept % value, up, down, up % and down %) #$NC"
        if [ "$#" -eq 1 ]; then # Option without value set brightness in 1%
            xbacklight -set 1
        elif [ "$#" -eq 2 ]; then # Option to one value of input to set
            if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
                brightnessValue=$2
                if [ "$brightnessValue" -gt 100 ]; then # Test max percentage
                    brightnessValue=100
                fi
                xbacklight -set "$brightnessValue"
            else
                if [ "$2" == "up" ];then
                    xbacklight -inc 1
                elif [ "$2" == "down" ];then
                    xbacklight -dec 1
                else
                    echo -e "$RED\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            fi
        else #elif [ "$#" -eq 3 ]; then # Option to two value of input to set
            if echo "$3" | grep -q "[[:digit:]]"; then # Test if has only digit
                if [ "$2" == "up" ];then
                    xbacklight -inc "$3"
                elif [ "$2" == "down" ];then
                    xbacklight -dec "$3"
                else
                    echo -e "$RED\nError: Not recognized the value '$2' as valid option (accept % value, up, down, up % and down %)$NC"
                fi
            else
                echo -e "$RED\nError: Value must be only digit (e.g. $0 brigh-2 up 10 to set brightness up in 10 %)$NC"
            fi
        fi

        brighCurrentValue=$(xbacklight -get | cut -d '.' -f1)
        notify-send "Brightness percentage change" "Final value: $brighCurrentValue %" -i "high-brightness"
        ;;
    "pkg-count" )
        echo -e "$CYAN# Count of packages that are installed your Slackware #$NC"
        countPackages=$(find /var/log/packages/ -type f | wc -l)
        echo -e "$CYAN\nThere are $GREEN$countPackages$CYAN packages installed$NC"
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

        echo -e "$CYAN# List the last package(s) $functionWord (accept 'n', where 'n' is a number of packages, the default is 10) #$NC\n"

        if [ "$#" -eq 1 ]; then
            numberPackages=10
        else
            if echo "$2" | grep -q "[[:digit:]]"; then # Test if has only digit
                numberPackages=$2
            else
                numberPackages=10
            fi
        fi

        commandPart1='ls -ltcG '"$workFolder"' | grep -v "total [[:digit:]]"'
        commandPart3=' | head -n '"$numberPackages"''

        commandFinal=$commandPart1$commandPart2$commandPart3
        echo -e "$CYAN\nRunning: $commandFinal$NC\n"
        eval "$commandFinal"
        ;;
    "pdf-r" ) # Need Ghostscript
        echo -e "$CYAN# Reduce a PDF file #$NC"
        if [ "$#" -eq 1 ]; then
            echo -e "$RED\nError: Use $0 pdf-r file.pdf$NC"
        else # Convert the file
            filePdfInput=$2

            annotationsUse=$4
            if ! echo "$annotationsUse" | grep -Eq "y|n"; then
                echo -en "\n${CYAN}Keep link annotations? (y)es - (n)o (hit enter to yes):$NC "
                read -r annotationsUse
            fi

            echo -en "$GREEN\nWill "
            if [ "$annotationsUse" == 'n' ]; then
                printedUse=''
                echo -en "${RED}remove"
            else
                printedUse="-dPrinted=false"
                annotationsUse='y'
                echo -en "${BLUE}keep"
            fi
            echo -e "$GREEN link annotations$NC"

            if [ -e "$filePdfInput" ]; then
                filePdfOutput=${filePdfInput::-4}

                fileChangeOption=$3
                if ! echo "$fileChangeOption" | grep -q "[[:digit:]]"; then
                    echo -en "\nFile change options:\n1 - Small size\n2 - Better quality\n3 - Minimal changes\n4 - All 3 above\nWhich option you want? (hit enter to insert 4): "
                    read -r fileChangeOption
                fi

                if [ "$fileChangeOption" == 1 ]; then
                    sizeQuality="ebook"
                elif [ "$fileChangeOption" == 2 ]; then
                    sizeQuality="screen"
                elif [ "$fileChangeOption" != 3 ]; then
                    fileChangeOption=4
                fi

                if [ "$fileChangeOption" != 4 ]; then
                    fileNamePart="_r${fileChangeOption}l${annotationsUse}.pdf" # r (reduce), l (link)

                    echo -e "$CYAN\nRunning: $0 $1 $filePdfInput $fileChangeOption$NC\n"
                    if [ "$fileChangeOption" == 3 ]; then
                        gs -sDEVICE=pdfwrite -dNOPAUSE $printedUse -dBATCH -sOutputFile="$filePdfOutput$fileNamePart" "$filePdfInput"
                    else
                        gs -sDEVICE=pdfwrite $printedUse -dCompatibilityLevel=1.4 -dPDFSETTINGS=/"$sizeQuality" -dNOPAUSE -dBATCH -sOutputFile="$filePdfOutput$fileNamePart" "$filePdfInput"
                    fi

                    echo -e "\nThe output PDF: \"$filePdfOutput$fileNamePart\" was saved"
                else
                    echo
                    $0 "$colorPrint" notPrintHeader "$1" "$filePdfInput" 1 "$annotationsUse"
                    echo
                    $0 "$colorPrint" notPrintHeader "$1" "$filePdfInput" 2 "$annotationsUse"
                    echo
                    $0 "$colorPrint" notPrintHeader "$1" "$filePdfInput" 3 "$annotationsUse"
                fi
            else
                echo -e "$RED\nError: The file \"$filePdfInput\" not exists$NC"
            fi
        fi
        ;;
    "swap-clean" )
        echo -e "$CYAN# Clean up the Swap Memory #$NC"
        testSwap=$(free -m | grep Swap | awk '{print $2}') # Test if has Swap configured
        if [ "$testSwap" -eq 0 ]; then
            echo -e "\nSwap is not configured in this computer"
        else
            swapTotal=$(free -m | grep Swap | awk '{print $2}')
            swapUsed=$(free -m | grep Swap | awk '{print $3}')
            swapUsedPercentage=$(echo "scale=0; ($swapUsed*100)/$swapTotal" | bc) # |valueI*100/valueF|

            echo -e "$CYAN\nSwap used: ~ $GREEN$swapUsedPercentage % ($swapUsed of $swapTotal MiB)$NC"

            if [ "$swapUsed" -eq 0 ]; then
                echo -e "$CYAN\nSwap is already clean$NC"
            else
                if [ "$2" == '' ]; then
                    echo -en "$CYAN\nTry clean the Swap? \n(y)es - (n)o (hit enter to yes):$NC "
                    read -r cleanSwap
                else
                    cleanSwap='y'
                fi

                if [ "$cleanSwap" != 'n' ]; then
                    su - root -c 'echo -e "\nCleaning swap. Please wait..."
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
                echo -en "$CYAN\nUse blacklist?\n(y)es - (n)o (hit enter to yes):$NC "
                read -r USEBL
            fi

            echo -en "$CYAN\nUsing blacklist: "
            if [ "$USEBL" == 'n' ]; then # Not using blacklist
                echo -e "${GREEN}No$NC"
                USEBL=0
            else # Using blacklist
                echo -e "${GREEN}Yes$NC"
                USEBL=1
            fi

            if [ "$installNew" == '' ]; then
                echo -en "$CYAN\nRun \"slackpkg install-new\" for safe profuse?\n(y)es - (n)o (hit enter to yes):$NC "
                read -r installNew
            fi

            slackpkg update -batch=on -default_answer=y

            echo -en "$CYAN\nPress enter to continue.$NC"
            read -r _

            if [ "$installNew" != 'n' ]; then
                yes '' | head -n 55
                slackpkg install-new
            fi

            yes '' | head -n 55
            USEBL=$USEBL slackpkg upgrade-all
        }

        USEBL=$2
        installNew=$3
        export -f slackwareUpdate
        export CYAN NC GREEN RED

        su root -c "slackwareUpdate $USEBL $installNew" # In this case without the hyphen (su - root -c 'command') to no change the environment variables
        ;;
    "up-db" )
        echo -e "$CYAN# Update the database for the 'locate' #$NC"
        su - root -c "updatedb" # Update database
        echo -e "$CYAN\nDatabase updated$NC"
        ;;
    "pkg-i" | "pkg-u" | "pkg-r" )
        folderWork=$2
        if [ "$folderWork" == '' ]; then
            echo -e "$RED\nError: You need pass the folder to work"
        else
            echo -e "\n$CYAN Folder to work with: $folderWork$NC\n"
            if [ "$optionInput" = "pkg-i" ]; then
                functionWord="Install"
                commandToRun="upgradepkg --install-new"
            elif [ "$optionInput" = "pkg-u" ]; then
                functionWord="Upgrade"
                commandToRun="upgradepkg"
            elif [ "$optionInput" = "pkg-r" ]; then
                functionWord="Remove"
                commandToRun="removepkg"
            fi
            echo -e "$CYAN# $functionWord packge(s) in a folder (and subfolders) in the Slackware #$NC"

            updateInstallpkg () {
                echo -e "$CYAN\nWant check work recursively (this folder and all his subfolders) or only this folder?$NC"
                echo -en "$CYAN 1 to recursively - 2 to only this folder (hit enter to only this folder):$NC "
                read -r allFolderOrNot

                if [ "$allFolderOrNot" == 1 ]; then
                    recursiveFolderValue=''
                else
                    recursiveFolderValue="-maxdepth 1" # Set the max deep to 1, or just this folder
                fi

                packagesToUpdate=$(eval find "$folderWork" "$recursiveFolderValue" -type f | grep -E ".txz$|.tgz$") # Get the packages
                if [ "$packagesToUpdate" == '' ]; then
                    echo -e "$RED\nNot found any package valid (extension .tgz or txz)$NC"
                else
                    echo -en "$CYAN\nPackages to $functionWord:\n\n$NC$packagesToUpdate\n"

                    echo -en "$CYAN\nWant to continue? (y)es or (n)o:$NC "
                    read -r continueOrNot

                    if [ "$continueOrNot" == "y" ]; then
                        kernelMd5sum=$(md5sum /boot/vmlinuz 2>/dev/null)

                        for value in $packagesToUpdate; do
                            eval "$commandToRun $value"
                        done

                        NewkernelMd5sum=$(md5sum /boot/vmlinuz 2>/dev/null)
                        if [ "$kernelMd5sum" != "$NewkernelMd5sum" ]; then
                            if [ -x /sbin/lilo ]; then
                                echo -e "\nKernel image was updated. It is highly recommend you run: lilo"
                                echo -n "Want to run lilo now? (y)es or (n)o: "
                                read -r runLilo

                                if [ "$runLilo" != "n" ]; then
                                    /sbin/lilo
                                fi
                            else
                                echo -e "\nKernel image was updated and lilo is not found on the system."
                                echo "Adjust the boot manager (like GRUB) to boot appropriate kernel."
                            fi
                        fi
                    else
                        echo -e "$CYAN\nJust exiting.$NC"
                    fi
                fi
            }

            export -f updateInstallpkg
            export functionWord commandToRun CYAN NC GREEN RED folderWork

            if [ "$(whoami)" != "root" ]; then
                echo -e "$CYAN\nInsert the root Password to continue$NC"
            fi

            su root -c 'updateInstallpkg' # In this case without the hyphen (su - root -c 'command') to no change the environment variables
        fi
        ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        echo -e "$CYAN# Show the weather forecast (you can pass the name of the city as parameter) #$NC\n"
        cityName=${*:2} # Get the second parameter to the end

        if [ "$cityName" == '' ]; then
            cityName="Rio Paranaiba"
        fi

        wget -qO - "wttr.in/$cityName" # Get the weather information
        echo
        curl "v2.wttr.in/$cityName"
        ;;
    "shred" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        echo -e "$CYAN# shred files in local folder (and subfolders) #$NC"
        OLD_IFS=$IFS
        folder_or_file=$2

        if [ "$folder_or_file" == '' ]; then
            echo -e "\n$BLUE Pass -f (or f) to work with files\n Pass -d (or d) to work with directory$NC"
            echo -e "\n$BLUE Examples:\n$CYAN$(basename "$0") shred -f file.txt\n$(basename "$0") shred -d dir/$N"
        elif [ "$folder_or_file" == 'f' ] || [ "$folder_or_file" == '-f' ]; then # to shred files
            IFS='|'
            # $# - Count of parameters
            # $@ - expanded as "$1" "$2" "$3" ... "$n"
            # $* - expanded as "$1y$2y$3y...$n", where y is the value of IFS variable i.e. "$*" is one long string and $IFS act as an separator or token delimiters.
            #echo -e "\$@: $@\n\$*: $*"
            fileWork=${*:3} # Get all files passed as parameter after third (0 script name, 1 shred, 2 f)

            if [ "$fileWork" == '' ]; then
                echo -e "$RED\nError: You need pass the file to work"
            else
                echo -e "$CYAN\nFile(s) to be overwritten and deleted:$BLUE"
                echo -e "${fileWork//|/\\n}" # Change | to \n

                echo -en "$RED\nReally want to continue? (y)es or (n)o: $NC"
                read -r continueOrNot

                if [ "$continueOrNot" == 'y' ]; then
                    for file in $fileWork; do
                        if [ ! -f "$file" ]; then
                            echo -e "$RED\nError: The file \"$file\" not exist"
                        else
                            echo -e "${BLUE}Running:$GREEN shred -n 9 -uz $file"
                            shred -n 9 -uz "$file"
                        fi
                    done
                fi
            fi
        elif [ "$folder_or_file" == 'd' ] || [ "$folder_or_file" == '-d' ]; then # to shred folder and theirs files
            IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"

            folderWork=$3
            if [ "$folderWork" == '' ]; then
                echo -e "$RED\nError: You need pass the folder to work$NC"
            elif [ ! -d "$folderWork" ]; then
                echo -e "$RED\nError: The folder \"$folderWork\" not exist$NC"
            else
                echo -e "$CYAN\nFolder to work with:$GREEN $folderWork$NC"

                fileWork=$(find "$folderWork" -type f)
                echo -e "$CYAN\nFile(s) to be overwritten and deleted:"
                echo -e "$BLUE$fileWork"

                echo -en "$RED\nReally want to continue? (y)es or (n)o:$NC "
                read -r continueOrNot

                if [ "$continueOrNot" == 'y' ]; then
                    for file in $fileWork; do
                        echo -e "${BLUE}Running:$GREEN shred -n 9 -uz $file"
                        shred -n 9 -uz "$file"
                    done

                    echo -e "$CYAN\nRemoving folder(s):$NC"
                    folders=$(find "$folderWork" -type d | sort -r)
                    for folder in $folders; do
                        echo -e "${BLUE}Running:$GREEN rmdir $folder"
                        rmdir "$folder"
                    done
                fi
            fi
        else
            echo -e "$RED\nError: Option \"$folder_or_file\" not recognized"
        fi

        IFS=$OLD_IFS
        ;;
    * )
        echo -e "\n$CYAN    $(basename "$0") -$RED Error: Option \"$1\" not recognized$CYAN"
        echo -e "    Try: $0 '--help'$NC"
        ;;
esac

if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE\n        #___ So Long, and Thanks for All the Fish ___#\n$NC"
else
    shift
fi
