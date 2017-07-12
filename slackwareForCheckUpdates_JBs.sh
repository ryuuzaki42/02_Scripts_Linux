
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
# Script: Script to check for Slackware updates
#
# Last update: 12/07/2017
#
echo -e "\n# Script to check for Slackware updates #\n"

optionInput=$1
if [ "$optionInput" == '' ]; then
    echo -e "\n# If has a mirror not valid in /etc/slackpkg/mirrors you can use:"
    echo -e "\t$(basename $0) s - to select one mirror from stable version"
    echo -e "\t$(basename $0) c - to select one mirror from current"
    echo -e "\t$(basename $0) n - to insert your favorite mirror"
fi

alinPrint () {
    echo -n " # "

    inputValue=$1
    countSpaces=$2

    echo -en " $inputValue"
    spacesUsed=${#inputValue}
    while [ "$spacesUsed" -lt "$countSpaces" ]; do
        echo -n " "
        ((spacesUsed++))
    done
}

tracePrint () {
    count1=$1
    count2=$2

    countTmp=1
        echo -n " "
    countTotal=$(echo "$count1 * 2 + $count2 * 2 + 16" | bc)
    while [ "$countTmp" -lt "$countTotal" ]; do
        echo -n "-"
        ((countTmp++))
    done
    echo
}

getUpdateMirror () {
    mirrorDl=$1

    echo -e "Download the ChangeLog.txt from: \"$mirrorDl\". Please wait...\n"
    
    ml=`echo $1 | cut -d ":" -f 1`
    
    if [ "$ml" = "file" ]; then
    local=`echo $1 | cut -d ":" -f 2 | cut -c 2-`
    cp "$local"/ChangeLog.txt $PWD
    else
    wget ${mirrorDl}ChangeLog.txt
    fi
    
    changePkgs=$(grep -E "txz|tgz|\+---|UTC" ChangeLog.txt)

    count1="20"
    count2="50"

    echo
    alinPrint "Package Name" "$count1"
    alinPrint "Version installed" "$count2"
    alinPrint "Update available" "$count2"
    alinPrint "Status" "$count1"
    echo "#"
    tracePrint "$count1" "$count2"

    for value in $changePkgs; do
        if echo "$value" | grep -qE "txz|tgz"; then # Find one package to update
            packageName=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | cut -d '-' -f4- | rev)
            packageNameUpdate=$(echo "$value" | cut -d ':' -f1 | rev | cut -d '/' -f1 | rev)

            packageVersionInstalled=$(find /var/log/packages/ | grep "/$packageName-" | head -n 1 | rev | cut -d '/' -f1 | rev)

            versionUpdate=$(echo "$packageNameUpdate" | rev | cut -d '-' -f3 | rev)
            versionInstalled=$(echo "$packageVersionInstalled" | rev | cut -d '-' -f3 | rev)

            packageNameUpdateTmp=$(echo "$packageNameUpdate" | rev | cut -d '.' -f2-| rev)
            locatePackage=$(find /var/log/packages/ | grep "$packageNameUpdateTmp")

            if [ "$locatePackage" == '' ]; then
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
            else
                valueToStopPrint=$packageNameUpdateTmp
                break
            fi
        fi
    done

    changesToShow=$(sed '/'"$valueToStopPrint"'/q' ChangeLog.txt)
    rm ChangeLog.txt

    countLines=$(echo "$changesToShow" | grep -n "\+---" | tail -n 1  | cut -d: -f1)
    if [ "$countLines" != '' ]; then
        echo -e "\n+--------------------------+"
        updaesAvailable=$(echo "$changesToShow" | head -n "$countLines")
        echo "$updaesAvailable"

        iconName="audio-volume-high"
        notify-send "$(basename $0)
Updates available" "$updaesAvailable" -i "$iconName"
    else
        echo -e "\n\t# Updates not found #"

        iconName="audio-volume-muted"
        notify-send "$(basename $0)
Updates not found" "No news is good news" -i "$iconName"
    fi
    echo
}

getValidMirror () {
    mirrorDl=$(grep -v "#" /etc/slackpkg/mirrors)

    if echo "${mirrorDl}" | grep -vqE "http:|ftp:"; then
        echo -e "\nMirror ative in \"/etc/slackpkg/mirrors\":\n$mirrorDl"
        echo -e "\t# This mirror is not valid #"

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

        mirrorChose=$1
        if [ "$mirrorChose" == '' ]; then
            echo -e "\nSuggested mirror to use:"
            echo "s - (stable) - $mirrorFinal"
            echo "c - (current) - $mirrorCurrent"
            echo "n - Or insert your favorite mirror"
            echo -n "Which mirror you want?: "
            read -r mirrorChose
        fi

        if [ "$mirrorChose" == 's' ]; then
            mirrorDl=$mirrorFinal
        elif [ "$mirrorChose" == 'c' ]; then
            mirrorDl=$mirrorCurrent
        else
            mirrorSource=''
            while echo "$mirrorSource" | grep -vqE "ftp|http"; do
                echo -en "$CYAN \nType the new mirror:$NC "
                read -r mirrorSource

                if echo "$mirrorSource" | grep -vqE "ftp|http"; then
                    echo -e "$RED\nError: the mirror \"$mirrorSource\" is not valid.\nOne valid mirror has \"ftp\" or \"http\"$NC"
                fi
            done

            echo -e "$CYAN\nNew mirror:$GREEN $mirrorSource$NC"
            mirrorDl=$mirrorSource
        fi
    fi
    echo -e "\nUsing the mirror: $mirrorDl\n"
}

getValidMirror "$optionInput"

getUpdateMirror "$mirrorDl"
