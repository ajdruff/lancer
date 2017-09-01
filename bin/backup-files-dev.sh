#!/usr/bin/bash

#################
# backup-files-dev.sh
#
#
# Backs up the Dev files
#
#  Usage:
# ./backup-files-dev.sh
#
#
# @author <andrew@nomstock.com>
# @todo change mysql backup script to save in the same format as the the files - to the backups directory,zipped and renamed to include time of backup
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read common variables for all bash scripts
source "${DIR%%/}/config-bash.conf";

#read common variables for all conversion scripts
source "${DIR%%/}/config-bash-advanced.conf";



#config
SOURCE_DIRECTORY_IS_REMOTE="${DEV_DIRECTORY_IS_REMOTE}";
SOURCE_DOMAIN="${DOMAIN_DEV}";
SOURCE_DIRECTORY_PATH=${DEV_DIR_PATH};
SOURCE_ENVIRONMENT=DEV;

#config 
DRY_RUN=false; ## set to true to add --dry-run

COMPRESSION=zip; ## tar/zip/none


source "${DIR%%/}/backup-files.inc.sh";





