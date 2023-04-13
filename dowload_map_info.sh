#!/bin/bash

# Test local repo push

###################################################################
#File Name    : download_map_status.sh
#Author       : Raul Mendez
#Email        : raul.mendez@isglobal.org
#Description  : Download google sheet from isglobal drive
#Creation Date: 09-02-2023
#Last Modified: Wed 12 Apr 2023 03:23:22 PM CEST
###################################################################

# Load the local rclone
# I need to download a newer version of rclone to use the google api
# I have the binary in my home directory
export PATH=$PATH:$HOME/bin/
FILENAME="Population_NumberRegions.xlsx"

# Check if rclone exits if not exit with error code
if ! command -v rclone &> /dev/null
then
    echo "<rclone> could not found"
    exit 1
fi

# Folder when the file will be downloaded
FOLDER=/PROJECTES/ADAPTATION/core/code/health/download/
# Full path of the file
FILE=$FOLDER/$FILENAME
 
cd $FOLDER || exit

if [[ -f "${FILE}" ]];
then
    # Check if file exist previously, rename it as backup
    echo File found, create the backup
    mv "${FILE}" data_update.xlsx
fi

echo "Download the map file"

rclone copy isglobal:"/maps/$FILENAME" .

if [[ ! -f "${FILE}" ]];
then
    # Check if the file is download, if not restore it using
    # the backup
    echo Fail, restore the backup
    mv $FOLDER/data_update.xlsx $FILE 
    exit 1
fi

if [[ -f "data_update.xlsx" ]];
then
    # If the map_info was download, then delete the backup file
    echo Removing the backup
    rm data_update.xlsx
fi

echo Done
exit 0
