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
# https://berseck.wordpress.com/2010/09/28/transformar-utf-8-para-acentos-iso-com-php/comment-page-1/
# https://wallacesilva.com/blog/2016/12/converter-para-utf-8-caracteres-iso-em-php/
# https://www.i18nqa.com/debug/utf8-debug.html
#
# Online
# https://onlineutf8tools.com/convert-ascii-to-utf8
#
# Script: Converte erros comuns de acentos Latini para UFT-8
#
# Last update: 11/08/2020
#
fileName=$1

if [ "$fileName" == '' ]; then
    echo -e "\\nError: Need to test if pass file as parameter to work\\n"
    exit 1
fi

fileNameTmp=$(echo "$fileName" | rev | cut -d "." -f2- | rev)
fileExtension=$(echo "$fileName" | rev | cut -d "." -f1 | rev)

cat "$fileName" | sed '
s/Ã¡/á/g
s/Ã /à/g
s/Ã¢/â/g
s/Ã£/ã/g
s/Ã¤/ä/g

s/Ã©/é/g
s/Ã¨/è/g
s/Ãª/ê/g
s/Ã«/ë/g

s/Ã­/í/g
s/Ã¬/ì/g
s/Ã®/î/g
s/Ã¯/ï/g

s/Ã³/ó/g
s/Ã²/ò/g
s/Ã´/ô/g
s/Ãµ/õ/g
s/Ã¶/ö/g

s/Ãº/ú/g
s/Ã¹/ù/g
s/Ã»/û/g
s/Ã¼/ü/g

s/Ã§/ç/g

s/Ã/Á/g
s/Ã€/À/g
s/Ã‚/Â/g
s/Ãƒ/Ã/g
s/Ã„/Ä/g

s/Ã‰/É/g
s/Ãˆ/È/g
s/ÃŠ/Ê/g
s/Ã‹/Ë/g

s/Ã/Í/g
s/ÃŒ/Ì/g
s/ÃŽ/Î/g
s/Ã/Ï/g

s/Ã“/Ó/g
s/Ã’/Ò/g
s/Ã”/Ô/g
s/Ã•/Õ/g
s/Ã–/Ö/g

s/Ãš/Ú/g
s/Ã™/Ù/g
s/Ã›/Û/g
s/Ãœ/Ü/g

s/Ã‡/Ç/g' > "${fileNameTmp}_c.$fileExtension"

echo -e "\\nFile converted: ${fileNameTmp}_c.$fileExtension\\n"
