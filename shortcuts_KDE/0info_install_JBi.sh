#!/bin/sh

## Copy the this shortcuts to your folder /home/$USER/.local/share/applications/
    # Be careful, he overwrite the files, if they already exists
    # You can just execut this script
#
# Última atualização: 29/04/2016
#
# Dica: Adicione no KDE-menu um atalho de teclado:
# Lock Screen.desktop => ctrl + alt + l
# Suspend.desktop     => ctrl + alt + s
#
echo "This script copy (cp *.sh) to /home/$USER/.local/share/applications/"
cp *.desktop /home/$USER/.local/share/applications/
