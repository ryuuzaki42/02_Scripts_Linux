#!/bin/bash
#
# Copy the this shortcuts to your folder ${HOME}.local/share/applications/
# You can just execute this script
#
# Last update: 19/06/2023
#
# Tip: Add in "KDE Menu Editor" the shortcut as suggested in *.desktop
# Start icon in the panel > right click > Edit Applications...
# audio_profile_change => shortcut = Ctrl + Shift + A
#
echo -e "This script copy (cp $(pwd)/*.desktop) to ${HOME}.local/share/applications/\n"

echo "List of files that will be copied:"
ls ./*.desktop
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    cp ./*.desktop "${HOME}/.local/share/applications/"
    echo -e "\n\tThe files (*.desktop) was copied"
else
    echo -e "\n\tThe files (*.desktop) was not copied"
fi
echo -e "\nEnd of the script\n"
