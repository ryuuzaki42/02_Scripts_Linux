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
# Script: remove uppercase in files and folders names based in a patthern
#
# Last update: 19/06/2023
#
# Be careful: Can move folders to inside another if the has the name of the another
#
IFS=$(echo -en "\n\b") # Change the Internal Field Separator (IFS) to "\n\b"
equalPart=$1

if [ "$equalPart" == '' ]; then
    echo -e "\n# Error: Need to pass parameters to remove or change in the name of the files\n"
    echo "Example 1: $(basename "$0") \"FILEWITHUPPERCASE\""
    echo "mv \"FILEWITHUPPERCASE.EXT\" -> \"filewithuppercase.ext\""
    echo -e "\nExample 2: $(basename "$0") \"txt\""
    echo "mv \"FILEWITHUPPERCASE1.txt\" -> \"filewithuppercase1.txt\""
    echo -e "mv \"FILEWITHUPPERCASE2.txt\" -> \"filewithuppercase2.txt\"\n"
    exit
fi

# file2=${file,,}
# ^ first character of the string to uppercase
# ^^ whole string to the uppercase
# , first character of the string to lowercase
# ,, whole string to the lowercase

echo -e "\nRemove uppercase in \"*$equalPart*\" files:\n"
for file in *"$equalPart"*; do
    file2=${file,,}
    printf "%-80s -> $file2\n" "$file"
done

echo
read -rp "(y)es or (n)o - (hit enter to no): " continueOrNot
if [ "$continueOrNot" == 'y' ]; then
    echo
    for file in *"$equalPart"*; do
        file2=${file,,}
        mv -v "$file" "$file2"
    done
else
    echo -e "\nJust exiting"
fi
echo
