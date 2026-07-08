#!/bin/bash
#
# Copy/Install the scripts (*_JBs.sh) in this folder to /usr/bin/:
#
# Last update: 08/07/2026
#
echo -e "This script copy (cp *_JBs.sh) to /usr/bin/\n"

echo "List of files that will be copied:"
RED='\e[1;31m'
GREEN='\e[1;32m'
NC='\033[0m' # reset/no color
BLUE='\e[1;34m'
ls --color=auto ./*_JBs.sh
echo -e "\t\n${RED}Be careful, will overwrite the files if they already exists$NC\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    echo

    if su - root -c "cd $PWD
    cp -v *_JBs.sh /usr/bin/"; then
        echo -e "\n\t${GREEN}The files was copied$NC"
    fi
else
    echo -e "\n\t${RED}The files was not copied$NC"
fi
echo -e "\nEnd of the script\n"
