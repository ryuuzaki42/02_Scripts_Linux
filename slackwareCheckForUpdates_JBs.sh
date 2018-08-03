#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Com contibuições de Rumbler Soppa (github.com/rumbler)
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
# Script: Script to check for Slackware updates
#
# Last update: 24/01/2018
#
echo -e "\\n# Script to check for Slackware updates #"

helpMessage() {
    echo -e "\\nOptions:\\n    -h    this message"
    echo "    -n    to turn notification off"
    echo -e "\\n    # If has a mirror not valid in \"/etc/slackpkg/mirrors\" you can use:"
    echo "        -s    to select one mirror from stable version"
    echo "        -c    to select one mirror from current version"
    echo -e "        -i    to insert your favorite mirror <ftp:|http:|file:>\\n"
    exit 0
}

optionNotRecognized() {
    echo -e "\\n    Error: The option: \"$1\" is not recognized"
    echo -e "    For help run: $(basename "$0") -h\\n"
    exit 1
}

while getopts "hscin" valuesInput; do
    case $valuesInput in
        'h' )
            helpMessage ;;
        's' | 'c' | 'i' )
            optionInput=$valuesInput ;;
        'n' )
            notificationOff='1' ;;
        * )
           optionNotRecognized "$valuesInput" ;;
    esac
done

mirrorSuggestion() {
    slackwareVersion=$(grep "VERSION=" /etc/os-release | cut -d '"' -f2)
    slackwareArch=$(uname -m)

    mirrorPart1="ftp://mirrors.slackware.com/slackware/"
    mirrorCurrent="${mirrorPart1}slackware64-current/"

    if echo "$slackwareArch" | grep -q "64"; then
        mirrorPart2="slackware64-$slackwareVersion/"
    else
        mirrorPart2="slackware-$slackwareVersion/"
    fi
    mirrorFinal=$mirrorPart1$mirrorPart2

    if [ "$optionInput" == '' ]; then
        echo -e "\\nSuggested mirrors to use:"
        echo " s - (stable)  - $mirrorFinal"
        echo " c - (current) - $mirrorCurrent"
        echo " i - Or insert your favorite mirror"
        echo -en "\\nWhich mirror you want?: "
        read -r optionInput
    fi

    if [ "$optionInput" == 's' ]; then
        mirrorDl=$mirrorFinal
    elif [ "$optionInput" == 'c' ]; then
        mirrorDl=$mirrorCurrent
    elif [ "$optionInput" == 'i' ]; then
        mirrorSource=''
        testMirrorCommand="echo \"\$mirrorSource\" | grep -vqE \"^ftp:|^http:|^file:\""

        while eval "$testMirrorCommand"; do
            echo -en "\\nType the new mirror: "
            read -r mirrorSource

            if eval "$testMirrorCommand"; then
                echo -e "\\nError: the mirror \"$mirrorSource\" is not valid"
                echo "One valid mirror has \"ftp:\", \"http:\" or \"file:\""
            fi
        done

        echo -e "\\nNew mirror: $mirrorSource"
        mirrorDl=$mirrorSource
    else
        optionNotRecognized "$optionInput"
    fi
}

getValidMirror() {
    mirrorDl=$(grep -v "#" /etc/slackpkg/mirrors | head -n 1 | sed 's/ //g')

    if [ "$mirrorDl" != '' ]; then
        echo -e "\\nMirror active in \"/etc/slackpkg/mirrors\":\\n\"$mirrorDl\""

        mirrorDlTest=$(echo "$mirrorDl" | cut -d "/" -f1)
        if [ "$mirrorDlTest" == "file:" ]; then
            mirrorDlTmp=$(echo "$mirrorDl" | cut -d '/' -f2-)

            if [ ! -d "$mirrorDlTmp" ]; then
                echo -e "\\nThe mirror folder don't exist: \"$mirrorDl\""
                mirrorNotValid='1'
            else
                if [ ! -e "${mirrorDlTmp}ChangeLog.txt" ]; then
                    echo -e "\\nThe \"ChangeLog.txt\" file don't exist: \"${mirrorDlTmp}ChangeLog.txt\""
                    mirrorNotValid='1'
                fi
            fi
        else
            if echo "$mirrorDl" | grep -vqE "^http:|^ftp:"; then
                mirrorNotValid='1'
            fi
        fi
    else
        echo -e "\\nThere is no mirror active in \"/etc/slackpkg/mirrors\""
        echo -e "        # Please active one mirror #"
        mirrorNotValid='1'
    fi

    if [ "$mirrorNotValid" == '1' ]; then
        if [ "$mirrorDl" != '' ]; then
            echo -e "        # This mirror is not valid #"
        fi

        mirrorSuggestion
    fi

    echo -e "\\nUsing the mirror: \"$mirrorDl\""
    getUpdateMirror
}

