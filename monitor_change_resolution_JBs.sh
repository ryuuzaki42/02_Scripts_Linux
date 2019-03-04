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
# Script: Change the resolution of the monitor or/and projector
#
# Last update: 04/03/2019
#
echo -e "\\nScript to change the resolution of your outputs (e.g., LVDS, VGA, HDMI)\\n"

if [ "$1" == "test" ]; then
    optionSelected=$2
    optionSelectedTmp=$3
else
    optionSelected=$1
    optionSelectedTmp=$2
fi

outputConnected=$(xrandr | grep " connected") # Grep connected outputs

activeOutput1=$(echo -e "$outputConnected" | sed -n '1p') # Grep the name of the first output
activeOutput2=$(echo -e "$outputConnected" | sed -n '2p')

#activeOutput3=$(echo -e  "$outputConnected" | sed -n '3p') # Implementation in the future

activeOutput1Resolution=$(echo "$activeOutput1" | cut -d '(' -f1 | rev | cut -d ' ' -f2 | rev | cut -d '+' -f1) # Grep the actual resolution of the first output
activeOutput2Resolution=$(echo "$activeOutput2" | cut -d '(' -f1 | rev | cut -d ' ' -f2 | rev | cut -d '+' -f1)

activeOutput1=$(echo -e "$activeOutput1" | cut -d ' ' -f1) # Grep the name of the first output
activeOutput2=$(echo -e "$activeOutput2" | cut -d ' ' -f1)

outputResolution=$(xrandr | grep \+ | grep -v "connected" | cut -d ' ' -f4) # Grep the resolution to the output active

activeOutput1MaxResolution=$(echo -e "$outputResolution" | sed -n '1p') # Grep the maximum resolution of the first output
activeOutput2MaxResolution=$(echo -e "$outputResolution" | sed -n '2p')

printTrace () {
    echo -e "\\t+-----------------------------------------+"
}

echo -e "\\t Output + Status     + Maximum Resolution"
printTrace
if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
    echo -e "\\t $activeOutput1  + $activeOutput1Resolution   + $activeOutput1MaxResolution"
else
    echo -e "\\t $activeOutput1  + Not active + $activeOutput1MaxResolution"
fi

printTrace
if [ "$activeOutput2" != '' ]; then
    if echo "$activeOutput2Resolution" | grep -q "[[:digit:]]"; then
        echo -e "\\t $activeOutput2  + $activeOutput2Resolution  + $activeOutput2MaxResolution"
    else
        echo -e "\\t $activeOutput2  + Not active + $activeOutput2MaxResolution"
    fi
else
    echo -e "\\n\\tJust one output (\"$activeOutput1\") connected.\\n\\tExiting...\\n"

    if ! echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
        echo -e "\\nThe output $activeOutput1 was not active, activating\\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary
    fi
    exit 0
fi
printTrace

specificResolution1=$(xrandr | sed -n '/'"$activeOutput1"'/,/connected/p' | grep -v "connected" | cut -d ' ' -f4) # Grep all resolution to the first output
specificResolution2=$(xrandr | sed -n '/'"$activeOutput2"'/,/connected/p' | grep -v "connected" | cut -d ' ' -f4)

for value1 in $specificResolution1; do
    for value2 in $specificResolution2; do
        if [ "$value1" == "$value2" ]; then # Grep the maximum resolution that "$activeOutput1" and "$activeOutput2" support
            maximumEqualResolution=$value1
            break
        fi
    done

    if [ "$value1" == "$value2" ]; then
        break
    fi
done

optionTmp1=" 1 - $activeOutput1 $activeOutput1MaxResolution on, $activeOutput2 off"
optionTmp2=" 2 - $activeOutput1 off, $activeOutput2 $activeOutput2MaxResolution on"
optionTmp3=" 3 - $activeOutput1 e $activeOutput2 $maximumEqualResolution (mirror - maximumEqualResolution)"
optionTmp4=" 4 - $activeOutput1 e $activeOutput2 1024x768 (mirror)"
optionTmp5=" 5 - $activeOutput1 $activeOutput1MaxResolution (primary) left-of $activeOutput2 $activeOutput2MaxResolution"
optionTmp6=" 6 - $activeOutput1 $activeOutput1MaxResolution right-of $activeOutput2 $activeOutput2MaxResolution (primary)"
optionTmpc=" c - Set ($activeOutput1 $activeOutput1MaxResolution) or ($activeOutput2 $activeOutput2MaxResolution) in turn"
optionTmpp=" p - Set ($activeOutput1 1024x768) or ($activeOutput2 1024x768) in turn"
optionTmp0=" 0 - Other options"
optionTmpf=" f - Finish"

