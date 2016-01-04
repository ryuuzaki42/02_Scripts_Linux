#!/bin/sh

## Copy the files to /usr/bin:
    # Can just execut this script
echo "This script will copy (cp *.sh) to /usr/bin/"
scriptsFolder=`pwd`
export scriptsFolder
su - root -c "cd $scriptsFolder
cp *.sh /usr/bin/"

