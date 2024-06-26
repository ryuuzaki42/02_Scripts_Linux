#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Script: Change the resolution of your outputs (e.g., LVDS, eDP, VGA, HDMI)
#
# Last update: 21/06/2023
#
# Tip: Add a shortcut to this script
#
echo -e "\n # Script to change the resolution of monitors or/and projector #\n"

if [ "$1" == "test" ]; then
    optionSelected=$2    # If option part 1 (if is on part 2, pass 0)
    optionSelectedTmp=$3 # If option is on part 2
    resolutionOk=$4      # Ask for confirmation
    notificationOff=$5   # Pass 1 to disable notification
else
    optionSelected=$1
    optionSelectedTmp=$2
    resolutionOk=$3
    notificationOff=$4
fi

outputConnected=$(xrandr | grep " connected") # Grep connected outputs

activeOutput1=$(echo -e "$outputConnected" | sed -n '1p') # Grep the name of the first output
activeOutput2=$(echo -e "$outputConnected" | sed -n '2p')

#activeOutput3=$(echo -e "$outputConnected" | sed -n '3p') # Implementation in the future

activeOutput1Resolution=$(echo "$activeOutput1" | cut -d '(' -f1 | rev | cut -d ' ' -f2 | rev | cut -d '+' -f1) # Grep the actual resolution of the first output
activeOutput2Resolution=$(echo "$activeOutput2" | cut -d '(' -f1 | rev | cut -d ' ' -f2 | rev | cut -d '+' -f1)

activeOutput1Primary=$(echo "$activeOutput1" | grep "primary")
activeOutput2Primary=$(echo "$activeOutput2" | grep "primary")

if [ "$activeOutput1Primary" != '' ]; then
    activeOutput1Primary="primary"
    activeOutput2Primary="secondary"
else
    activeOutput1Primary="secondary"
    activeOutput2Primary="primary"
fi

activeOutput1=$(echo -e "$activeOutput1" | cut -d ' ' -f1) # Grep the name of the first output
activeOutput2=$(echo -e "$activeOutput2" | cut -d ' ' -f1)

outputResolution=$(xrandr | grep \+ | grep -v "connected" | cut -d ' ' -f4) # Grep the resolution to the output active

activeOutput1MaxResolution=$(echo -e "$outputResolution" | sed -n '1p') # Grep the maximum resolution of the first output
activeOutput2MaxResolution=$(echo -e "$outputResolution" | sed -n '2p')

printTrace() {
    echo -e "\t|--------|------------|----------------|-----------|"
}

printTrace2() {
    echo -e "\t+--------------------------------------------------+"
}

printTrace2
echo -e "\t| Output | Status     | Max Resolution | Order     |"
printTrace
printf "\t| %-7s" "$activeOutput1"

if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
    printf "| %-11s" "$activeOutput1Resolution"
else
    printf "| %-11s" "Not active"
fi
printf "| %-15s" "$activeOutput1MaxResolution"
printf "| %-10s|\n" "$activeOutput1Primary"

if [ "$activeOutput2" != '' ]; then
    printTrace
    printf "\t| %-7s" "$activeOutput2"

    if echo "$activeOutput2Resolution" | grep -q "[[:digit:]]"; then
        printf "| %-11s" "$activeOutput2Resolution"
    else
        printf "| %-11s" "Not active"
    fi

    printf "| %-15s" "$activeOutput2MaxResolution"
    printf "| %-10s|\n" "$activeOutput2Primary"
else
    printTrace2

    echo -e "\n Only one output (\"$activeOutput1\") connected.\n Just setting to max resolution!\n"
    notify-send "Only one output (\"$activeOutput1\") connected." "Just setting to max resolution!" -i "preferences-desktop-wallpaper"
    xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary

    exit 0
fi
printTrace2

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
optionTmp3=" 3 - $activeOutput1 and $activeOutput2 $maximumEqualResolution (mirror - maximumEqualResolution)"
optionTmp4=" 4 - $activeOutput1 and $activeOutput2 1024x768 (mirror)"
optionTmp5=" 5 - $activeOutput1 $activeOutput1MaxResolution (primary) left-of $activeOutput2 $activeOutput2MaxResolution"
optionTmp6=" 6 - $activeOutput1 $activeOutput1MaxResolution right-of $activeOutput2 $activeOutput2MaxResolution (primary)"
optionTmp7=" 7 - $activeOutput1 off"
optionTmp8=" 8 - $activeOutput2 off"
optionTmpc=" c - Set ($activeOutput1 $activeOutput1MaxResolution) or ($activeOutput2 $activeOutput2MaxResolution) in turn"
optionTmpp=" p - Set ($activeOutput1 1024x768) or ($activeOutput2 1024x768) in turn"
optionTmp0=" 0 - Other options"
optionTmpf=" f - Finish"

