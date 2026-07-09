#!/bin/bash
#
# Copy/Install the scripts (*_JBs.sh) in this folder to /usr/bin/
#
# Last update: 09/07/2026
#

RED='\e[1;31m'
GREEN='\e[1;32m'
NC='\033[0m' # reset/no color
BLUE='\e[1;34m'

echo -e "\n${BLUE}This script copy/install (cp *_JBs.sh) to /usr/bin/$NC\n"

echo "List of files/scripts that will be copied:"
ls --color=auto ./*_JBs.sh
echo -e "\t\n${RED}Be careful! Will overwrite the files if they already exists$NC\n"

echo -en "Want continue and copy these files?\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    echo

    if su - root -c "cd $PWD
    cp -v *_JBs.sh /usr/bin/"; then
        echo -e "\n${GREEN}The files was copied$NC\n"
    fi
else
    echo -e "\n${RED}The files was not copied$NC\n"
fi
