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
# Script: funções comum do dia-a-dia
#
# Última atualização: 05/01/2016
#
#echo $# Quantidade de parâmetros
echo -e "\nscript para coisas do dia a dia\n"

if [ $# -lt 1 ]
    then
    echo "$(basename "$0"): erro de operandos"
    echo "tente $0 opcao para ver todas opções\n"
    exit 0;
fi

opcao="$1"

if [ $opcao = opcao ]; then
    echo "data     - atualizar a data"
    echo "vpnc     - conectar na vpn da USP"
    echo "vpnd     - desconectar da vpn"
    echo "swap     - limpar o swap"
    echo "pdf      - reduzir pdf"
    echo "tempo    - mostrar a previsão do tempo"
    echo -e "slack-up - slack update\n"
elif [ $opcao = data ]; then
    echo -e "\tatualizar a data\n"
    su - root -c 'ntpdate -u -b ntp1.ptb.de'
elif [ $opcao = vpnc ]; then # irá precisar do vpnc
    echo -e "\tconectar na vpn da USP\n"
    su - root -c 'vpnc /etc/vpnc/usp.conf'
elif [ $opcao = vpnd ]; then
    echo -e "\tdesconectar da vpn\n"
    su - root -c 'vpnc-disconnect'
elif [ $opcao = swap ]; then
    echo -e "\tswap off e on\n"
    su - root -c 'swapoff -a
    swapon -a'
elif [ $opcao = pdf ]; then # irá precisar do Ghostscript
    echo -e "\tReduzir pdf\n"
    if [ $# -eq 1 ]; then
        echo -e "Erro, utilize $0 pdf arquivo.pdf\n"
    else
        arquivo="$2"
        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -sOutputFile="$arquivo"-r.pdf "$arquivo"
    fi
elif [ $opcao = slack-up ]; then
    echo -e "\tslackware update\n"
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
elif [ $opcao = tempo ]; then
    # Para mudar a cidade vá até http://wttr.in/ e digite a cidade na URL
    wget -qO - http://wttr.in/S%C3%A3o%20Carlos
else
    echo -e "erro, opção invalida!\n"
fi