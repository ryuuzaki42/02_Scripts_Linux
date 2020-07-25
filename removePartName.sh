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
# Script: remove one parte in the files name.
#
# Last update: 25/07/2020
#
IFS=$(echo -en "\\n\\b") # Change the Internal Field Separator (IFS) to "\\n\\b"
equalPartToRemove=$1
set -e

if [ "$equalPartToRemove" == '' ]; then
    echo -e "\\nError: Need to pass the part to remove in the name of the files"
    echo -e "\\nExample: $(basename $0) \".720p. 10bit.WEBRip.2CH \""
    echo "mv \"file.720p. 10bit.WEBRip.2CH .mkv\" -> \"file.mkv\""
    exit
fi

echo -e "\\nRemover \"$equalPartToRemove\" in this files:"
for file in *$equalPartToRemove*; do
    file2=$(echo "$file" | sed 's/'"$equalPartToRemove"'//1')
    printf "%-80s -> %20s\n" "$file" "$file2"
done

read -p "(y)es or (n)o - hit enter to no): " continueOrNot
if [ "$continueOrNot" == 'y' ]; then
    echo
    for file in *$equalPartToRemove*; do
        file2=$(echo "$file" | sed 's/'"$equalPartToRemove"'//1')
        mv -v "$file" "$file2"
    done
else
    echo -e "\\nJust exiting\\n"
fi
