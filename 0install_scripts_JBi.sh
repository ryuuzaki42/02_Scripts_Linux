#!/bin/bash
#
## Copy the scripts (*_JBs.sh) int this folder to /usr/bin:
#    You can just execute this script
#
# Last update: 01/08/2020
#
echo -e "This script copy (cp *_JBs.sh) to /usr/bin/\\n"
echo "List of files that will be copied:"
ls --color=auto ./*_JBs.sh
echo -e "\\t\\nBe careful, will overwrite the files if they already exists\\n"

echo -en "Want continue and copy this files?\\n(y)es - (n)o: "
read -r continueCopy

if [ "$continueCopy" == 'y' ]; then
    echo

    if su - root -c "cd $PWD
    cp -v *_JBs.sh /usr/bin/"; then
        echo -e "\\n\\tThe files was copied"
    fi
else
    echo -e "\\n\\tThe files was not copied"
fi
echo -e "\\nEnd of the script\\n"
