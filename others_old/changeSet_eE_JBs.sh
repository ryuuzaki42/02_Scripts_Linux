#!/bin/bash
#
# Last update: 08/10/2022
#
set -eE
trap 'echo -e "\\n\\n${RED}Error at line $LINENO$NC - Command:\\n$RED$BASH_COMMAND\\n"' ERR

folder_work=$1
if [ "$folder_work" == '' ]; then
    echo "Error: need a folder to work with - with the *.sh files"
    exit 1
fi
echo -e "\\nFolder to work: $folder_work"

cd $folder_work || exit

echo -e "\\nFiles to change:"
ls -1 *.sh

echo -en "\\nContinue (y)es or (n)o: "
read ContinueOrNot
if [ "$ContinueOrNot" != 'y' ]; then
    echo -e "\\nJust exiting\\n"
    exit 0
fi

dateNew=$(date +%d\\/%m\\/%Y)
echo -e "\\ndateNew: $dateNew"

for file in *.sh; do
    echo -e "\\n$file"

    ## Change set -e and add new line with code
    sed -i 's/^set -e$/set -eE\
trap '\''echo -e "\\\\n\\\\n${RED}Error at line $LINENO$NC - Command:\\\\n$RED$BASH_COMMAND\\\\n"'\'' ERR/g' $file

    # Update the date
    sed -i 's/^# Last update: .*/# Last update: '"$dateNew"'/1' $file

#     exit
done
echo -e "\\nEnd of Script!\\n"
