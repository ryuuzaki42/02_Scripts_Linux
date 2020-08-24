#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Críticas "construtivas"
# Mande me um e-mail. Ficarei Grato!
# e-mail: joao42lbatista@gmail.com
#
# Com contibuições de Rumbler Soppa (github.com/rumbler)
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
# Script: Change values in one subtitle like: 2 to 1, 3 to 2, 4 to 3, and so on
#
# Last update: 24/08/2020
#
fileToWork="a.srt"
fileToWork2="tmpFile.srt"

countLines=$(egrep "^[0-9]{1,4}" "$fileToWork" | tail -n 2 | head -n 1 | tr -dc '0-9')

cp "$fileToWork" "$fileToWork2"

fileMemory=$(cat "$fileToWork2")
i=1
for j in $(seq 2 $countLines); do
    echo "$j - $i"
    sed -i 's/'^''"$j"''$'/'"$i"'/g' $fileToWork2
    ((i++))
done 
