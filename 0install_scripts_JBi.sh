#!/bin/sh

## Copy the scripts int this folder to /usr/bin:
    # You can just execut this script

# Last update: 14/11/2016

echo -e "This script copy (cp *_JBs.sh) to /usr/bin/\n"
echo "List of files that will be copied:"
ls *_JBs.sh
echo -e "\t\nBe careful, will overwrite the files if they already exists\n"

echo -en "Want continue and copy this files?\n(y)es - (n)o: "
read continueCopy

if [ "$continueCopy" == 'y' ]; then
    su - root -c "cd $PWD
    cp *_JBs.sh /usr/bin/"

    if [ $? == 0 ]; then
        echo -e "\n\tThe Files was copied"
    fi
else
    echo -e "\n\tThe Files was not copied"
fi
echo -e "\nEnd of the script\n"
