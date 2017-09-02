#!/usr/bin/bash

#################
# scrub-wp-database-live.sh
#
#
# Removes WordPress Installation Cruft
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


DEST_DB_NAME="${LIVE_DB_NAME}";


source "${DIR%%/}/scrub-wp-database.inc.sh";