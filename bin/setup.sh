#!/usr/bin/bash

#################
# setup.sh
#
#
# Overwrites the Staging Database with the Dev Database 
#
#  Usage:
# ./load-staging-database-with-dev.sh
#
#
# @author <andrew@nomstock.com>
#
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)



eval "setfacl -r -b ${DIR}/";
eval "find ${DIR}/ -type d -exec chmod 755 {} \;";
eval "find ${DIR}/ -type f -exec chmod 744 {} \;";
#remote repo
command "${DIR%%/}/setup-repo-remote.sh";
#local repo
command "${DIR%%/}/setup-repo-local.sh";