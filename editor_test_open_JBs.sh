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
# Script: Checks the file size before opening it in a text editor
# Note: Files larger than 100 MiB will not be opened; a "file too large" warning will be shown instead
#
# Tip: Use the KDE menu (or other launchers) to change the command of the default editor,
# to run this script instead of the original editor
#
# Last update: 23/09/2026
#
# To use, set in icon command field:
# /usr/bin/editor_test_open_JBs.sh editor_name, for example:
# /usr/bin/editor_test_open_JBs.sh kwrite
#
editor_name=$1 # Like kwrite and gedit
if [ "$#" -lt 2 ]; then # Check the count of parameters, 1 "editor_name", 2 "file_name"
    $editor_name # Just open the text editor
else
    file_name=$2 # File name to be open
    file_Size_MiB=$(du -m "$file_name" | cut -f1) # File size in MiB

    # Check if file size is greater than 100 MiB
    if [ "$file_Size_MiB" -gt 100 ]; then # = 100 MiB (mebibyte)
        tmp_file=$(mktemp)
        echo -e "\nFile too large, more than 100 MiB, to be opened in $editor_name." > "$tmp_file"
        echo "Open it with another program." >> "$tmp_file"
        echo -e "File: $file_name" >> "$tmp_file"
        echo -e "Size: $file_Size_MiB MiB" >> "$tmp_file"
        "$editor_name" "$tmp_file"
        rm "$tmp_file"
    else
        "$editor_name" "$file_name"
    fi
fi
