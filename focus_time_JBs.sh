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
# Script: Focus - warning you about a $timeToFocus in work and $timeToRest min of rest
# Tip: Pass the time to the Script (timeToFocus and timeToRest)
#
# Last update: 03/11/2022
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
sleep "$timeToRest"

echo "Break End ... $(date)"
echo "Break End ... $(echo; date)" > /dev/pts/0
