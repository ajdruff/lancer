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

DEST_DB_HOST="${LIVE_DB_HOST}";

DEST_DATABASE_IS_REMOTE="${LIVE_DATABASE_IS_REMOTE}";

DEST_DEFAULTS_FILE="${LIVE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
SOURCE_BACKUP_FILE="${LIVE_BACKUP_FILE}"; #absolute file path to where we stash the source db and where we restore it from

DEST_DB_NAME="${LIVE_DB_NAME}";

source "${DIR%%/}/restore-database.inc.sh";