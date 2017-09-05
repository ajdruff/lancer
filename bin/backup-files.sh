#!/usr/bin/env bash

#################
# 
#
#
# Backs up files
#
#  Usage:
# ./backup-files.sh live/dev/stage [dry]
#
#
# @author <andrew@nomstock.com>
# @todo change mysql backup script to save in the same format as the the files - to the backups directory,zipped and renamed to include time of backup




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#get the configuration variables   
source "${DIR%%/}/.bin/lancer.conf.sh";

#include common functions
source "${DIR%%/}/.bin/functions.sh";

#include backup files functions
source "${DIR%%/}/.bin/backup-files.functions.sh";

#check that server environment was passed
setServerEnvFromArg $1

#Now that we know environment, get appropriate values
getEnvVars


checkForDryRun "${1}" "${2}"
checkIfRemoteSource
makeDestinationDirectory
setBackupCommands
doBackup
compressFiles
showBackupCommand
showCompressCommand
showBackupCompleteMessage
