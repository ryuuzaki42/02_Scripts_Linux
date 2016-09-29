#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
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
# Script: altera resolução do seu monitor e projetor
#
# Last update: 29/09/2016
#
echo -e "\nScript to change the resolution of your display (LVDS1), output (VGA1) and output HDMI (HDMI1)\n"

# Initialize variables
LVDS1_status=false
VGA1_status=false
HDMI1_status=false # Implementation in te future

echo -e "\t--------------------------"
echo -e "\t# Input # Status       #"

if xrandr | grep -q "LVDS1 connected"; then
    echo -e "\t# LVDS1   # connected    #"
    LVDS1_status=true
    LVDS1_resolution=`xrandr | grep \+ | grep -v "+0" | grep -v "connected" | cut -d' ' -f4 | sed -n "1p"`
else
    echo -e "\t# LVDS1   # disconnected #"
fi

if xrandr | grep -q "VGA1 connected"; then
    echo -e "\t# VGA1    # connected    #"
    VGA1_status=true
    VGA1_resolution=`xrandr | grep \+ | grep -v "+0" | grep -v "connected" | cut -d' ' -f4 | sed -n "2p"`
else
    echo -e "\t# VGA1    # disconnected #"
fi

if xrandr | grep -q "HDMI1 connected"; then
    echo -e "\t# HDMI1   # connected    #"
    HDMI1_status=true
    HDMI1_resolution=`xrandr  | grep \+ | grep -v "+0" | grep -v "connected" | cut -d' ' -f4 | sed -n "3p"`
else
    echo -e "\t# HDMI1   # disconnected #"
fi
echo -e "\t--------------------------\n"

if [ $VGA1_status == true ]; then
    echo "1 - LVDS1 $LVDS1_resolution on, VGA1 off"
    echo "2 - LVDS1 off, VGA1 $VGA1_resolution on"
    echo "3 - LVDS1 e VGA1 1024x768 (mirror)"
    echo "4 - LVDS1 $LVDS1_resolution (primary) left-of VGA1 $VGA1_resolution"
    echo "5 - LVDS1 $LVDS1_resolution right-of VGA1 $VGA1_resolution (primary)"
    echo "0 - Another options"
    echo "f - Finish or terminate"

    echo -e "\nWith option you wish?"
    read optionSelected
    if [ "$optionSelected" == '' ]; then
        echo -e "\n\tError: You need select one of the option listed\n"
        optionSelected="" # Seting a option that is not valid to jump the case in front
    fi
else
    echo -e "\n\tError: None device connected in the output VGA1\n"
    optionSelected="" # Seting a option that is not valid to jump the case in front
fi

if [ "$optionSelected" == 4 ] || [ "$optionSelected" == 5 ]; then # Only for the option 4 and 5
    # LVDS1 part resolution
    LVDS1_resolution_Part1=`echo $LVDS1_resolution | cut -d 'x' -f1`
    LVDS1_resolution_Part2=`echo $LVDS1_resolution | cut -d 'x' -f2`

    # VGA1 part resolution
    VGA1_resolution_Part1=`echo $VGA1_resolution | cut -d 'x' -f1`
    VGA1_resolution_Part2=`echo $VGA1_resolution | cut -d 'x' -f2`

    # Diff VGA1_p2 - LVDS1_p2
    diffResolutionPart2=`echo "$VGA1_resolution_Part2 - $LVDS1_resolution_Part2" | bc`

    if [ "$1" != "" ]; then ## Test propose
        echo -e "\nLVDS1: $LVDS1_resolution_Part1 x $LVDS1_resolution_Part2"
        echo "VGA1: $VGA1_resolution_Part1 x $VGA1_resolution_Part2"
        echo "Diff_part2: ($VGA1_resolution_Part2 - $LVDS1_resolution_Part2) = $diffResolutionPart2"
    fi
fi