if [ "$optionSelected" == '' ]; then
    echo -e "\\n$optionTmp1"
    echo "$optionTmp2"
    echo "$optionTmp3"
    echo "$optionTmp4"
    echo "$optionTmp5"
    echo "$optionTmp6"
    echo "$optionTmpc"
    echo "$optionTmpp"
    echo "$optionTmp0"
    echo "$optionTmpf"

    echo -en "\\nWith option you wish?: "
    read -r optionSelected

    if [ "$optionSelected" == '' ]; then
        echo -e "\\n\\tError: You need select one of the option listed\\n"
        exit 1
    fi
fi

case $optionSelected in
    '5' | '6' | '0' )
        # "$activeOutput1" part resolution
        activeOutput1MaxResolution_Part1=$(echo "$activeOutput1MaxResolution" | cut -d 'x' -f1)
        activeOutput1MaxResolution_Part2=$(echo "$activeOutput1MaxResolution" | cut -d 'x' -f2)

        # "$activeOutput2" part resolution
        activeOutput2MaxResolution_Part1=$(echo "$activeOutput2MaxResolution" | cut -d 'x' -f1)
        activeOutput2MaxResolution_Part2=$(echo "$activeOutput2MaxResolution" | cut -d 'x' -f2)

        # Diff "$activeOutput2"_p2 - "$activeOutput1"_p2
        diffResolutionPart2=$(echo "$activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2" | bc)

        if [ "$1" == "test" ]; then # Test propose
            echo -e "\\nactiveOutput1: $activeOutput1MaxResolution_Part1 x $activeOutput1MaxResolution_Part2"
            echo "$activeOutput2: $activeOutput2MaxResolution_Part1 x $activeOutput2MaxResolution_Part2"
            echo "Diff_part2: ($activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2) = $diffResolutionPart2"
        fi
esac

if [ "$optionSelected" == 'c' ]; then
    echo -e "\\n$optionTmpc\\n"
    if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
        optionSelected='2'
    else
        optionSelected='1'
    fi
fi

