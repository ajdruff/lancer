#!/usr/bin/bash

#################
# create-database-dev.sh
#
#
# Creates a database
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

DEST_DATABASE_IS_REMOTE="${STAGE_DATABASE_IS_REMOTE}";

DEST_DEFAULTS_FILE="${STAGE_MYSQL_DEFAULTS_FILE}";#name of mysql --defaults-file containing username and passwords (in the same directory as this file)

DEST_DB_NAME="${STAGE_DB_NAME}";

source "${DIR%%/}/create-database.inc.sh";