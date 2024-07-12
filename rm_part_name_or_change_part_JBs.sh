#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# me envie um e-mail. Ficarei Grato!
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
# Script: remove one part of the name of files and folders based in a pattern
#
# Last update: 11/07/2024
#
IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
equal_Part_To_Remove=$1
part_To_Change=$2

help_message(){
    echo -e "\n # Remove one part of the name of files and folders based in a pattern #\n"
    echo -e " Example 1 - remove part of the name:\n$(basename "$0") \".720p. 10bit.WEBRip.2CH \""
    echo -e "  -> mv \"file.720p. 10bit.WEBRip.2CH .mkv\" -> \"file.mkv\"\n"
    echo -e " # Or with two values, to change the first by the second"
    echo -e " Example 2 - change part of the name:\n$(basename "$0") \"file2\" \"The movie\""
    echo -e "  -> mv \"file2.mkv\" -> \"The movie.mkv\"\n"
    echo -e "Obs.: run to all files/folder in the working directory, but not recursively\n"
}

if [ "$equal_Part_To_Remove" == '' ]; then
    echo -e "\n# Error: Need to pass parameters to remove or change in the name of the files"
    help_message
    exit 1
elif [ "$equal_Part_To_Remove" == '-h' ] || [ "$equal_Part_To_Remove" == '--help' ]; then
    help_message
    exit 0
fi

setFile2(){
    file=$1
    if [ "$part_To_Change" == '' ]; then
        file2=${file//$equal_Part_To_Remove/} # From "$file" remove "$equal_Part_To_Remove"
    else
        file2=${file//$equal_Part_To_Remove/$part_To_Change} # From "$file" change "$equal_Part_To_Remove" to "$part_To_Change"
    fi
}

echo -e "\nRemove \"$equal_Part_To_Remove\" in this files:\n"
for file in *"$equal_Part_To_Remove"*; do
    setFile2 "$file"
    printf "%-80s -> $file2\n" "$file"
done

echo
read -rp "(y)es or (n)o - (hit enter to no): " continueOrNot
if [ "$continueOrNot" == 'y' ]; then
    echo
    for file in *"$equal_Part_To_Remove"*; do
        setFile2 "$file"
        mv -v "$file" "$file2"
    done
else
    echo -e "\nJust exiting"
fi
echo
