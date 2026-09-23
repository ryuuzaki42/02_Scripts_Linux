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
# Script: Remove or replace part of files and folders names based on a pattern
#
# Last update: 11/07/2024
#
IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
equal_Part_To_Remove=$1
part_To_Change=$2

echo -e "\n # Remove or replace part of files and folders names based on a pattern #"

help_message(){
    echo -e "\nUsage: $(basename "$0") <pattern>"
    echo "       $(basename "$0") <old_text> <new_text>"

    echo -e "\n Example 1 - remove part of the name:\n$(basename "$0") \"_part. to remove \""
    echo -e "\n  -> mv \"file_part. to remove .txt\" -> \"file.txt\""

    echo -e "\n # Or with two values, to replace the first by the second"
    echo -e " Example 2 - replace part of the name:\n$(basename "$0") \"_old.part to-Remove\" \".new.part\""
    echo -e "\n  -> mv \"file_old.part to-Remove.txt\" -> \"file.new.part.txt\"\n"

    echo -e "Note: Applies to files/folders in the current directory only (non-recursive)\n"
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
