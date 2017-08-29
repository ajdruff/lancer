#!/usr/bin/bash

#################
# backup-database-dev.sh
#
#
# Backs up the Dev database 
#
#  Usage:
# ./backup-database-dev.sh
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
SOURCE_DATABASE_IS_REMOTE="${DEV_DATABASE_IS_REMOTE}";

SOURCE_MYSQL_DEFAULTS_FILE="${DEV_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
SOURCE_BACKUP_FILE="${DEV_BACKUP_FILE}"; #absolute file path to where we stash the source db and where we restore it from
SOURCE_DB_NAME="${DEV_DB_NAME}";
ENVIRONMENT="DEV";

source "${DIR%%/}/backup-database.inc.sh";