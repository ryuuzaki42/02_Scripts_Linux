#!/bin/bash

## Copy the configurations on this folder to ~/ and /root/
    # You can just execute this script

# Last update: 30/05/2017

echo -e "This script copy (cp .??*) to ~/ and /root/\n"
echo "List of files that will be copied:"
ls .??*
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    cp .??* ~/
    echo -e "\n\tThe files was copied to \"$(cd ~; pwd)/\""

    echo -e "\nInsert the root password to copy the files to \"/root/\""
    if su - root -c "cd $PWD; cp .??* /root/"; then
        echo -e "\n\tThe files was copied to \"/root/\""
    else
        echo -e "\n\tThe files was not copied to \"/root/\""
    fi
else
    echo -e "\n\tAny files was not copied"
fi
echo -e "\nEnd of the script\n"
