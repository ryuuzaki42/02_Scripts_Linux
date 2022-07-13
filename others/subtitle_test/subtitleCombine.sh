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
