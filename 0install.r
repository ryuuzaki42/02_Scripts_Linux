#!/bin/sh

## Copy the files to /usr/bin:
    # You can just execut this script
echo "This script copy (cp *.sh) to /usr/bin/"
scriptsFolder=`pwd`
export scriptsFolder
su - root -c "cd $scriptsFolder
cp *.sh /usr/bin/"
#
