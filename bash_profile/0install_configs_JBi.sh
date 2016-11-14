#!/bin/sh

## Copy the configs on this folder to ~/ and /root/
    # You can just execut this script

# Last update: 14/11/2016

echo -e "This script copy (cp .??*) to ~/ and /root/\n"
echo "List of files that will be copied:"
ls .??*
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read continueCopy

if [ "$continueCopy" == 'y' ]; then
    cp .??* ~/
    su - root -c "cd $PWD
    cp .??* /root/"

    if [ $? == 0 ]; then
        echo -e "\n\tThe Files was copied"
    fi
else
    echo -e "\n\tThe Files was not copied"
fi
echo -e "\nEnd of the script\n"
