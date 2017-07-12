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
    wget "${mirrorDl}ChangeLog.txt" -O "ChangeLog.txt"

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
        echo "$changesToShow" | head -n "$countLines"
    else
        echo -e "\n\t# Updates not found #"
    fi
    echo
}

mirrorDl=$(grep -v "#" /etc/slackpkg/mirrors)
getUpdateMirror "$mirrorDl"
