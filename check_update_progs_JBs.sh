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
# Script: Script to check if some programs has one update
#
# Last update: 31/05/2022
#
set -e

## Color ##
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
useColor

## Default functions ##
downloadHTML() {
    link=$1

    if [ "$link" == '' ]; then
        echo -e "\\n${RED}Error: the link: \"$link\" is not valid!$NC"
    else
        echo -e "$CYAN - wget -q $GREEN$link$CYAN -O a.html$NC"
        wget -q $link -O a.html
    fi
}

checkVersion() {
    progName=$1
    link=$2
    command=$3
    installedVersion=$4

    echo -en "\\n$BLUE$progName"

    downloadHTML "$link"

#     set -x
    version=$(eval $command)
#     echo "version: \"$version\""

    if [ "$installedVersion" == '' ]; then
        installedVersion=$(find /var/log/packages/$progName* | rev | cut -d '-' -f3 | rev)
    fi

    echo -e "\\n$BLUE   Latest version: $GREEN$version\\n${BLUE}Version installed: $GREEN$installedVersion$NC\\n"
    if [ "$version" == "$installedVersion" ]; then
        echo -e "${CYAN}Version installed is equal to latest version.$NC"

    else
        echo -en "${CYAN}Version installed is$RED not equal$CYAN to latest version. Press enter to continue...$NC"
        read -r continue
    fi

    rm a.html
}

## Programs ##
mkvtoolnix () {
    progName="mkvtoolnix" # last tested: "68.0.0"
    link="https://mkvtoolnix.download/index.html"
    command="grep \"Released\" a.html | head -n 1 | cut -d 'v' -f2 | cut -d ' ' -f1"

    checkVersion "$progName" "$link" "$command"
}

smplayer(){
    progName="smplayer" # last tested: "22.2.0"
    link="https://www.smplayer.info/en/downloads"
    command="grep ".tar.bz2" a.html | awk -F '.tar.bz2' '{print \$1}' | rev | cut -d '-' -f1 | rev"

    checkVersion "$progName" "$link" "$command"
}

teamviewer(){
    progName="teamviewer" # last tested: "15.30.3"
    link="https://www.teamviewer.com/en/download/linux/"
    command="grep \"deb package\" a.html | head -n 1 | cut -d ' ' -f3 | cut -d '<' -f1"

    checkVersion "$progName" "$link" "$command"
}

mozilla-firefox(){
    progName="mozilla-firefox" # last tested: "101.0"
    link="https://www.mozilla.org/firefox/all/"
    command="grep \"latest-firefox\" a.html | sed 's/.*latest-firefox=\"//; s/\" .*//'"

    checkVersion "$progName" "$link" "$command"
}

gitahead(){
    progName="gitahead" # last tested: "2.6.3"
    link="https://github.com/gitahead/gitahead/releases/latest"
    command="grep \"Release v\" a.html | head -n1 | sed 's/.*Release v//; s/ .*//'"

    installedVersion="2.6.3"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

maestral(){
    progName="maestral" # last tested: "1.6.2"
    link="https://github.com/samschott/maestral/releases/latest"
    command="grep \"Release v\" a.html | head -n1 | sed 's/.*Release v//; s/ .*//'"

    checkVersion "$progName" "$link" "$command"
}

MasterPDFEditor(){
    progName="MasterPDFEditor" # last tested: ""
    link="https://code-industry.net/free-pdf-editor/#get"
    command="grep -o 'http[^\"]*' a.html | grep \"x86.64.tar.gz\" | cut -d '-' -f5"

    checkVersion "$progName" "$link" "$command"
}

ventoy(){
    progName="ventoy" # last tested: "1.0.74"
    link="https://github.com/ventoy/Ventoy/releases/latest"
    command="grep \"Release Ventoy\" a.html | head -n1 | sed 's/.*Release Ventoy //; s/ .*//'"

    installedVersion="1.0.75"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

virtualbox(){
    progName="virtualbox" # last tested: ""
    link="https://www.virtualbox.org/wiki/Downloads"
    command="grep -o 'http[^\"]*' a.html | grep \"Win.exe\" | sed 's/.*VirtualBox-//; s/.Win.exe//'"

    installedVersion="6.1.34-150636"

    checkVersion "$progName" "$link" "$command" "$installedVersion"
}

default(){
    progName="" # last tested: ""
    link=""
    command=""

    checkVersion "$progName" "$link" "$command"
}

## Call to check version ##
mkvtoolnix
smplayer
teamviewer
mozilla-firefox
gitahead
maestral
MasterPDFEditor
ventoy
virtualbox
