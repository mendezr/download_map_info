#!/bin/bash

###################################################################
#File Name    : download_map_status.sh
#Author       : Raul Mendez
#Email        : raul.mendez@isglobal.org
#Description  : Download google sheet from isglobal drive
#Creation Date: 09-02-2023
#Last Modified: Thu 09 Feb 2023 12:46:40 PM CET
###################################################################

# Load the local rclone
# I need to download a newer version of rclone to use the google api
export PATH=$PATH:$HOME/bin/

# Check if rclone exits
if ! command -v rclone &> /dev/null
then
    echo "<rclone> could not found"
    exit 1
fi

FOLDER=/home/isglobal.lan/rmendez/test_rclone/maps
FILE=$FOLDER/"Dataset Periodic Updates.xlsx"

echo $FILE

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
    echo Fail, restore the backup
    mv $FOLDER/.data_update.xlsx $FILE 
    exit 1
fi

if [[ -f ".data_update.xlsx" ]];
then
    # Check if file exist previously, rename it as backup
    rm .data_update.xlsx
fi

echo Done
exit 0
