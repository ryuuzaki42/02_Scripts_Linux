#!/bin/sh

## Copy the scripts int this folder to /usr/bin:
    # You can just execut this script

# Last update: 20/09/2016

echo -e "This script copy (cp *_JBs.sh) to /usr/bin/\n"
echo "List of files that will be copied:"
ls *_JBs.sh
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read continueCopy

if [ "$continueCopy" == "y" ]; then
    scriptsFolder=`pwd`
    export scriptsFolder
    su - root -c "cd $scriptsFolder
    cp *_JBs.sh /usr/bin/"
fi
echo -e "\nEnd of the script\n"
