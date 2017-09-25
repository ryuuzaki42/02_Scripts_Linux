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
# Script: Download Slackware packages (txz/tgz) from a https://pkgs.org/ website
#
# Last update: 25/09/2017
#
programName=$1
justUrl=$2

echo -e "\n# Download Slackware packages (txz/tgz) from a https://pkgs.org/ website #"
echo -e "\nTip1 use: $(basename "$0") \"programName\" to not be asked about the program name"
echo "Tip2 use: $(basename "$0") \"programName\" \"url\" to only print the link to download the package"

if [ "$programName" == '' ]; then
    echo -en "\nProgram name: "
    read -r programName
fi

if [ "$programName" == '' ]; then
    echo -e "\nThe name of the program/package can't be blank\n"
else
    echo -en "\nSlackware version (hit enter to insert 14.2): "
    read -r slackwareVersion

    if [ "$slackwareVersion" == '' ]; then
        slackwareVersion="14.2"
    fi

    echo
    wget "https://pkgs.org/download/$programName" -O "$programName"

    packagesLink=$(grep -E "txz|tgz" < "$programName" | grep "$slackwareVersion" | cut -d '=' -f2- | cut -d '>' -f1 | cut -d '"' -f2)
    rm "$programName"

    if [ "$packagesLink" != '' ]; then
        echo -e "\nPackage(s) found: "
        countPackage=1

        for package in $packagesLink; do
            if [ "$countPackage" -lt "10" ]; then
                echo -n " "
            fi

            echo -n "$countPackage - "
            echo "$package" | cut -d '/' -f4-

            echo -e "\t ### $package\n"

            ((countPackage++))
        done
        ((countPackage--))

        echo "# Pay attention to the architecture wanted #"
        echo -e "\nWhich package do you want download?"
        echo -n "Valid numbers 1 to $countPackage: "
        read -r packageNumber

        ((countPackage++))
        if [ "$packageNumber" -lt "$countPackage" ]; then
            countTmp='1'

            for package in $packagesLink; do
                if [ "$countTmp" == "$packageNumber" ]; then
                    packagePageLink=$package
                fi

                ((countTmp++))
            done

            echo
            wget "$packagePageLink" -O "$programName"

            linkDl=$(grep "Binary package" < "$programName" | cut -d '=' -f4 | cut -d '"' -f2)
            rm "$programName"

            if [ "$justUrl" == "url" ]; then
                continueDl='n'
            else
                echo -e "\nDownload the package or Just show the link to download?"
                echo -n "(y)es to download the package or (n)o to only show the link (hit enter to yes): "
                read -r continueDl
            fi

            echo
            if [ "$continueDl" != 'n' ]; then
                wget "$linkDl"
            else
                echo "Link to download the package:"
                echo "$linkDl"
            fi

            echo -e "\nSo Long, and Thanks for All the Fish\n"
        else
            echo -e "\nPackage number selected is big than the total of packages found\n"
        fi
    else
        echo -e "\nNone package found\n"
    fi
fi
