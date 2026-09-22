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
# Script: Remove old \"log\" from remove packages.
#
# Folder by default: cd /var/log/removed_scripts/, /var/log/removed_packages/, /var/log/
#
# Last update: 08/05/2026
#
RED='\e[1;31m'
GREEN='\e[1;32m'
NC='\033[0m' # reset/no color
#BLUE='\e[1;34m'
CYAN='\e[1;36m'

echo -e  "\n$CYAN # Remove old \"log\" from remove packages #"
echo -e  " Select the packages logs with the same \"pkg_name\" in folder to be deleted (leave the most recent) $NC\n"

echo -en "$RED Script in beta - use at your own risk!\nHit enter to continue or Ctrl + C to quit.$NC"
read -r _

func_files_remove() {
    rm_pkg=$1
    echo -e "\n${CYAN}List of \"pkg_name\" in the folder $GREEN\"$PWD\"$NC"

    list_files=$(ls -1tpL | grep -v '/') # List only files

    list_files_tmp=$list_files

    if [ "$rm_pkg" == 'y' ]; then
        # Remove -upgraded-'date' - like "-upgraded-2022-06-07,09:37:49"
        #list_files=$(echo "$list_files" | sed 's/-upgraded-.*//')

        # Remove date - like 22022-10-05,20:55:35
        #list_files=$(echo "$list_files" | sed 's/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\},.*//')

        # Remove -i?86-*, -x86_64-*, -noarch-* and -x86-* (kernel-headers-*-x86-*)
        list_files=$(echo "$list_files" | sed 's/-i.86-.*//g; s/-x86_64-.*//g; s/-noarch-.*//g; s/-x86-.*//g;')

        # Remove version
        list_files=$(echo "$list_files" | rev | cut -d '-' -f2- | rev)

        # Remove duplicate
        list_files=$(echo "$list_files" | sort | uniq)
    fi

    # Test
    #echo "$list_files"
    #read

    tmp_file=$(mktemp)
    for file in $list_files; do
        echo -e "\n${CYAN}pkg_name: $GREEN$file$NC"
        echo "$list_files_tmp" | grep "^$file"

        echo "$list_files_tmp" | grep "^$file" | sed '1d' >> "$tmp_file"
        #read
    done

    echo -e "\n${CYAN}Folder: \"$GREEN$PWD/\"\n\n${RED}Files to be deleted:$NC"
    cat "$tmp_file"

    list_files_delete=$(cat "$tmp_file")
    if [ "$list_files_delete" != '' ]; then
        echo -en "\n$RED Delete theses files? (y)es or (n)o: "
        read -r continue_or_not

        if [ "$continue_or_not" == 'y' ]; then
            for file in $list_files_delete; do
                rm -v "$file"
            done
        else
            echo -e "\n$GREEN # Not deleting files! #$NC"
        fi
    else
        echo -e "\n$GREEN # No file to be deleted! #$NC"
    fi

    rm "$tmp_file"
}

cd /var/log/removed_scripts/ || exit
func_files_remove 'y'

cd /var/log/removed_packages/ || exit
func_files_remove 'y'

cd /var/log/ || exit
func_files_remove
