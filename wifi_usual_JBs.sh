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
# Script: funções comum do dia a dia
#
# Last update: 21/03/2018
#
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

notUseColor() {
    unset BLACK RED GREEN NC BLUE PINK CYAN WHITE
}

colorPrint=$1
if [ "$colorPrint" == "noColor" ]; then
    echo -e "\\nColors disabled"
    shift
else # Some colors for script output - Make it easier to follow
    useColor
    colorPrint=''
fi

notPrintHeaderHeader=$1
if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE        #___ Script to usual commands ___#$NC\\n"
else
    shift
fi

testColorInput=$1
if [ "$testColorInput" == "testColor" ]; then
    echo -e "\\n    Test colors: $RED RED $WHITE WHITE $PINK PINK $BLACK BLACK $BLUE BLUE $GREEN GREEN $CYAN CYAN $NC NC\\n"
    shift
fi

loadDevWirelessInterface() {
    devInterface=$1

    if [ "$devInterface" == '' ]; then
        devInterface="wlan0"
    fi

    echo -e "\\nWorking with the dev interface: $devInterface"
    echo -e "You can pass other interface as a parameter\\n"
}

optionInput=$1
case $optionInput in
    "ap-info" )
        echo -e "$CYAN# Show information about the AP connected #$NC"

        loadDevWirelessInterface "$2"

        echo -e "\\n/usr/sbin/iw dev $devInterface link:"
        /usr/sbin/iw dev $devInterface link

        echo -e "\\n/sbin/iwconfig $devInterface:"
        /sbin/iwconfig $devInterface
        ;;
    "--help" | "-h" | "help" | 'h' | '' | 'w' )
        if [ "$optionInput" == '' ] || [ "$optionInput" == 'w' ]; then # whiptailMenu()
            notUseColor
        fi

        # Options text
        optionVector=("ap-info      " "   - Show information about the AP connected"
        "cn-wifi      " "$RED * - Connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
        "create-wifi  " "$RED * - Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf)"
        "dc-wifi      " "$RED * - Disconnect to one Wi-Fi network"
        "help         " "   - Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h')"
        "l-iw         " "$RED * - List the Wi-Fi AP around, with iw (show WPS and more infos)"
        "l-iwlist     " "   - List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos)"
        "nm-list      " "$PINK + - List the Wi-Fi AP around with the nmcli from NetworkManager"
        "w            " "   - Menu with whiptail, where you can call the options above (the same result with 'w' or '')")

        if [ "$colorPrint" == '' ]; then # set useColor on again if the use not pass "noColor"
            useColor
        fi

        case $optionInput in
            "--help" | "-h" | "help" | 'h' )
                help() {
                    echo -e "$CYAN# Show this help message (the same result with \"help\", \"--help\", \"-h\" or 'h') $NC"
                    echo -e "$CYAN\\nOptions:\\n$RED    Obs$CYAN:$RED * root required,$PINK + NetworkManager required,$BLUE = X server required$CYAN\\n"

                    countOption='0'
                    optionVectorSize=${#optionVector[*]}
                    while [ "$countOption" -lt "$optionVectorSize" ]; do
                        echo -e "    $GREEN${optionVector[$countOption]}$CYAN ${optionVector[$countOption+1]}$NC"

                        countOption=$((countOption + 2))
                    done
                }

                help
                ;;
            '' | 'w' )
                whiptailMenu() {
                    echo -e "$CYAN# Menu with whiptail, where you can call the options above (the same result with 'w' or '') #$NC\\n"
                    eval "$(resize)"

                    heightWhiptail=$((LINES - 5))
                    widthWhiptail=$((COLUMNS - 5))

                    if [ "$LINES" -lt "16" ]; then
                        echo -e "$RED\\nTerminal with very small size. Use one terminal with at least 16 columns (actual size line: $LINES columns: $COLUMNS)$NC"
                        echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader --help$CYAN\\n" | sed 's/  / /g'
                        $0 $colorPrint notPrintHeader --help
                    else
                        heightMenuBoxWhiptail=$((LINES - 15))

                        #whiptail --title "<título da caixa de menu>" --menu "<texto a ser exibido>" <altura> <largura> <altura da caixa de menu> \
                        #[ <tag> <item> ] [ <tag> <item> ] [ <tag> <item> ]

                        itemSelected=$(whiptail --title "#___ Script to usual commands ___#" --menu "Obs: * root required, + NetworkManager required, = X server required

                        Options:" $heightWhiptail $widthWhiptail $heightMenuBoxWhiptail \
                        "${optionVector[0]}" "${optionVector[1]}" \
                        "${optionVector[2]}" "${optionVector[3]}" \
                        "${optionVector[4]}" "${optionVector[5]}" \
                        "${optionVector[6]}" "${optionVector[7]}" \
                        "${optionVector[8]}" "${optionVector[9]}" \
                        "${optionVector[10]}" "${optionVector[11]}" \
                        "${optionVector[12]}" "${optionVector[13]}" \
                        "${optionVector[14]}" "${optionVector[15]}" 3>&1 1>&2 2>&3)

                        if [ "$itemSelected" != '' ]; then
                            itemSelected=${itemSelected// /} # Remove space in the end of selected item
                            echo -e "$GREEN\\nRunning: $0 $colorPrint notPrintHeader $itemSelected ${*} $CYAN\\n" | sed 's/  / /g'
                            $0 $colorPrint notPrintHeader "$itemSelected" "${*}"
                        fi
                    fi
                }

                whiptailMenu "${*:2}"
                ;;
        esac
        ;;
    "create-wifi" )
        echo -e "$CYAN# Create configuration to connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\\n"
        createWifiConfig() {
            echo -en "\\nName of the network (SSID): "
            read -r netSSID

            echo -en "\\nPassword of this network: "
            read -r -s netPassword

            wpa_passphrase "$netSSID" "$netPassword" | grep -v "#psk" >> /etc/wpa_supplicant.conf
        }

        export -f createWifiConfig
        if [ "$(whoami)" != "root" ]; then
            echo -e "$CYAN\\nInsert the root Password to continue$NC"
        fi

        su root -c 'createWifiConfig' # In this case without the hyphen (su - root -c 'command') to no change the environment variables
        ;;
    "cn-wifi" )
        echo -e "$CYAN# Connect to Wi-Fi network (in /etc/wpa_supplicant.conf) #$NC\\n"
        if pgrep -f "NetworkManager" > /dev/null; then # Test if NetworkManager is running
            echo -e "$RED\\nError: NetworkManager is running, please kill him with: killall NetworkManager$NC"
        else
            if [ "$LOGNAME" != "root" ]; then
                echo -e "$RED\\nError: Execute as root user$NC"
            else
                killall wpa_supplicant # kill the previous wpa_supplicant "configuration"

                networkConfigAvailable=$(grep "ssid" < /etc/wpa_supplicant.conf)
                if [ "$networkConfigAvailable" == '' ]; then
                    echo -e "$RED\\nError: Not find configuration of anyone network (in /etc/wpa_supplicant.conf).\\n Try: $0 create-wifi$NC"
                else
                    echo "Choose one network to connect:"
                    grep "ssid" < /etc/wpa_supplicant.conf
                    echo -n "Network name: "
                    read -r networkName

                    #sed -n '/Beginning of block/!b;:a;/End of block/!{$!{N;ba}};{/some_pattern/p}' fileName # sed in block text
                    wpaConf=$(sed -n '/network/!b;:a;/}/!{$!{N;ba}};{/'"$networkName"'/p}' /etc/wpa_supplicant.conf)

                    if [ "$wpaConf" == '' ]; then
                        echo -e "$RED\\nError: Not find configuration to network '$networkName' (in /etc/wpa_supplicant.conf).\\n Try: $0 create-wifi$NC"
                    else
                        TMPFILE=$(mktemp) # Create a tmp file
                        grep -v -E "{|}|ssid|psk" < /etc/wpa_supplicant.conf > "$TMPFILE"

                        echo -e "$wpaConf" >> "$TMPFILE" # Save the configuration of the network on this file

                        echo -e "\\n########### Network configuration ####################"
                        cat "$TMPFILE"
                        echo -e "######################################################"

                        #wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf -d -B wext # Normal command

                        loadDevWirelessInterface "$2"

                        wpa_supplicant -i $devInterface -c "$TMPFILE" -d -B wext # Connect with the network using the tmp file

                        rm "$TMPFILE" # Delete the tmp file

                        dhclient $devInterface # Get IP

                        iw dev $devInterface link # Show connection status
                    fi
                fi
            fi
        fi
        ;;
    "dc-wifi" )
        echo -e "$CYAN# Disconnect of one Wi-Fi network #$NC\\n"

        loadDevWirelessInterface "$2"

        su - root -c "dhclient -r $devInterface
        ifconfig $devInterface down
        iw dev $devInterface link"
        ;;
    "l-iw" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iw (show WPS and more infos) #$NC\\n"

        loadDevWirelessInterface "$2"

        su - root -c "/usr/sbin/iw dev $devInterface scan | grep -E '$devInterface|SSID|signal|WPA|WEP|WPS|Authentication|WPA2|: channel'"
        ;;
    "l-iwlist" )
        echo -e "$CYAN# List the Wi-Fi AP around, with iwlist (show WPA/2 and more infos) #$NC\\n"

        loadDevWirelessInterface "$2"

        /sbin/iwlist $devInterface scan | grep -E "Address|ESSID|Frequency|Signal|WPA|WPA2|Encryption|Mode|PSK|Authentication"
        ;;
    "nm-list" )
        echo -e "$CYAN# List the Wi-Fi AP around with the nmcli from NetworkManager #$NC\\n"
        nmcli device wifi list
        ;;
    * )
        echo -e "\\n    $(basename "$0") - Error: Option \"$1\" not recognized"
        echo -e "    Try: $0 '--help'"
        ;;
esac

if [ "$notPrintHeaderHeader" != "notPrintHeader" ]; then
    echo -e "$BLUE\\n        #___ So Long, and Thanks for All the Fish ___#$NC"
else
    shift
fi
