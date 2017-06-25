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
# Script: Set the computer (notebook) to use less energy/battery as possible
# Mute the sound, brightness in 1% and CPU frequency in minimum available
# If CPU frequency is already in powersave, will set to performance
#
# Last update: 25/06/2017
#
if [ "$(whoami)" != "root" ]; then
    echo -e "\nNeed to be superuser (root)\nExiting"
else
    if [ "$1" == "boot" ]; then # Add in the /etc/rc.d/rc.local = /usr/bin/powersave_JBs.sh boot
        optionRun='1' # Will make all change
    elif cpufreq-info | grep "The governor" | head -n 1 | cut -d '"' -f2  | grep -q "performance"; then
        optionRun='1' # Will make all change
    else
        optionRun='2' # Will set cpu_frequency_scaling to performance
    fi

    cpu_frequency_scaling () {
        governorMode=$1

        ## Set CPU performance. See the actual governor # cpufreq-info
        ## http://docs.slackware.com/howtos:hardware:cpu_frequency_scaling

        countCPU=$(cpufreq-info | grep -c "analyzing CPU")
        i='0'
        while [ "$i" -lt "$countCPU" ]; do
            cpufreq-set --cpu $i --governor "$governorMode"
            ((i++))
        done
        echo -e "CPU frequency: $governorMode"
    }

    echo -e "\n    # Changes made #"

    if [ "$optionRun" == '1' ]; then
        echo "Brightness: 1%"
        /usr/bin/usual_JBs.sh brigh-1 1 > /dev/null # Set brightness to 1%

        cpu_frequency_scaling powersave # This sets CPU frequency to the minimum available

        echo "Disabling all wireless devices"
        rfkill block all
        # More info: https://wireless.wiki.kernel.org/en/users/documentation/rfkill

        echo -e "\npowertop --auto-tune"
        powertop --auto-tune # Tune to use less power with powertop
        # More info https://wiki.archlinux.org/index.php/powertop
        echo

        ## Remove modules from Linux kernel
        # List modules load an information (if has one)
        #for value in $(lsmod | grep  '0$' | cut -d ' ' -f1); do echo -e "\n$value"; modinfo -d $value; done

        # Bluetooth
        modulesToRemove="bluetooth"

        # USB + Realtek USB Card Reader
        modulesToRemove+=" uas ums_realtek usb_storage ehci_pci"

        # Joystick
        modulesToRemove+=" joydev"

        # GamePad + Hid
        modulesToRemove+=" hid_multitouch hid_microsoft hid_lenovo hid_logitech_hidpp hid_logitech_dj hid_logitech hid_cherry hid_generic"
        modulesToRemove+=" i2c_hid usbhid uhci_hcd ohci_pci xhci_pci"

        # WebCam - USB Video Class
        modulesToRemove+=" uvcvideo"

        # KVM
        modulesToRemove+=" kvm_intel kvm"

        echo -n "# Removing modules: "
        modulePrintCount='0'
        for value in $modulesToRemove; do # Remove modules
            if [ "$(echo "$modulePrintCount%8" | bc)" == '0' ]; then
                echo # Create a new line after print 8 modules
            fi
            ((modulePrintCount++))

            echo -n " $value"
            rmmod "$value"
        done

        muteSound () {
            continue='0'
            while [ "$continue" != '1' ]; do
                if ps -ef | grep -q "X"; then
                    userNormal=$(w | grep -vE "root|USER|load average" | awk '{print $1}' | tail -n 1) # Grep one normal user

                    if [ "$userNormal" != '' ]; then
                        export soundDevice='0' # Device number

                        echo -e "Volume: muted\n\n"
                        su "$userNormal" -c "pactl set-sink-mute $soundDevice 1 > /dev/null" # Mute the device

                        continue='1'
                    fi
                fi

                if [ "$userNormal" != '1' ]; then
                    sleep 3s # Wait 3 s to try again
                fi
            done
        }
        muteSound &

    elif [ "$optionRun" == '2' ]; then
        cpu_frequency_scaling performance # This sets CPU frequency to the maximum available

        #rfkill unblock all # Enabling all wireless devices
        if rfkill list wifi | grep -q "Soft blocked: yes"; then
            echo "Enabling Wi-Fi devices"
            rfkill unblock wifi
        fi

        # See modules loaded: lsmod
        if lsmod | grep -q "ehci_pci"; then
            echo "Enable USB device"
            modprobe ehci_pci

            sleep 3 # Wait for load all dependencies
            rmmod ums_realtek # Realtek USB Card Reader
            rmmod joydev # Joystick
        fi
    fi
fi
echo
