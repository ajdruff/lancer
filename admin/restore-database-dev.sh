#!/usr/bin/bash

#################
# restore-database-dev.sh
#
#
# Restores dev database from backup
#
#  Usage:
# ./restore-database-dev.sh
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

DEST_DATABASE_IS_REMOTE="${DEV_DATABASE_IS_REMOTE}";

DEST_DEFAULTS_FILE="${DEV_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)

DEST_DB_HOST="${DEV_DB_HOST}";

SOURCE_BACKUP_FILE="${DEV_BACKUP_FILE}"; #absolute file path to where we stash the source db and where we restore it from

DEST_DB_NAME="${DEV_DB_NAME}";

source "${DIR%%/}/restore-database.inc.sh";