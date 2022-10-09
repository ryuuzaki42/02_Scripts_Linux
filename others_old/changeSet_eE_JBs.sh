#!/bin/bash
#
# Last update: 09/10/2022
#
set -eEuo pipefail
trap 'echo -e "\\n\\n\e[1;31mError at line $LINENO\033[0m - Command:\\n\e[1;31m$BASH_COMMAND\033[0m\\n"' ERR

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
## change 1
#    sed -i 's/^set -e$/set -eE\
#trap '\''echo -e "\\\\n\\\\n${RED}Error at line $LINENO$NC - Command:\\\\n$RED$BASH_COMMAND\\\\n"'\'' ERR/g' $file

# Change 2
    sed -i 's/^set -eE$/set -eEuo pipefail/g'  $file
    sed -i 's/^trap '\''echo -e "\\\\n\\\\n${RED}Error at line $LINENO$NC - Command:\\\\n$RED$BASH_COMMAND\\\\n"'\'' ERR/trap '\''echo -e "\\\\n\\\\n\\e[1;31mError at line $LINENO\\033[0m - Command:\\\\n\\e[1;31m$BASH_COMMAND\\033[0m\\\\n"'\'' ERR/g' $file

    # Update the date
    sed -i 's/^# Last update: .*/# Last update: '"$dateNew"'/1' $file

#     exit
done
echo -e "\\nEnd of Script!\\n"
