#!/usr/bin/bash


#################
# backup-all-live.sh
#
#
# Backs up all the files and database of live site
#
#  Usage:
# ./backup-all-live.sh

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
command "${DIR%%/}/backup-files-live.sh";
#database
command "${DIR%%/}/backup-database-live.sh";

