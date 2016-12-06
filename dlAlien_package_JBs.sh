#!/bin/bash
#
# Autor= João Batista Ribeiro
# Bugs, Agradecimentos, Criticas "construtivas"
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
# Script: Download files/packages from one mirror with MD5
#
# Last update: 28/11/2016
#
case "$( uname -m )" in
    i?86) archDL=x86 ;;
    *) archDL=$( uname -m ) ;;
esac

echo -n "Type the path/program that want download: "
read pathDl

mirrorStart="http://bear.alienbase.nl/mirrors/people/alien/sbrepos"
slackVersion="14.2"

mirrorDl="$mirrorStart/$slackVersion/$archDL"

wget "$mirrorDl/CHECKSUMS.md5" -O CHECKSUMS.md5

runFile=`cat CHECKSUMS.md5 | grep ".*$pathDl.*" | cut -d '.' -f2-`
rm CHECKSUMS.md5

mkdir $pathDl-new
cd $pathDl-new

for fileGrep in `echo -e "$runFile"`; do
    wget -c $mirrorDl/$fileGrep
done

echo -e "List of files downloaded:\n\n`tree --noreport`\n"
