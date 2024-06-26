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
# Script: remove accents in files and folders names based in a patthern
#
# Last update: 19/06/2023
#
IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
equalPart=$1

if [ "$equalPart" == '' ]; then
    echo -e "\n# Error: Need to pass parameters to remove or change in the name of the files"
    echo -e "\nExample: $(basename "$0") \"fíléWithàccents\""
    echo -e "mv \"fíléWithÀccents.ext\" -> \"fileWithAccents.ext\"\n"
    exit
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
