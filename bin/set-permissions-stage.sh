#!/usr/bin/bash

#################
# set-permissions-stage.sh
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


command="cat ${DIR%%/}/config-bash.conf ${DIR%%/}/set-permissions-stage.inc.sh |ssh ${SSH_CONNECTION} bash -s"

eval $command;


echo '##### Completed Setting Stage Permissions ######';


#############################