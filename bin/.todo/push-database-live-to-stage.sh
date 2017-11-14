#!/usr/bin/bash

#################
# load-staging-database-with-live.sh
#
#
# Overwrites the Staging Database with the Live Database 
#
#  Usage:
# ./load-staging-database-with-live.sh
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
SOURCE_DATABASE_IS_REMOTE="${LIVE_DATABASE_IS_REMOTE}";
DEST_DATABASE_IS_REMOTE="${STAGE_DATABASE_IS_REMOTE}";
SOURCE_MYSQL_DEFAULTS_FILE="${LIVE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
DEST_DEFAULTS_FILE="${STAGE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
SOURCE_BACKUP_FILE="${LIVE_BACKUP_FILE}"; #absolute file path to where we stash the source db and where we restore it from
SQL_CONVERSION_FILE="${LIVE_TO_STAGE_CONVERSION_FILE}"; #Sets SQL variables for conversion
SOURCE_DB_NAME="${LIVE_DB_NAME}";
DEST_DB_NAME="${STAGE_DB_NAME}";

source "${DIR%%/}/push-database.inc.sh";