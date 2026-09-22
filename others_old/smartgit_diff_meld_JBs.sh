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
# Script: script to create a git show file from last commit and compare
# wit the local file using the meld program
#
# Last update: 14/04/2017
#
# In the SmartGit go:
# Edit >> Preferences >> Tools, and # >> Add...
# Name: Open wiht Meld
# SmartGit command: link this script sh
#    /usr/bin/smartgit_diff_meld_JBs.sh
# Arguments: ${filePath} ${repositoryRootPath}
# Handles: Files
#
fullPath=$1 # full path to the file from SmartGit
rootFolderPath=$2 # path from the project folder from SmartGit
filePathRoot=${fullPath#$rootFolderPath} # Get project folder and the file name
filePathRoot=${filePathRoot:1} # Remove the frist "/" form "/foder/file"

tmpFile=$(mktemp) # Create a TMP-file

# Only for test
#echo "fullPath $fullPath" >> $tmpFile
#echo "rootFolderPath $rootFolderPath" >> $tmpFile
#echo "filePathRoot $filePathRoot" >> $tmpFile
#kwrite $tmpFile

git show HEAD:"$filePathRoot" >> "$tmpFile" # Generate the a tmpFile from last commit

# Commit before (~1, ~2, ...)
#    git show HEAD~1:"$filePathRoot" >> $tmpFile

meld "$tmpFile" "$fullPath" # Open meld with the two files

rm "$tmpFile" # Delete the tmpFile
