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
# Script: altera resolução do seu monitor e projetor
#
# Última atualização: 28/05/2016
#
echo -e "\nEste script troca a resolução do monitor (LVDS1), saída VGA (VGA1), saída HDMI (HDMI1)\n"

# Inicialização de variáveis
LVDS1_status=false
VGA1_status=false
HDMI1_status=false # Implementação no futuro

echo -e "\t--------------------------"
echo -e "\t# Modulos # Estado       #"

if xrandr | grep -q "LVDS1 connected"; then
    echo -e "\t# LVDS1   # Conectado    #"
    LVDS1_status=true
    LVDS1_resolution=`xrandr | grep \+ | grep -v +0 | cut -d' ' -f4 | sed -n "1p"`
else
    echo -e "\t# LVDS1   # Desconectado #"
fi

if xrandr | grep -q "VGA1 connected"; then
    echo -e "\t# VGA1    # Conectado    #"
    VGA1_status=true
    VGA1_resolution=`xrandr | grep \+ | grep -v +0 | cut -d' ' -f4 | sed -n "2p"`
else
    echo -e "\t# VGA1    # Desconectado #"
fi

if xrandr | grep -q "HDMI1 connected"; then
    echo -e "\t# HDMI1   # Conectado    #"
    HDMI1_status=true
    HDMI1_resolution=`xrandr  | grep \+ | grep -v +0 | cut -d' ' -f4 | sed -n "3p"`
else
    echo -e "\t# HDMI1   # Desconectado #"
fi
echo -e "\t--------------------------\n"

if [ $VGA1_status == true ]; then
    echo "1 - LVDS1 $LVDS1_resolution on, VGA1 off"
    echo "2 - LVDS1 off, VGA1 $VGA1_resolution on"
    echo "3 - LVDS1 e VGA1 1024x768 (espelho)"
    echo "4 - LVDS1 $LVDS1_resolution left-of VGA1 $VGA1_resolution"
    echo "0 - Outras opções"
    echo "s - Apenas terminar"
    echo -e "\nQual opções deseja?"
    read resposta
    if [ "$resposta" == '' ]; then
      echo -e "\n\tErro\nVocê deve digitar uma das opções solicitadas\n"
      exit 1
    fi
else
    echo -e "\n\tErro\nNenhum dispositivo conectado na saída VGA1\n"
    exit 1
fi

if [ $resposta = s ]; then
    exit 0
elif [ $resposta = 1 ]; then
    xrandr --output LVDS1 --mode $LVDS1_resolution --primary
    xrandr --output VGA1 --off
    exit 0
elif [ $resposta = 2 ]; then
    xrandr --output VGA1 --mode $VGA1_resolution
    xrandr --output LVDS1 --off
    exit 0
elif [ $resposta = 3 ]; then
    xrandr --output LVDS1 --mode 1024x768
    xrandr --output VGA1 --mode 1024x768 --same-as LVDS1
    exit 0
elif [ $resposta = 4 ]; then
    xrandr --output LVDS1 --mode 1024x768
    xrandr --output VGA1 --mode 1024x768
    xrandr --output LVDS1 --mode $LVDS1_resolution --primary
    xrandr --output LVDS1 --left-of VGA1
    xrandr --output VGA1 --mode $VGA1_resolution
    exit 0
fi

if [ $VGA1_status == true ]; then
    echo -e "\n5 - LVDS1 left-of VGA1"
    echo "6 - LVDS1 right-of VGA1"
    echo "7 - LVDS1 $LVDS1_resolution"
    echo "8 - VGA1 $VGA1_resolution"
    echo "s - Apenas terminar"
    echo -e "\nQual opções deseja?"
    read resposta
    if [ "$resposta" == '' ]; then
        echo -e "\n\tErro\nVocê deve digitar uma das opções solicitadas\n"
        exit 1
    fi
else
    echo -e "\n\tErro\nNenhum dispositivo conectado na saída VGA1\n"
    exit 1
fi

if [ $resposta = s ]; then
    exit 0
elif [ $resposta = 5 ]; then
    xrandr --output LVDS1 --left-of VGA1
elif [ $resposta = 6 ]; then
    xrandr --output LVDS1 --right-of VGA1
elif [ $resposta = 7 ]; then
    xrandr --output LVDS1 --mode $LVDS1_resolution
elif [ $resposta = 8 ]; then
    xrandr --output VGA1 --mode $VGA1_resolution
else
    exit 0
fi

exit 0
#