#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtiva"
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
# Veja a Licença Pública Geral GNU para maiores detalhes.
# Você deve ter recebido uma cópia da Licença Pública Geral GNU
# junto com este programa, se não, escreva para a Fundação do Software
#
# Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#
# Script: funções comum do dia a dia
#
# Última atualização: 17/06/2016
#
echo -e "\n ## Script to usual command ##\n"

option="$1"
if [ $# -lt 1 ]; then
    option="option"
fi

help () {
    echo -e "\t$(basename "$0"): error of parameters"
    echo -e "\tTry $0 'option'\n"
    echo "Options available:"
    echo "    date     - Update the date"
    echo "    swap     - Clean up the Swap Memory"
    echo "    pdf      - Reduce a PDF"
    echo "    weather  - Show the weather forecast"
    echo "    updatedb  - Update the database for 'locate'"
    echo -e "    slack    - Slackware update\n"
}

case $option in
    "option" )
        help
        ;;
    "date" )
        echo -e "\tUpdate the date\n"
        su - root -c 'ntpdate -u -b ntp1.ptb.de'
        ;;
    "swap" )
        echo -e "\tClean up the Swap Memory\n"
        su - root -c 'swapoff -a
        swapon -a'
        ;;
    "pdf" ) # Need Ghostscript
        echo -e "\tReduce a PDF\n"
        if [ $# -eq 1 ]; then
            echo -e "Error, use $0 pdf file.pdf\n"
        else
            arquivo="$2"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$arquivo"-r.pdf "$arquivo"
        fi
        ;;
    "slack" )
        echo -e "\tSlackware update\n"
        echo "Use blacklist?"
        echo -n "Yes <Hit Enter> | No <type n>: "
        read useBL
        if [ "$useBL" == "n" ]; then
            su - root -c '
            slackpkg update gpg
            slackpkg update
            USEBL=0 slackpkg upgrade-all'
        else
            su - root -c '
            slackpkg update gpg
            slackpkg update
            USEBL=1 slackpkg upgrade-all'
        fi
        ;;
    "updatedb" )
        echo -e "\tUpdate the database for 'locate'\n"
        su - root -c '
        updatedb'
    ;;
    "weather" ) # To change the city go to http://wttr.in/ e type the city name on the URL
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos
        ;;
    * )
        echo -e "Error, invalid option!\n"
        help
        ;;
esac
#