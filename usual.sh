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
# Última atualização: 06/06/2016
#
echo -e "\n ## Script para coisas do dia a dia ##\n"

opcao="$1"
if [ $# -lt 1 ]; then
    opcao="opcao"
fi

case $opcao in
    "opcao" )
        echo -e "\t$(basename "$0"): erro de operandos"
        echo -e "\tTente $0 'opcao'\n"
        echo "Opções diponível:"
        echo "    data     - Atualizar a data"
        echo "    vpnc     - Conectar na vpn da USP"
        echo "    vpnd     - Desconectar da vpn USP"
        echo "    swap     - Limpar o swap"
        echo "    pdf      - Reduzir um pdf"
        echo "    tempo    - Mostrar a previsão do tempo"
        echo -e "    slack-up - Slackware update\n"
        ;;
    "data" )
        echo -e "\tAtualizar a data\n"
        su - root -c 'ntpdate -u -b ntp1.ptb.de'
        ;;
    "vpnc" ) # Irá precisar do vpnc
        echo -e "\tConectar na vpn da USP\n"
        su - root -c 'vpnc /etc/vpnc/vpnuspnet.conf'
        ;;
    "vpnd" )
        echo -e "\tDesconectar da vpn da USP\n"
        su - root -c 'vpnc-disconnect'
        ;;
    "swap" )
        echo -e "\tSwap off e on\n"
        su - root -c 'swapoff -a
        swapon -a'
        ;;
    "pdf" ) # Irá precisar do Ghostscript
        echo -e "\tReduzir um pdf\n"
        if [ $# -eq 1 ]; then
            echo -e "Erro, utilize $0 pdf arquivo.pdf\n"
        else
            arquivo="$2"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$arquivo"-r.pdf "$arquivo"
        fi
        ;;
    "slack-up" )
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
    "tempo" ) # Para mudar a cidade vá até http://wttr.in/ e digite a cidade na URL
        wget -qO - http://wttr.in/S%C3%A3o%20Carlos
        ;;
    * )
        echo -e "Erro, opção invalida!\n"
        ;;
esac
#