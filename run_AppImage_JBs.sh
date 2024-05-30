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
# Script: Works with AppImage, can run, view, portable run and extract
#
# Tip: Add desktop launcher with the script
# Examples: https://github.com/ryuuzaki42/04_AppImage_shortcut_desktop/tree/main/AppImage_run
#
# Last update: 30/05/2024
#
set -x

AppImage_File=$1
if [ "$AppImage_File" == '' ]; then
    echo -e "\n# Error: Need to pass parameters - the AppImage file and one option"
    echo -e "For help message: $(basename $0) -h\n"
    exit 1
fi

if [ "$AppImage_File" == '-h' ] || [ "$AppImage_File" == '--help' ]; then
    script_name=$(basename $0)
    echo -e "
    Usage:
    $script_name [AppImage] [OPTIONS]

    OPTIONS:
        -h, --help     Print this message

        -r, --run      Run the AppImage with the arguments passed
            Example: $script_name Maestral-*_JB.AppImage -r gui
                > gui is a parameter to this AppImage to run with gui

        -v, --view     View the files inside the AppImage
            Mount the AppImage and load the tmp folder with the file explorer
            Example: $script_name Maestral-*_JB.AppImage -v

        -x, --extract  Extract the Prog*.AppImage to a folder Prog*.AppImage.ext/
            Example: $script_name Maestral-*_JB.AppImage -x

        -p, --portable Create a folder to home and other to configuration, then run the AppImage
            Run an AppImage using local configuration (place of the AppImage file) and the arguments passed
            Will create folders to save the configuration files: *.AppImage.config/ and *.AppImage.home/
            Obs.: The application in the AppImage may save files in other folder, like user home folder

            Example: $script_name Maestral-*_JB.AppImage -p gui\n"
    exit 0
fi

if echo "$AppImage_File" | grep -iq "AppImage"; then # Check if is a AppImage file
    option_run=$2
    other_parameters=${*:3} # Parameters from $3 onwards
    echo -e "\nAppImage_File: \"$AppImage_File\" option_run: \"$option_run\" other_parameters: \"$other_parameters\"\n"
else
    echo "Error: \"$AppImage_File\" is no a AppImage file"
    exit 1
fi

chmod +x "$AppImage_File" # Add permission to run, may not have it yet

first_char="${AppImage_File:0:1}" # Extract the first character
if [ "$first_char" != '/' ]; then # If $first_char == '/' is full path, if $first_char != '/' is relative path
    AppImage_File="./$AppImage_File" # Add ./ to run the AppImage
fi

if [ "$option_run" == '' ]; then
    echo "Pass one option valid to work with the AppImage"
    echo "For help run: ./$(basename $0) -h"
    exit 1

elif [ "$option_run" == "-v" ] || [ "$option_run" == "--view" ]; then
    TMP_File=$(mktemp) # Create a tmp file to save the mount point location
    "$AppImage_File" --appimage-mount > "$TMP_File" & # Mount AppImage

    sleep 1
    mount_point=$(cat "$TMP_File")
    rm -f "$TMP_File"

    if [ -x /usr/bin/dolphin ]; then # Check witch file explorer available
        file_explorer="dolphin"
    elif [ -x /usr/bin/thunar ]; then
        file_explorer="thunar"
    else
        echo "File explorer not defined"
    fi
    #echo "file_explorer: \"$file_explorer\""

    "$file_explorer" "$mount_point"

    echo " When has complete to check the files, respond y below to close and umount the AppImage in $mount_point"
    echo -en "\n Close the \"$AppImage_File\"?\n (y)es or (n)o - Enter to yes: "
    read -r do_close

    if [ "$do_close" == 'y' ] || [ "$do_close" == '' ]; then
        PID=$(ps aux | grep "appimage-mount" | grep "$AppImage_File" | awk '{print $2}' | head -n 1)
        echo "PID: $PID"
        kill $PID
        #kill -9 $PID
    fi

elif [ "$option_run" == "-x" ] || [ "$option_run" == "--extract" ]; then
    "$AppImage_File" --appimage-extract # Extract the AppImage

    mv squashfs-root/ "${AppImage_File}.ext/"
    echo -e "\n AppImage: \"$AppImage_File\"\n Extracted to the folder: \"${AppImage_File}.ext/\""

elif [ "$option_run" == '-p' ] || [ "$option_run" == "--portable" ] \
   || [ "$option_run" == '-r' ] || [ "$option_run" == "--run" ]; then # If $option_run is --run or --portable

    if [ "$option_run" == '-p' ] || [ "$option_run" == "--portable" ]; then # Only if $option_run is --portable
        # Create a portable home folder to use as $HOME
        "$AppImage_File" --appimage-portable-home

        # Create a portable configuration folder to use as $XDG_CONFIG_HOME
        "$AppImage_File" --appimage-portable-config
    fi

    if [ "$other_parameters" == '' ]; then # If no parameter were passed
        "$AppImage_File"
    else
        "$AppImage_File" "$other_parameters"
    fi
else
    echo "Error: option \"$option_run\ not recognised"
fi
