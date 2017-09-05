#!/usr/bin/bash

#################
# 
#
#
# Description
# 
#
#
# @author andrew@nomstock.com
# @todo:
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#get the configuration variables
source "${DIR%%/}/.bin/lancer.conf.sh";

#include common functions
source "${DIR%%/}/.bin/functions.sh";

#check that server environment was passed
setServerEnvFromArg $1

#Now that we know environment, get appropriate values
getEnvVars
