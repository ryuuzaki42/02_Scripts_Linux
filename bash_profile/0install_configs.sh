#!/bin/sh

## Copy the configs on this folder to ~/ and /root/
    # You can just execut this script

# Last update: 20/09/2016

echo -e "This script copy (cp .??*) to ~/ and /root/\n"
echo "List of files that will be copied:"
ls .??*

echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read continueCopy

if [ "$continueCopy" == "y" ]; then
    configsFolder=`pwd`
    export configsFolder
    cp .??* ~/
    su - root -c "cd $configsFolder
    cp .??* /root/"
fi
echo -e "\nEnd of the script\n"

#
