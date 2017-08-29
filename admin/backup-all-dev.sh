#!/usr/bin/bash


#################
# backup-all-dev.sh
#
#
# Backs up all the files and database of live site
#
#  Usage:
# ./backup-all-dev.sh
# 
#
# @author <andrew@nomstock.com>
#################






#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read the config file
source "${DIR%%/}/config-bash.conf";

#read the advanced config file
source "${DIR%%/}/config-bash-advanced.conf";



#files
command "${DIR%%/}/backup-files-dev.sh";
#database
command "${DIR%%/}/backup-database-dev.sh";

#tar database file to file location.
gzip -c  ${DEV_BACKUP_FILE} > ${LOCAL_BACKUP_DIR}/${DOMAIN}-DEV-${ARCHIVE_FILE_ENDING}.sql.gz