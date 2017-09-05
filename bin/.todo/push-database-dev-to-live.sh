#!/usr/bin/bash

#################
# load-staging-database-with-dev.sh
#
#
# Overwrites the Staging Database with the Dev Database 
#
#  Usage:
# ./load-staging-database-with-dev.sh
#
#
# @author <andrew@nomstock.com>
#
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
DEST_DATABASE_IS_REMOTE="${LIVE_DATABASE_IS_REMOTE}";
SOURCE_MYSQL_DEFAULTS_FILE="${DEV_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
DEST_DEFAULTS_FILE="${LIVE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
SOURCE_BACKUP_FILE="${DEV_BACKUP_FILE}"; #absolute file path to where we stash the source db and where we restore it from
SQL_CONVERSION_FILE="${DEV_TO_LIVE_CONVERSION_FILE}"; #Sets SQL variables for conversion
SOURCE_DB_NAME="${DEV_DB_NAME}";
DEST_DB_NAME="${LIVE_DB_NAME}";

source "${DIR%%/}/push-database.inc.sh";