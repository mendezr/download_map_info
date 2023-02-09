#!/bin/bash

###################################################################
#File Name    : download_map_status.sh
#Author       : Raul Mendez
#Email        : raul.mendez@isglobal.org
#Description  : Download google sheet from isglobal drive
#Creation Date: 09-02-2023
#Last Modified: Thu 09 Feb 2023 03:33:34 PM CET
###################################################################

# Load the local rclone
# I need to download a newer version of rclone to use the google api
export PATH=$PATH:$HOME/bin/

# Check if rclone exits if not exit with error code
if ! command -v rclone &> /dev/null
then
    echo "<rclone> could not found"
    exit 1
fi

# Folder when the file will be downloaded
FOLDER=/home/isglobal.lan/rmendez/test_rclone/maps
# Full path of the file
FILE=$FOLDER/"Dataset Periodic Updates.xlsx"

if [[ -f "${FILE}" ]];
then
    # Check if file exist previously, rename it as backup
    echo File found, remove it
    mv $FILE $FOLDER/.data_update.xlsx
fi

cd $FOLDER
echo "Download the map file"

rclone copy isglobal:"/maps/Dataset Periodic Updates.xlsx" .

if [[ ! -f "${FILE}" ]];
then
    # Check if the file is download, if not restore it using
    # the backup
    echo Fail, restore the backup
    mv $FOLDER/.data_update.xlsx $FILE 
    exit 1
fi

if [[ -f ".data_update.xlsx" ]];
then
    # If the map_info was download, then delete the backup file
    rm .data_update.xlsx
fi

echo Done
exit 0
