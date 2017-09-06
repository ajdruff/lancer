#!/usr/bin/env bash

#################
# 
#
#
# Backs up database
#
#  Usage:
# ./backup-db.sh live/dev/stage [dry]
#
#
# @author <andrew@nomstock.com>
# @todo :Examine scripts and split out getEnvVars to be specific for each script since there are target and sources.
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#get the configuration variables   
source "${DIR%%/}/.bin/lancer.conf.sh";

#include common functions
source "${DIR%%/}/.bin/functions.sh";

#include backup files functions
source "${DIR%%/}/.bin/functions.backup-db.sh";

#check that server environment was passed
setServerEnvFromArg $1

#Now that we know environment, get appropriate values
getEnvVars



setSourceDBVars
setMysqlDumpArgs ${1} ${2}
makeDestinationDirectory


#create .my.cnf files to 
createMyCnf


#
backupDB
compressDB
showBackupCommand
showCompressCommand
showBackupCompleteMessage