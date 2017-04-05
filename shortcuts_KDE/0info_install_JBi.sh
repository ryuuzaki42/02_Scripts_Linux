#!/bin/bash

## Copy the this shortcuts to your folder /home/$USER/.local/share/applications/
    # You can just execut this script

# Last update: 20/09/2016

# Dica: Adicione no KDE-menu um atalho de teclado:
# Lock Screen.desktop => ctrl + alt + l
# Suspend.desktop     => ctrl + alt + s

echo -e "This script copy (cp *.desktop) to /home/$USER/.local/share/applications/\n"

echo "List of files that will be copied:"
ls *.desktop
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read continueCopy

if [ "$continueCopy" == 'y' ]; then
    cp *.desktop /home/$USER/.local/share/applications/
else
    echo -e "\n\tThe Files was not copied"
fi

echo -e "\nEnd of the script\n"
