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
# Script: remove accents in the files name.
#
# Last update: 11/08/2020
#
IFS=$(echo -en "\\n\\b") # Change the Internal Field Separator (IFS) to "\\n\\b"
equalPart=$1

if [ "$equalPart" == '' ]; then
    echo -e "\\n# Error: Need to pass parameters to remove or change in the name of the files"
    echo -e "\\nExample: $(basename "$0") \"FILEWITHUPPERCASE\""
    echo -e "mv \"FILEWITHUPPERCASE.EXT\" -> \"filewithuppercase.ext\"\\n"
    exit
fi

removeAccents(){
    file2=$(echo $1 | tr '[:upper:]' '[:lower:]')
}

echo -e "\\nRemove uppercase in \"*$equalPart*\" files:\\n"
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
    echo -e "\\nJust exiting"
fi
echo