alinPrint() {
    inputValue=$1
    countSpaces=$2

    echo -en " # $inputValue"
    spacesUsed=${#inputValue}
    while [ "$spacesUsed" -lt "$countSpaces" ]; do
        echo -n " "
        ((spacesUsed++))
    done
}

tracePrint() {
    countTmp='1'
    echo -n " "
    countTotal=$(echo "$count1 * 2 + $count2 * 2 + 13" | bc)

    while [ "$countTmp" -lt "$countTotal" ]; do
        echo -n "-"
        ((countTmp++))
    done
    echo
}

getUpdateMirror() {
    echo -e "\\nGetting the \"ChangeLog.txt\" from: \"$mirrorDl\". Please wait..."

    tmpFile=$(mktemp) # Tmp file to save the "ChangeLog.txt"

    mirrorDlTest=$(echo "$mirrorDl" | cut -d "/" -f1)
    if [ "$mirrorDlTest" == "file:" ]; then
        mirrorDl=$(echo "$mirrorDl" | cut -d '/' -f2-)

        echo -e "\\n# cp \"${mirrorDl}ChangeLog.txt\" \"$tmpFile\" #"
        cp "${mirrorDl}ChangeLog.txt" "$tmpFile"
    else
        echo -e "\\n# wget \"${mirrorDl}ChangeLog.txt\" -O \"$tmpFile\" #\\n"
        wget "${mirrorDl}ChangeLog.txt" -O "$tmpFile"
    fi
    changePkgs=$(grep -E "txz|tgz" "$tmpFile") # Find packages to update

    count1="25"
    count2="55"

    echo
    tracePrint
    alinPrint "Package name" "$count1"
    alinPrint "Version installed" "$count2"
    alinPrint "Update available" "$count2"
    alinPrint "Summary" "$count1"
    echo "#"
    tracePrint

    for value in $changePkgs; do
        packageName=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | cut -d '-' -f4- | rev)
        packageNameUpdate=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | rev)

        packageVersionInstalled=$(find /var/log/packages/ | grep "/$packageName-" | rev | cut -d '/' -f1 | rev)
        countPkg=$(echo -e "$packageVersionInstalled" | wc -l) # To test if found more than one package with "$packageName"

        countPkgTmp='1'
        for pkg in $packageVersionInstalled; do
            pkgTmp=$(echo "$pkg" | rev | cut -d '-' -f4- | rev)

            if [ "$pkgTmp" == "$packageName" ]; then
                packageVersionInstalled=$pkg
                break
            else
                if [ "$countPkg" == "$countPkgTmp" ]; then
                    packageVersionInstalled=''
                fi
            fi

            ((countPkgTmp++))
        done

        versionUpdate=$(echo "$packageNameUpdate" | rev | cut -d '-' -f3 | rev)
        versionInstalled=$(echo "$packageVersionInstalled" | rev | cut -d '-' -f3 | rev)

        packageNameUpdateTmp=$(echo "$packageNameUpdate" | rev | cut -d '.' -f2- | rev)
        locatePackage=$(find /var/log/packages/ | grep "$packageNameUpdateTmp")

        if [ "$locatePackage" == '' ]; then # To no print the last package (the already update in the Slackware)
            if [ "$packageVersionInstalled" != '' ]; then # To print only if the package has another version installed
               updatesFound='1'

                alinPrint "$packageName" "$count1"
                alinPrint "$packageVersionInstalled" "$count2"
                alinPrint "$packageNameUpdate" "$count2"

                if [ "$versionInstalled" == "$versionUpdate" ]; then
                    alinPrint "Rebuilt" "$count1"
                else
                    alinPrint "$versionInstalled to $versionUpdate" "$count1"
                fi

                echo "#"
                tracePrint
            fi
        else
            valueToStopPrint=$packageNameUpdateTmp
            break
        fi
    done

    changesToShow=$(sed '/'"$valueToStopPrint"'/q' "$tmpFile")
    countLines=$(echo "$changesToShow" | grep -n "\\+---" | tail -n 1 | cut -d: -f1)

    if [ "$updatesFound" == '1' ]; then
        if [ "$countLines" == '' ]; then
            updaesAvailable=$changesToShow
        else
            updaesAvailable=$(echo "$changesToShow" | head -n "$countLines")
        fi

        updaesAvailable=$(echo -e "\\n+--------------------------+\\n$updaesAvailable")
        echo -e "$updaesAvailable\\n"

        updaesAvailable=${updaesAvailable//'"'/'\"'} # Change " to \" go get error with "echo "notify-send""

        iconName="audio-volume-high"
        notificationToSend=$(echo -e "notify-send \"$(basename "$0")\\n\\n Updates available\" \"$updaesAvailable\" -i \"$iconName\"")
    else
        echo -e "\\n        # Updates not found #\\n"

        iconName="audio-volume-muted"
        notificationToSend=$(echo -e "notify-send \"$(basename "$0")\\n\\n Updates not found\" \"No news is good news\" -i \"$iconName\"")
    fi

    rm "$tmpFile"

    if [ "$notificationOff" != '1' ]; then
        eval "$notificationToSend"
    fi
}

getValidMirror
