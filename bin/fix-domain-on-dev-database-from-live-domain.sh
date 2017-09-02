#!/usr/bin/bash

#################
# convert-database-live-to-dev.sh
#
#
# Converts a Database with a Live Domain to the Dev Domain
#
#  Usage:
# ./convert-database-live-to-dev.sh
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

SQL_CONVERSION_FILE="${LIVE_TO_DEV_CONVERSION_FILE}"; #Sets SQL variables for conversion

DEST_DB_NAME="${DEV_DB_NAME}";


source "${DIR%%/}/fix-domain.inc.sh";