case $optionSelected in
    'p' )
        echo -e "\\n$optionTmpd\\n"
        if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
            xrandr --output "$activeOutput2" --mode 1024x768
            xrandr --output "$activeOutput1" --off
        else
            xrandr --output "$activeOutput1" --mode 1024x768
            xrandr --output "$activeOutput2" --off
        fi
        ;;
    '1' )
        echo -e "\\n$optionTmp1\\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary
        xrandr --output "$activeOutput2" --off
        ;;
    '2' )
        echo -e "\\n$optionTmp2\\n"
        xrandr --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --primary
        xrandr --output "$activeOutput1" --off
        ;;
    '3' )
        echo -e "\\n$optionTmp3\\n"
        xrandr --output "$activeOutput1" --mode "$maximumEqualResolution"
        xrandr --output "$activeOutput2" --mode "$maximumEqualResolution" --same-as "$activeOutput1"
        ;;
    '4' )
        echo -e "\\n$optionTmp4\\n"
        xrandr --output "$activeOutput1" --mode 1024x768
        xrandr --output "$activeOutput2" --mode 1024x768 --same-as "$activeOutput1"
        ;;
    '5' )
        echo -e "\\n$optionTmp5\\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary --pos "0x$diffResolutionPart2" --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --pos "${activeOutput1MaxResolution_Part1}x0"
        ;;
    '6' )
        echo -e "\\n$optionTmp6\\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --pos "${activeOutput2MaxResolution_Part1}x$diffResolutionPart2" --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --primary --pos 0x0
        ;;
    '0' )
        echo -e "\\n$optionTmp0"
        optionSelected=$optionSelectedTmp

        optionTmp7=" 7 - $activeOutput1 left-of $activeOutput2"
        optionTmp8=" 8 - $activeOutput1 right-of $activeOutput2"
        optionTmp9=" 9 - $activeOutput1 above-of $activeOutput2"
        optionTmp10="10 - $activeOutput1 below-of $activeOutput2"
        optionTmp11="11 - $activeOutput1 primary"
        optionTmp12="12 - $activeOutput2 primary"

        if [ "$optionSelected" == '' ]; then
            echo -e "\\n$optionTmp7"
            echo "$optionTmp8"
            echo "$optionTmp9"
            echo "$optionTmp10"
            echo "$optionTmp11"
            echo "$optionTmp12"
            echo "$optionTmpf"

            echo -en "\\nWith option you wish?: "
            read -r optionSelected

            if [ "$optionSelected" == '' ]; then
                echo -e "\\n\\tError: You need select one of the option listed\\n"
                exit 1
            fi
        fi

        activeOutput1MaxResolution_actual=$(xrandr | grep "$activeOutput1" | sed 's/ primary//' | cut -d " " -f3 | cut -d "+" -f1)
        activeOutput2MaxResolution_actual=$(xrandr | grep "$activeOutput2" | sed 's/ primary//' | cut -d " " -f3 | cut -d "+" -f1)

        if [ "$1" == "test" ]; then ## Test propose
            echo -e "\\n$activeOutput1: $activeOutput1MaxResolution_actual"
            echo "$activeOutput2: $activeOutput2MaxResolution_actual"
        fi

        if echo "$activeOutput1MaxResolution_actual" | grep -qv "[[:digit:]]"; then # Test if $activeOutput1 is ative
            echo -e "\\n\\tError: $activeOutput1 is not active\\n"
            activeOutputNotAtive='1'
        else
            if echo "$activeOutput2MaxResolution_actual" | grep -qv "[[:digit:]]"; then # Test if $activeOutput2 is ative
                echo -e "\\n\\tError: $activeOutput2 is not active\\n"
                activeOutputNotAtive='1'
            fi
        fi

        if [ "$activeOutputNotAtive" == '1' ]; then
            echo -n "What you want: (1) Set the maximum resolution for both and continue or (2) Just terminate?: "
            read -r continueOrNot

            if [ "$continueOrNot" == '1' ]; then # Set the maximum resolution for both and continue
                xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution"
                xrandr --output "$activeOutput2" --mode "$activeOutput2MaxResolution"
            else # Just terminate
                exit 0
            fi
        fi

        if [ "$1" == "test" ]; then # Test propose
            echo -e "\\n$activeOutput1: $activeOutput1MaxResolution_Part1 x $activeOutput1MaxResolution_Part2"
            echo "$activeOutput2: $activeOutput2MaxResolution_Part1 x $activeOutput2MaxResolution_Part2"
            echo "Diff_part2: ($activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2) = $diffResolutionPart2"
        fi

        case $optionSelected in
            '7' )
                echo -e "\\n$optionTmp7\\n"
                xrandr --output "$activeOutput1" --pos "0x$diffResolutionPart2" --output "$activeOutput2" --pos "${activeOutput1MaxResolution_Part1}x0"
                ;;
            '8' )
                echo -e "\\n$optionTmp8\\n"
                xrandr --output "$activeOutput1" --pos "${activeOutput2MaxResolution_Part1}x$diffResolutionPart2" --output "$activeOutput2" --pos 0x0
                ;;
            '9' )
                echo -e "\\n$optionTmp9\\n"
                xrandr --output "$activeOutput1" --above "$activeOutput2"
                ;;
            "10" )
                echo -e "\\n$optionTmp10\\n"
                xrandr --output "$activeOutput1" --below "$activeOutput2"
                ;;
            "11" )
                echo -e "\\n$optionTmp11\\n"
                xrandr --output "$activeOutput1" --primary
                ;;
            "12" )
                echo -e "\\n$optionTmp12\\n"
                xrandr --output "$activeOutput2" --primary
                ;;
            'f' )
                echo -e "\\n$optionTmpf\\n"
                ;;
            * )
                echo -e "\\nError: The option \"$optionSelected\" is not recognized\\n"
        esac
        ;;
    'f' )
        echo -e "\\n$optionTmpf\\n"
        ;;
    * )
        echo -e "\\nError: The option \"$optionSelected\" is not recognized\\n"
esac
