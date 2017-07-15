#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Com contibuições de Rumber (github.com/rumbler)
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
# Last update: 15/07/2017
#
echo -e "\n# Script to check for Slackware updates #"

optionInput=$1
if [ "$optionInput" == 'h' ]; then
    echo -e "\n# If has a mirror not valid in \"/etc/slackpkg/mirrors\" you can use:"
    echo -e "\t$(basename "$0") h - this help message"
    echo -e "\t$(basename "$0") s - to select one mirror from stable version"
    echo -e "\t$(basename "$0") c - to select one mirror from current"
    echo -e "\t$(basename "$0") n - to insert your favorite mirror"
fi

alinPrint () {
    inputValue=$1
    countSpaces=$2

    echo -en " # $inputValue"
    spacesUsed=${#inputValue}
    while [ "$spacesUsed" -lt "$countSpaces" ]; do
        echo -n " "
        ((spacesUsed++))
    done
}

tracePrint () {
    count1=$1
    count2=$2
    countTmp='1'
    echo -n " "

    countTotal=$(echo "$count1 * 2 + $count2 * 2 + 13" | bc)
    while [ "$countTmp" -lt "$countTotal" ]; do
        echo -n "-"
        ((countTmp++))
    done
    echo
}

getUpdateMirror () {
    mirrorDl=$1
    echo -e "\nGetting the \"ChangeLog.txt\" from: \"$mirrorDl\". Please wait..."

    mirrorDlTest=$(echo "$mirrorDl" | cut -d "/" -f1)
    if [ "$mirrorDlTest" == "file:" ] || [ "$mirrorDlTest" == "cdrom:" ]; then
        mirrorDl=$(echo "$mirrorDl" | cut -d '/' -f2-)

        cp "$mirrorDl/ChangeLog.txt" "$(pwd)"
    else
        wget "${mirrorDl}ChangeLog.txt"
    fi
    changePkgs=$(grep -E "txz|tgz|\+---|UTC" ChangeLog.txt)

    if [ "$countPkg" != '' ]; then
        count1="25"
        count2="55"

        echo
        tracePrint "$count1" "$count2"
        alinPrint "Package Name" "$count1"
        alinPrint "Version installed" "$count2"
        alinPrint "Update available" "$count2"
        alinPrint "Summary" "$count1"
        echo "#"
        tracePrint "$count1" "$count2"

        for value in $changePkgs; do
            if echo "$value" | grep -qE "txz|tgz"; then # Find one package to update
                packageName=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | cut -d '-' -f4- | rev)
                packageNameUpdate=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | rev)

                packageVersionInstalled=$(find /var/log/packages/ | grep "/$packageName-" | rev | cut -d '/' -f1 | rev)
                countPkg=$(echo -e "$packageVersionInstalled" | wc -l) # To test if found more than one package with $packageName
                countPkgTmp='1'
                for pkg in $packageVersionInstalled; do
                    pkgTmp=$(echo "$pkg" | rev | cut -d '-' -f4- | rev)

                    if [ "$pkgTmp" == "$packageName" ]; then
                        packageVersionInstalled=$pkg
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
                        alinPrint "$packageName" "$count1"
                        alinPrint "$packageVersionInstalled" "$count2"
                        alinPrint "$packageNameUpdate" "$count2"

                        if [ "$versionInstalled" == "$versionUpdate" ]; then
                            alinPrint "Rebuilt" "$count1"
                        else
                            alinPrint "$versionInstalled to $versionUpdate" "$count1"
                        fi

                        echo "#"
                        tracePrint "$count1" "$count2"
                    fi
                else
                    valueToStopPrint=$packageNameUpdateTmp
                    break
                fi
            fi
        done

        changesToShow=$(sed '/'"$valueToStopPrint"'/q' ChangeLog.txt)
        rm ChangeLog.txt

        countLines=$(echo "$changesToShow" | grep -n "\+---" | tail -n 1 | cut -d: -f1)
    else
        rm ChangeLog.txt
        countLines=''
    fi

    if [ "$countLines" != '' ]; then
        updaesAvailable=$(echo "$changesToShow" | head -n "$countLines")
        updaesAvailable=$(echo -e "\n+--------------------------+\n$updaesAvailable")
        echo "$updaesAvailable"

        updaesAvailable=${updaesAvailable//'"'/'\"'} # Change " to \" go get error with "echo "notify-send""

        iconName="audio-volume-high"
        notificationToSend=$(echo -e "notify-send \"$(basename "$0")\n\n Updates available\" \"$updaesAvailable\" -i \"$iconName\"")
    else
        echo -e "\n\t# Updates not found #"

        iconName="audio-volume-muted"
        notificationToSend=$(echo -e "notify-send \"$(basename "$0")\n\n Updates not found\" \"No news is good news\" -i \"$iconName\"")
    fi

    eval "$notificationToSend"
    echo
}

getValidMirror () {
    mirrorDl=$(grep -v "#" /etc/slackpkg/mirrors)

    if [ "$mirrorDl" != '' ]; then
        echo -e "\nMirror active in \"/etc/slackpkg/mirrors\":\n\"$mirrorDl\""
    else
        echo -e "\nThere is no mirror active in \"/etc/slackpkg/mirrors\""
        echo -e "\t# Please active one mirror #"
    fi

    mirrorDlTest=$(echo "$mirrorDl" | cut -d "/" -f1)
    if [ "$mirrorDlTest" == "file:" ] || [ "$mirrorDlTest" == "cdrom:" ]; then
        mirrorDl=$(echo "$mirrorDl" | cut -d '/' -f2-)

        if [ ! -x "$mirrorDl" ]; then
            echo -e "\nThe mirror folder don't exist: \"$mirrorDl\""
            mirrorTest='1'
        fi
    else
        mirrorTest='1'
    fi

    if [ "$mirrorTest" == '1' ]; then
        if echo "${mirrorDl}" | grep -vqE "^http:|^ftp:"; then
            if [ "$mirrorDl" != '' ]; then
                echo -e "\t# This mirror is not valid #"
            fi

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
                echo -e "\nSuggested mirror to use:"
                echo "s - (stable) - $mirrorFinal"
                echo "c - (current) - $mirrorCurrent"
                echo "n - Or insert your favorite mirror"
                echo -n "Which mirror you want?: "
                read -r optionInput
            fi

            if [ "$optionInput" == 's' ]; then
                mirrorDl=$mirrorFinal
            elif [ "$optionInput" == 'c' ]; then
                mirrorDl=$mirrorCurrent
            else
                mirrorSource=''
                testMirrorCommand="echo \"\$mirrorSource\" | grep -vqE \"^ftp:|^http:|^file:|^cdrom:\""
                while eval $testMirrorCommand; do
                    echo -en "\nType the new mirror: "
                    read -r mirrorSource

                    if eval $testMirrorCommand; then
                        echo -e "\nError: the mirror \"$mirrorSource\" is not valid"
                        echo "One valid mirror has \"ftp:\", \"http:\", \"file:\" or \"cdrom:\""
                    fi
                done

                echo -e "\nNew mirror: $mirrorSource"
                mirrorDl=$mirrorSource
            fi
        fi
    fi

    echo -e "\nUsing the mirror: \"$mirrorDl\""
}

getValidMirror "$optionInput"

getUpdateMirror "$mirrorDl"
