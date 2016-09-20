#!/bin/sh

## Copy the scripts int this folder to /usr/bin:
    # Be careful, he overwrite the files, if they already exists
    # You can just execut this script
#
# Última atualização: 06/06/2016
#
echo "This script copy (cp *.sh) to /usr/bin/"
scriptsFolder=`pwd`
export scriptsFolder
su - root -c "cd $scriptsFolder
cp *.sh /usr/bin/"
#
