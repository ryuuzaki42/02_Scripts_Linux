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
# Script: Convert common errors from ISO-8859-1 (ISO Latin 1) accents to UTF-8
#
# Last update: 19/06/2023
#
# Online: https://onlineutf8tools.com/convert-ascii-to-utf8
#
# More information:
# https://berseck.wordpress.com/2010/09/28/transformar-utf-8-para-acentos-iso-com-php/comment-page-1/
# https://wallacesilva.com/blog/2016/12/converter-para-utf-8-caracteres-iso-em-php/
# https://www.i18nqa.com/debug/utf8-debug.html
#
fileName=$1
if [ "$fileName" == '' ]; then
    echo -e "\nError: Need to test if pass file as parameter to work\n"
    exit 1
fi

codification=$(file "$fileName") # Get the codification of the file
if echo "$codification" | grep -q "UTF-8"; then # Check if codification is UTF-8
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

    echo -e "\nFile converted: ${fileNameTmp}_c.$fileExtension\n"
else
    echo -e "\nError: The file \"$fileName\" don't has codification UTF-8, first convert it to UTF-8 with \"codific_JBs.sh\" \"$fileName\"\n"
fi
