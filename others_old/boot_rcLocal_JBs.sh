#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Este programa é um software livre: você pode redistribuí-lo e/ou
# modificá-lo sob os termos da Licença Pública Geral GNU (GPL)
# conforme publicada pela Free Software Foundation, tanto a versão 3
# da licença, como (a seu critério) qualquer versão posterior.
#
# Este programa é distribuído na esperança de que seja útil,
# mas SEM NENHUMA GARANTIA; nem mesmo a garantia implícita de
# COMERCIABILIDADE ou ADEQUAÇÃO A UM PROPÓSITO ESPECÍFICO.
# Consulte a Licença Pública Geral do GNU para mais detalhes.
#
# Script: Script with common commands executed in boot (/etc/rc.d/rc.local)
# Adding: echo "/usr/bin/boot_rcLocal_JBs.sh" >> /etc/rc.d/rc.local
# Add performance at the command to set CPU frequency as performance
#
# Last update: 20/06/2018
#
## Set brightness to 1%
#echo 0 > /sys/class/backlight/acpi_video0/brightness
## or
#echo 50 > /sys/class/backlight/intel_backlight/brightness
## or
/usr/bin/usual_JBs.sh brigh-1 1 > /dev/null

## Set unicode
unicode_start

## Set CPU performance. See the actual governor # cpufreq-info
## http://docs.slackware.com/howtos:hardware:cpu_frequency_scaling
## See the count of CPU you have #cpufreq-info | grep "analyzing CPU"
if [ "$1" == "performance" ]; then
    countCPU=$(cpufreq-info | grep -c "analyzing CPU")
    i='0'
    while [ "$i" -lt "$countCPU" ]; do
        cpufreq-set --cpu $i --governor performance
        echo "cpufreq-set --cpu $i --governor performance"
        ((i++))
    done
fi

## Keep the brightness >= %1
#/usr/bin/brightness_min_set_JBs.sh &

echo -e "\\n\\t-----------------\\n\\t| Happy Day :-) |"
echo -e "\\t-----------------\\n\\t$(date)\\n"
