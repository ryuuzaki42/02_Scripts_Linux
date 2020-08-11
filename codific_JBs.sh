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
# Script: Convert text utf8 to iso-8859 and others
#
# Last update: 11/08/2020
#
help() {
    echo -e "\\nUse the file name (with extension) that want to convert"
    echo -e "Example: $(basename "$0") file.srt\\n"
    exit 0
}

if [ "$#" -ne '1' ]; then # Check if has passed the file name
    echo -e "\\n$(basename "$0"): Error - need the pass file name\\n"
    help
fi

case $1 in # case to call help
    '--help' | '-h')
        help
esac

fileName=$1
if [ ! -e "$fileName" ]; then
    echo -e "\\nThe file \"$fileName\" don't exist\\nTry \"$(basename "$0") -h\" or with another file\\n"
    exit 1
fi

fileName2Tmp=$(echo "$fileName" | rev | cut -d '.' -f2- | rev) # File name without extension
extension=$(echo "$fileName" | rev | cut -d '.' -f1 | rev) # Extension of the file

codification=$(file "$fileName") # Get the codification of the file

if echo "$codification" | grep -q "ISO-8859"; then # Check if codification is iso-8859
    codStart="iso-8859"
    codEnd="utf-8"
    fileName2="${fileName2Tmp}_${codEnd}.$extension"

    iconv -f iso-8859-1 -t utf-8//TRANSLIT "$fileName" > "$fileName2" # Convert file codification to utf-8 and save in another file
elif echo "$codification" | grep -q "UTF-8"; then # Check if codification is utf8
    codStart="utf-8"
    codEnd="iso-8859"
    fileName2="${fileName2Tmp}_${codEnd}.$extension"

    iconv -f utf-8 -t iso-8859-1//TRANSLIT "$fileName" > "$fileName2" # Convert file codification to iso-8859 and save in another file
elif echo "$codification" | grep -q "Non-ISO extended-ASCII text"; then # Check if codification is "Non-ISO extended-ASCII text"
    codStart="Non-ISO extended-ASCII text - maybe iso-8859-1"
    codEnd="utf-8"
    fileName2="${fileName2Tmp}_${codEnd}.$extension"

    iconv -f iso-8859-1 -t utf-8//TRANSLIT "$fileName" > "$fileName2" # Convert file codification to utf-8 and save in another file
else # In last case, if not one of the cod bellow, the script ends with error
    echo -e "\\n codification unknown\\n The file was not converted\\n"
    exit 1
fi

if [ "$?" -eq '1' ]; then
    echo -e "Error in the run of iconv\\nTry $(basename "$0") -h"
    exit 1
else
    echo -e "\\n## File has been converted with success ##\\n\"$fileName\" from $codStart to $codEnd"
    echo "\"$fileName\" -> \"$fileName2\""

    echo -en "\\nOverwrite the original file?\\n(y)es, (n)o (hit enter to no): "
    read -r answerOver
    if [ "$answerOver" == 'y' ]; then
        mv -v "$fileName2" "$fileName"
        echo -e "\\nThe file has been overwrite\\n"
    else
        echo -e "\\nThe file has not been overwrite\\n"
    fi
fi
