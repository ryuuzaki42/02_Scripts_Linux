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
# Script: Test to combine to subtitle
# Última atualização: 13/07/2022
#

set -ex

fileATime=$1 # sub_en.srt
fileBText=$2 # sub_pt.srt

if [ "$fileATime" == '' ] || if [ "$fileBText" == '' ] ; then
    echo -e "\\n# Error: Need to pass parameters (files names) to work with"
    echo -e "\\nExample: $(basename "$0") sub_en.srt sub_pt.srt"
    exit 1
fi

tempFileA=$(mktemp)
tempFileB=$(mktemp)
tempResult=$(mktemp)

## Remove '\r' (return)
# useful in subtitles or text files to use with grep
sed -i 's/\r$//' $fileATime
sed -i 's/\r$//' $fileBText

grep -E "^[0-9]{2}:|^[0-9]{1,3}$|^$" $fileATime > $tempFileA # Get time and count
grep -Ev "^[0-9]{1,3}$|^[0-9]{2}:" $fileBText > $tempFileB # Get text

python3 subtitleCombineLines $tempFileA $tempFileB $tempResult

rm $tempFileA $tempFileB

mv $tempResult ./
mv $tempResult ${tempResult}.srt

echo "Save in file: $tempResult"
echo "Done"
