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
# Script: Run a AppImage using local configuration (place of the AppImage file)
# Create to folders to save the configuration files
#
# Last update: 30/05/2024
#
set -x

AppImage_File=$1

if [ "$AppImage_File" == '' ]; then
    echo -e "\n# Error: Need to pass parameters - the AppImage file name"
    echo -e "For help message: $0 -h\n"
    exit 1
fi

if [ "$AppImage_File" == '-h' ] || [ "$AppImage_File" == '--help' ]; then
    echo -e "
    Usage:
    ./$(basename $0) [OPTIONS]

    OPTIONS:
        -h, --help     Print this message
        -v, --view     Mount AppImage and load folder with dolphin
        -r, --run      Run the AppImage with the arguments passed
        -x, --extract  Extract the AppImage to a folder Prog*.AppImage.ext/
        -p, --portable Create a folder to home and other to configuration, then run the AppImage
            Run an AppImage using local configuration (place of the AppImage file) and the arguments passed
            Will create folders to save the configuration files, *.AppImage.config/ *.AppImage.home/
            Obs.: The application in the AppImage may save files in other folder, like user home folder
            Example: ./$(basename $0) Calibre-*-x86_64-1_JB.AppImage -p\n"
    exit 0
fi

if echo "$AppImage_File" | grep -iq "AppImage"; then
    option_run=$2
    other_parameters=${*:3} # Parameters from $3 onwards
    echo -e "\nAppImage_File: \"$AppImage_File\" option_run: \"$option_run\" other_parameters: \"$other_parameters\"\n"
else
    echo "Error: \"$AppImage_File\" is no valid as AppImage"
    exit 1
fi

chmod +x "$AppImage_File" # Add permission to run, may not have it yet


first_char="${AppImage_File:0:1}" # Extract the first character
if [ "$first_char" == '/' ]; then #
    echo "Full path"
else # Add ./ to run the AppImage
    echo "Relative path"
    # Extract the first character
    AppImage_File="./$AppImage_File"
fi

if [ "$option_run" == '' ]; then
    echo "Pass one option valid to work with the AppImage"
    echo "For help run: ./$(basename $0) -h"

elif [ "$option_run" == "-v" ] || [ "$option_run" == "--view" ]; then
    TMP_File=$(mktemp) # Create tmp file to save the mount point location
    "$AppImage_File" --appimage-mount > "$TMP_File" &

    sleep 1
    mount_point=$(cat "$TMP_File")
    rm -f "$TMP_File"

    if [ -x /usr/bin/dolphin ]; then
        file_explorer="dolphin"
    elif [ -x /usr/bin/thunar ]; then
        file_explorer="thunar"
    else
        echo "File explorer not defined"
    fi
    #echo "file_explorer: \"$file_explorer\""

    "$file_explorer" "$mount_point"

    echo " When you complete to check the files, responde y below to close/umount the AppImage: $mount_point"
    echo -en "\n Close the \"$AppImage_File\"?\n (y)es or (n)o - Enter to yes: "
    read -r do_close

    if [ "$do_close" == 'y' ] || [ "$do_close" == '' ]; then
        #AppImage_File_Name=$(echo "$AppImage_File" | rev | cut -d '/' -f1 | rev) # Grep file Name
        #echo "AppImage_File_Name: $AppImage_File_Name"

        #PID=$(ps aux | grep "appimage-mount" | grep "$AppImage_File_Name" | awk '{print $2}' | head -n 1)
        PID=$(ps aux | grep "appimage-mount" | grep "$AppImage_File" | awk '{print $2}' | head -n 1)
        echo "PID: $PID"
        kill $PID
        #kill -9 $PID
    fi

elif [ "$option_run" == "-x" ] || [ "$option_run" == "--extract" ]; then
    "$AppImage_File" --appimage-extract

    mv squashfs-root "${AppImage_File}.ext"
    echo "check name folder"
    echo -e "\n AppImage: \"$AppImage_File\"\n Extracted to folder: \"${AppImage_File}.ext/\""

elif [ "$option_run" == '-p' ] || [ "$option_run" == "--portable" ]; then
    # Create a portable home folder to use as $HOME
    "$AppImage_File" --appimage-portable-home

    # Create a portable config folder to use as $XDG_CONFIG_HOME
    "$AppImage_File" --appimage-portable-config

    "$AppImage_File" "$other_parameters"
elif [ "$option_run" == '-r' ] || [ "$option_run" == "--run" ]; then
    if [ "$other_parameters" == '' ]; then # If no parameter is passed
        "$AppImage_File"
    else
        "$AppImage_File" "$other_parameters"
    fi
else
    echo "BBB"
fi
