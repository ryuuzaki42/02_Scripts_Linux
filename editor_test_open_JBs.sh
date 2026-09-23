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
# /usr/bin/editor_test_open_JBs.sh programName, for example:
# /usr/bin/editor_test_open_JBs.sh kwrite
#
editorText=$1 # Like kwrite and gedit
if [ "$#" -lt 2 ]; then # Check the count of parameters, 1 "editor", 2 "fileName"
    $editorText # Just open the text editor
else
    fileName=$2 # File name to be open
    fileSizeMB=$(du -m "$fileName" | cut -f1) # File size in kibibyte

    # Check if file size is greater than 100 MiB
    if [ "$fileSizeMB" -gt 100 ]; then # = 100 MiB (mebibyte)
        tmpFile=$(mktemp)
        echo "File too large to be opened in $editorText." > "$tmpFile"
        echo "Open it with another program." >> "$tmpFile"
        "$editorText" "$tmpFile"
        rm "$tmpFile"
    else
        "$editorText" "$fileName"
    fi
fi
