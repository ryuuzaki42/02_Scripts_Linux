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
# Script: remove one part in the files name.
#
# Last update: 07/08/2020
#
IFS=$(echo -en "\\n\\b") # Change the Internal Field Separator (IFS) to "\\n\\b"
equalPartToRemove=$1
partToChange=$2

if [ "$equalPartToRemove" == '' ]; then
    echo -e "\\n# Error: Need to pass parameters to remove or change in the name of the files"
    echo -e "\\nExample 1 (remove part of the name): $(basename "$0") \".720p. 10bit.WEBRip.2CH \""
    echo -e "mv \"file.720p. 10bit.WEBRip.2CH .mkv\" -> \"file.mkv\"\\n"
    echo -e "# Or two values, to change the first by the second"
    echo -e "\\nExample 2 (change part of the name): $(basename "$0") \"file2\" \"The movie\""
    echo -e "mv \"file2.mkv\" -> \"The movie.mkv\"\\n"
    exit
fi

setFile2(){
    file=$1
    if [ "$partToChange" == '' ]; then
        file2=${file//$equalPartToRemove/}
    else
        file2=${file//$equalPartToRemove/$partToChange}
    fi
}

echo -e "\\nRemove \"$equalPartToRemove\" in this files:\\n"
for file in *"$equalPartToRemove"*; do
    setFile2 "$file"
    printf "%-80s -> $file2\n" "$file"
done

echo
read -rp "(y)es or (n)o - (hit enter to no): " continueOrNot
if [ "$continueOrNot" == 'y' ]; then
    echo
    for file in *"$equalPartToRemove"*; do
        setFile2 "$file"
        mv -v "$file" "$file2"
    done
else
    echo -e "\\nJust exiting\\n"
fi
