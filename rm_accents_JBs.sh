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
# Script: Remove accents in files and folders names based in a pattern
#
# Last update: 11/07/2024
#
echo -e "\n # Remove accents in files and folders names based in a pattern #"
IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
equalPart=$1

if [ "$equalPart" == '' ]; then
    echo -e "\n# Error: Need to pass a parameter of files or folders name to work with"
    echo -e "\n Example 1: $(basename "$0") \"fíléWithÀccents\""
    echo -e " -> mv \"fíléWithÀccents.ext\" -> \"fileWithAccents.ext\"\n"
    echo -e "\n Example 2: $(basename "$0") \"folderWithàccents\""
    echo -e " -> mv \"folderWithàccents\" -> \"folderWithaccents\"\n"
    echo -e "\nUse . to process all files in working directory or the first letter of a file/folder"
    exit 1
fi

removeAccents(){
    file2=$1

    file2=${file2//á/a}
    file2=${file2//é/e}
    file2=${file2//í/i}
    file2=${file2//ó/o}
    file2=${file2//ú/u}

    file2=${file2//Á/A}
    file2=${file2//É/E}
    file2=${file2//Í/I}
    file2=${file2//Ó/O}
    file2=${file2//Ú/U}

    file2=${file2//â/a}
    file2=${file2//ê/e}
    file2=${file2//ô/o}

    file2=${file2//Â/A}
    file2=${file2//Ê/E}
    file2=${file2//Ô/O}

    file2=${file2//ã/a}
    file2=${file2//Ã/A}

    file2=${file2//õ/o}
    file2=${file2//Õ/O}

    file2=${file2//à/a}
    file2=${file2//À/A}

    file2=${file2//ç/c}
    file2=${file2//Ç/C}

    file2=${file2//﻿/ } # Weird space
    file2=${file2//–/-}
}

echo -e "\nRemove accents in \"*$equalPart*\" files:\n"
for file in *"$equalPart"*; do
    removeAccents "$file"
    printf "%-80s -> $file2\n" "$file"
done

echo
read -rp "(y)es or (n)o - (hit enter to no): " continueOrNot
if [ "$continueOrNot" == 'y' ]; then
    echo
    for file in *"$equalPart"*; do
        removeAccents "$file"
        mv -v "$file" "$file2"
    done
else
    echo -e "\nJust exiting"
fi
echo
