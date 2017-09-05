#!/usr/bin/bash

#################
# set-permissions-live.sh
#
#
#################



#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read the config file
source "${DIR%%/}/config-bash.conf";



#######################
#
# Set Permissions
#
########################


command="cat ${DIR%%/}/config-bash.conf ${DIR%%/}/set-permissions-live.inc.sh |ssh ${SSH_CONN} bash -s"

eval $command;


echo '##### Completed Setting live Permissions ######';


#############################