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
# Script: Change the profile audio active
#
# Last update: 18/02/2023
#
echo -e  "\\n# Remove old \"log\" from remove packages #\\n"

echo -en "Script in beta - use at your own risk\\nHit enter to contine or Crtl + C to quit."
read -r _

func_files_remove() {
    rm_pkg=$1

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
        echo -e "\\n$file:"
        echo "$list_files_tmp" | grep "^$file"

        echo "$list_files_tmp" | grep "^$file" | sed '1d' >> "$tmp_file"
        #read
    done

    echo -e "\\nFolder: \"$PWD/\"\\nFiles to be deleted:"
    cat "$tmp_file"

    list_files_delete=$(cat "$tmp_file")
    if [ "$list_files_delete" != '' ]; then
        echo -en "\\nDelete theses files? (y)es or (n)o: "
        read -r continue_or_not

        if [ "$continue_or_not" == 'y' ]; then
            for file in $list_files_delete; do
                rm -v "$file"
            done
        else
            echo " # Not deleting files! #"
        fi
    else
        echo " # No file to be deleted! #"
    fi

    rm "$tmp_file"
}

cd /var/log/removed_scripts/ || exit
func_files_remove 'y'

cd /var/log/removed_packages/ || exit
func_files_remove 'y'

cd /var/log/ || exit
func_files_remove
