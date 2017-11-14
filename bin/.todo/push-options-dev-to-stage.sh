#!/usr/bin/bash

#################
# push-dev-to-stage-optioins.sh
#
#
# Overwrites the Staging Database with the Live Database 
#
#  Usage:
# ./push-dev-to-stage-optioins.sh
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
DEST_DATABASE_IS_REMOTE="${STAGE_DATABASE_IS_REMOTE}";

EXPORT_OPTIONS_QUERY_FILE="${DEV_EXPORT_OPTIONS_QUERY_FILE}";
IMPORT_OPTIONS_QUERY_FILE="${STAGE_IMPORT_OPTIONS_QUERY_FILE}";

SOURCE_MYSQL_DEFAULTS_FILE="${DEV_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)
DEST_DEFAULTS_FILE="${STAGE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)

SQL_CONVERSION_FILE="${DEV_TO_STAGE_CONVERSION_FILE}"; #Sets SQL variables for conversion
SOURCE_DB_NAME="${DEV_DB_NAME}";
DEST_DB_NAME="${STAGE_DB_NAME}";


# core code
source "${DIR%%/}/push-options.inc.sh";