if [ "$optionSelected" == '' ]; then
    echo -e "\n$optionTmp1"
    echo "$optionTmp2"
    echo "$optionTmp3"
    echo "$optionTmp4"
    echo "$optionTmp5"
    echo "$optionTmp6"
    echo "$optionTmp7"
    echo "$optionTmp8"
    echo "$optionTmpc"
    echo "$optionTmpp"
    echo "$optionTmp0"
    echo "$optionTmpf"

    echo -en "\nWith option you wish?: "
    read -r optionSelected

    if [ "$optionSelected" == '' ]; then
        echo -e "\n\tError: You need select one of the option listed\n"
        exit 1
    fi
fi

justFinish() {
    if [ "$1" == 'f' ]; then
        echo -e "\nJust finish\n"
        exit 0
    fi
}

justFinish "$optionSelected"

case $optionSelected in
    5 | 6 | 0 )
        # "$activeOutput1" part resolution
        activeOutput1MaxResolution_Part1=$(echo "$activeOutput1MaxResolution" | cut -d 'x' -f1)
        activeOutput1MaxResolution_Part2=$(echo "$activeOutput1MaxResolution" | cut -d 'x' -f2)

        # "$activeOutput2" part resolution
        activeOutput2MaxResolution_Part1=$(echo "$activeOutput2MaxResolution" | cut -d 'x' -f1)
        activeOutput2MaxResolution_Part2=$(echo "$activeOutput2MaxResolution" | cut -d 'x' -f2)

        # Diff "$activeOutput2"_p2 - "$activeOutput1"_p2
        diffResolutionPart2=$(echo "$activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2" | bc)

        if [ "$1" == "test" ]; then # Test propose
            echo -e "\n$activeOutput1: $activeOutput1MaxResolution_Part1 x $activeOutput1MaxResolution_Part2 - $activeOutput1Primary"
            echo "$activeOutput2: $activeOutput2MaxResolution_Part1 x $activeOutput2MaxResolution_Part2 - $activeOutput2Primary"
            echo "Diff_part2: ($activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2) = $diffResolutionPart2"
        fi
esac

if [ "$optionSelected" == 'c' ]; then
    echo -e "\n$optionTmpc"
    if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
        optionSelected=2
    else
        optionSelected=1
    fi
fi