case $optionSelected in
    1 )
        xrandr --output LVDS1 --mode $LVDS1_resolution --primary
        xrandr --output VGA1 --off
        ;;
    2 )
        xrandr --output VGA1 --mode $VGA1_resolution --primary
        xrandr --output LVDS1 --off
        ;;
    3 )
        xrandr --output LVDS1 --mode 1024x768
        xrandr --output VGA1 --mode 1024x768 --same-as LVDS1
        ;;
    4 )
        xrandr --output LVDS1 --mode $LVDS1_resolution --primary --pos 0x$diffResolutionPart2 --output VGA1 --mode $VGA1_resolution --pos "$LVDS1_resolution_Part1"x0
        ;;
    5 )
        xrandr --output LVDS1 --mode $LVDS1_resolution --pos "$VGA1_resolution_Part1"x"$diffResolutionPart2" --output VGA1 --mode $VGA1_resolution --primary --pos 0x0
        ;;
    0 )
        echo -e "\n6 - LVDS1 left-of VGA1"
        echo "7 - LVDS1 right-of VGA1"
        echo "8 - LVDS1 above-of VGA1"
        echo "9 - LVDS1 below-of VGA1"
        echo "10 - LVDS1 primary"
        echo "11 - VGA1 primary"
        echo "f - Finish or terminate"

        echo -e "\nWith option you wish?"
        read optionSelected
        if [ "$optionSelected" == '' ]; then
            echo -e "\n\tError: You need select one of the option listed\n"
            optionSelected="" # Seting a option that is not valid to jump the case in front
        fi

        LVDS1_resolution_actual=`xrandr | grep "LVDS1" | sed 's/ primary//' | cut -d" " -f3 | cut -d"+" -f1`
        VGA1_resolution_actual=`xrandr | grep "VGA1" | sed 's/ primary//' | cut -d" " -f3 | cut -d"+" -f1`

        if [ "$1" != "" ]; then ## Test propose
            echo -e "\nLVDS1: $LVDS1_resolution_actual"
            echo "VGA1: $VGA1_resolution_actual"
        fi

        # LVDS1 part resolution
        LVDS1_resolution_Part1=`echo $LVDS1_resolution_actual | cut -d 'x' -f1`
        LVDS1_resolution_Part2=`echo $LVDS1_resolution_actual | cut -d 'x' -f2`

        # VGA1 part resolution
        VGA1_resolution_Part1=`echo $VGA1_resolution_actual | cut -d 'x' -f1`
        VGA1_resolution_Part2=`echo $VGA1_resolution_actual | cut -d 'x' -f2`

        # Diff VGA1_p2 - LVDS1_p2
        if echo $LVDS1_resolution_actual | grep -q [[:digit:]]; then # Test if LVDS1 is ative
            if echo $VGA1_resolution_actual | grep -q [[:digit:]]; then # Test if VGA1 is ative
                diffResolutionPart2=`echo "$VGA1_resolution_Part2 - $LVDS1_resolution_Part2" | bc`
            else
                echo -e "\n\tError: VGA1 is not ative\n"
                optionSelected="" # Seting a option that is not valid to jump the case in front
            fi
        else
            echo -e "\n\tError: LVDS1 is not ative\n"
            optionSelected="" # Seting a option that is not valid to jump the case in front
        fi

        if [ "$1" != "" ]; then ## Test propose
            echo -e "\nLVDS1: $LVDS1_resolution_Part1 x $LVDS1_resolution_Part2"
            echo "VGA1: $VGA1_resolution_Part1 x $VGA1_resolution_Part2"
            echo "Diff_part2: ($VGA1_resolution_Part2 - $LVDS1_resolution_Part2) = $diffResolutionPart2"
        fi

        case $optionSelected in
            6 )
                xrandr --output LVDS1 --pos 0x$diffResolutionPart2 --output VGA1 --pos "$LVDS1_resolution_Part1"x0
                ;;
            7 )
                xrandr --output LVDS1 --pos "$VGA1_resolution_Part1"x"$diffResolutionPart2" --output VGA1 --pos 0x0
                ;;
            8 )
                xrandr --output LVDS1 --above VGA1
                ;;
            9 )
                xrandr --output LVDS1 --below VGA1
                ;;
            10 )
                xrandr --output LVDS1 --primary
                ;;
            11 )
                xrandr --output VGA1 --primary
                ;;
        esac
        ;;
esac
