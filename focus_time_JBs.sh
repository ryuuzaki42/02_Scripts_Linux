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
# Script: Focus - warning you about a $timeToFocus in work and $timeToRest min of rest
# Tip: Pass the time to the Script (timeToFocus and timeToRest)
#
# Last update: 03/04/2021
#
timeToFocus=$1
timeToRest=$2

if echo "$timeToFocus" | grep -q -v "[[:digit:]]"; then
    timeToFocus='60m'
fi

if echo "$timeToRest" | grep -q -v "[[:digit:]]"; then
    timeToRest='10m'
fi

echo "Begin focus of $timeToFocus - $(date)"
echo "Begin focus of $timeToFocus $(echo; date)" > /dev/pts/0

echo "sleep $timeToFocus"
sleep "$timeToFocus"

echo "Break of $timeToRest - $(date)"
echo "Break of $timeToRest $(echo; date)" > /dev/pts/0

echo "sleep $timeToRest"
sleep $timeToRest

echo "Break End ... $(date)"
echo "Break End ... $(echo; date)" > /dev/pts/0
