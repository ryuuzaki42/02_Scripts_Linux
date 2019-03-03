#!/bin/bash

## Copy the this shortcuts to your folder ${HOME}.local/share/applications/
    # You can just execut this script

# Last update: 03/03/2019

# Dica: Adicione no KDE-menu os atalhos de teclado:
# audio_profile_change => shortcut = ctrl + meta + a
# ...

echo -e "This script copy (cp $(pwd)/*.desktop) to ${HOME}.local/share/applications/\\n"

echo "List of files that will be copied:"
ls ./*.desktop
echo -e "\\t\\nBe careful, will overwrite the files if they already exists\\n"

echo -en "Want continue and copy this files?\\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    cp ./*.desktop "${HOME}.local/share/applications/"
else
    echo -e "\\n\\tThe Files was not copied"
fi

echo -e "\\nEnd of the script\\n"
