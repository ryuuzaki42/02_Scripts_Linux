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
# Script: script to create a git show file from last commit and compare
# wit the local file using the meld program
#
# Last update: 17/11/2016
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
filePathRoot=`echo ${fullPath#"$rootFolderPath"}` # Get project folder and the file name
filePathRoot=${filePathRoot:1} # Remove the frist "/" form "/foder/file"

tmpFile=`mktemp` # Create a TMP-file

# Only for test
#echo "fullPath $fullPath" >> $tmpFile
#echo "rootFolderPath $rootFolderPath" >> $tmpFile
#echo "filePathRoot $filePathRoot" >> $tmpFile
#kwrite $tmpFile

git show HEAD:"$filePathRoot" >> $tmpFile # Generate the a tmpFile from last commit

# Commit before (~1, ~2, ...)
#    git show HEAD~1:"$filePathRoot" >> $tmpFile

meld $tmpFile $fullPath # Open meld with the two files

rm $tmpFile # Delete the tmpFile