case $optionSelected in
    'p' )
        echo -e "\n$optionTmpp\n"
        if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
            xrandr --output "$activeOutput2" --mode 1024x768
            xrandr --output "$activeOutput1" --off
        else
            xrandr --output "$activeOutput1" --mode 1024x768
            xrandr --output "$activeOutput2" --off
        fi
        ;;
    1 )
        echo -e "\n$optionTmp1\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary
        xrandr --output "$activeOutput2" --off
        ;;
    2 )
        echo -e "\n$optionTmp2\n"
        xrandr --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --primary
        xrandr --output "$activeOutput1" --off
        ;;
    3 )
        echo -e "\n$optionTmp3\n"
        xrandr --output "$activeOutput1" --mode "$maximumEqualResolution"
        xrandr --output "$activeOutput2" --mode "$maximumEqualResolution" --same-as "$activeOutput1"
        ;;
    4 )
        echo -e "\n$optionTmp4\n"
        xrandr --output "$activeOutput1" --mode 1024x768
        xrandr --output "$activeOutput2" --mode 1024x768 --same-as "$activeOutput1"
        ;;
    5 )
        echo -e "\n$optionTmp5\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --primary --pos "0x$diffResolutionPart2" --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --pos "${activeOutput1MaxResolution_Part1}x0"
        ;;
    6 )
        echo -e "\n$optionTmp6\n"
        xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution" --pos "${activeOutput2MaxResolution_Part1}x$diffResolutionPart2" --output "$activeOutput2" --mode "$activeOutput2MaxResolution" --primary --pos 0x0
        ;;
    7 )
        echo -e "\n$optionTmp7\n"
        if echo "$activeOutput2Resolution" | grep -q "[[:digit:]]"; then
            xrandr --output "$activeOutput1" --off
        else
            echo -e "\n\tError: $activeOutput2 is off"
            exit 1
        fi
        ;;
    8 )
        echo -e "\n$optionTmp8\n"
        if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
            xrandr --output "$activeOutput2" --off
        else
            echo -e "\n\tError: $activeOutput1 is off"
            exit 1
        fi
        ;;
    0 )
        echo -e "\n$optionTmp0"
        optionSelected=$optionSelectedTmp

        optionTmp9=" 9 - $activeOutput1 left-of $activeOutput2"
        optionTmp10="10 - $activeOutput1 right-of $activeOutput2"
        optionTmp11="11 - $activeOutput1 above-of $activeOutput2"
        optionTmp12="12 - $activeOutput1 below-of $activeOutput2"
        optionTmp13="13 - $activeOutput1 primary"
        optionTmp14="14 - $activeOutput2 primary"

        if [ "$optionSelected" == '' ]; then
            echo -e "\n$optionTmp9"
            echo "$optionTmp10"
            echo "$optionTmp11"
            echo "$optionTmp12"
            echo "$optionTmp13"
            echo "$optionTmp14"
            echo "$optionTmpf"

            echo -en "\nWith option you wish?: "
            read -r optionSelected

            if [ "$optionSelected" == '' ]; then
                echo -e "\n\tError: You need select one of the option listed\n"
                exit 1
            fi
        fi

        justFinish "$optionSelected"

        activeOutput1MaxResolution_actual=$(xrandr | grep "$activeOutput1" | sed 's/ primary//' | cut -d " " -f3 | cut -d "+" -f1)
        activeOutput2MaxResolution_actual=$(xrandr | grep "$activeOutput2" | sed 's/ primary//' | cut -d " " -f3 | cut -d "+" -f1)

        if [ "$1" == "test" ]; then ## Test propose
            echo -e "\n$activeOutput1: $activeOutput1MaxResolution_actual"
            echo "$activeOutput2: $activeOutput2MaxResolution_actual"
        fi

        if echo "$activeOutput1MaxResolution_actual" | grep -qv "[[:digit:]]"; then # Test if $activeOutput1 is ative
            echo -e "\n\tError: $activeOutput1 is not active\n"
            activeOutputNotAtive=1
        else
            if echo "$activeOutput2MaxResolution_actual" | grep -qv "[[:digit:]]"; then # Test if $activeOutput2 is ative
                echo -e "\n\tError: $activeOutput2 is not active\n"
                activeOutputNotAtive=1
            fi
        fi

        if [ "$activeOutputNotAtive" == 1 ]; then
            echo -n "(1) Set the maximum resolution for both and continue or (2) Just terminate. What you want?: "
            read -r continueOrNot

            if [ "$continueOrNot" == 1 ]; then # Set the maximum resolution for both and continue
                xrandr --output "$activeOutput1" --mode "$activeOutput1MaxResolution"
                xrandr --output "$activeOutput2" --mode "$activeOutput2MaxResolution"
            else # Just terminate
                justFinish 'f'
            fi
        fi

        if [ "$1" == "test" ]; then # Test propose
            echo -e "\n$activeOutput1: $activeOutput1MaxResolution_Part1 x $activeOutput1MaxResolution_Part2"
            echo "$activeOutput2: $activeOutput2MaxResolution_Part1 x $activeOutput2MaxResolution_Part2"
            echo "Diff_part2: ($activeOutput2MaxResolution_Part2 - $activeOutput1MaxResolution_Part2) = $diffResolutionPart2"
        fi

        case $optionSelected in
            9 )
                echo -e "\n$optionTmp9\n"
                xrandr --output "$activeOutput1" --pos "0x$diffResolutionPart2" --output "$activeOutput2" --pos "${activeOutput1MaxResolution_Part1}x0"
                ;;
            10 )
                echo -e "\n$optionTmp10\n"
                xrandr --output "$activeOutput1" --pos "${activeOutput2MaxResolution_Part1}x$diffResolutionPart2" --output "$activeOutput2" --pos 0x0
                ;;
            11 )
                echo -e "\n$optionTmp11\n"
                xrandr --output "$activeOutput1" --above "$activeOutput2"
                ;;
            12 )
                echo -e "\n$optionTmp12\n"
                xrandr --output "$activeOutput1" --below "$activeOutput2"
                ;;
            13 )
                echo -e "\n$optionTmp13\n"
                xrandr --output "$activeOutput1" --primary
                ;;
            14 )
                echo -e "\n$optionTmp14\n"
                xrandr --output "$activeOutput2" --primary
                ;;
            * )
                echo -e "\n\tError: The option \"$optionSelected\" is not recognized\n"
                exit 1
        esac
        ;;
    * )
        echo -e "\n\tError: The option \"$optionSelected\" is not recognized\n"
        exit 1
esac

if [ "$resolutionOk" == '' ]; then
    echo -n "Resolution changed. Everything OK? (y)es or (n)o (hit enter to no): "
    read -t 10 -r resolutionOk
fi

if [ "$resolutionOk" == '' ] || [ "$resolutionOk" = 'n' ]; then
    if echo "$activeOutput1Resolution" | grep -q "[[:digit:]]"; then
        xrandr --output "$activeOutput1" --mode "$activeOutput1Resolution"
    else
        xrandr --output "$activeOutput1" --off
    fi

    if echo "$activeOutput2Resolution" | grep -q "[[:digit:]]"; then
        xrandr --output "$activeOutput2" --mode "$activeOutput2Resolution"
    else
        xrandr --output "$activeOutput2" --off
    fi

    if [ "$activeOutput1Primary" != '' ]; then
        xrandr --output "$activeOutput1" --primary
    else
        xrandr --output "$activeOutput2" --primary
    fi
fi

if [ "$notificationOff" != 1 ]; then
    configurationSelected="optionTmp$optionSelected"
    notify-send "Monitor configuration changed" "${!configurationSelected}" -i "preferences-desktop-wallpaper"
fi
