#!/usr/bin/bash

#################
# convert-database-dev-to-live.sh
#
#
# Converts a Database with a Dev Domain to the Live Domain
#
#  Usage:
# ./convert-database-dev-to-live.sh
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

DEST_DATABASE_IS_REMOTE="${LIVE_DATABASE_IS_REMOTE}";

DEST_DEFAULTS_FILE="${LIVE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)

SQL_CONVERSION_FILE="${DEV_TO_LIVE_CONVERSION_FILE}"; #Sets SQL variables for conversion

DEST_DB_NAME="${LIVE_DB_NAME}";


source "${DIR%%/}/fix-domain.inc.sh";