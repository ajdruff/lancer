#!/usr/bin/bash

#################
# push-files-dev-to-stage.sh
#
#
# Uses Rsync to Push Dev files to Staging area
#
#################



#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read the config file
source "${DIR%%/}/config-bash.conf";

#config 
DRY_RUN=false; ## set to true to add --dry-run
PREVENT_LOGIN="${STAGE_PREVENT_LOGIN}"; ## set to true to prevent login and admin access


#######################
#
# Dry Run Option
#
########################

if [[ "${DRY_RUN}" == true ]]; then 

dry_run_option=" --dry-run ";

fi

#######################
#
# Rsync to target
#
########################


command="rsync  -azvH --delete  ${dry_run_option} ${LOCAL_REPO_PATH%%/}/${HTML_DIRNAME}  -e ssh ${SSH_CONN}:${STAGE_DIR_PATH}";

eval $command;


#######################
#
# Dry Run Messaging
#
########################
if [[ "${DRY_RUN}" == true ]]; then 
echo '##############################################';
echo '########### Rsync Executed as a Dry Run ######';
echo '##############################################';
echo '########### Rsync Command Used: ######';

echo $command;
echo '##############################################';
fi

#######################



#rsync local config
command="rsync  -azvH   ${dry_run_option} ${LOCAL_REPO_PATH}/_stage/*  -e ssh ${SSH_CONN}:${STAGE_DIR_PATH}";
#echo $command;
eval $command;


#######################
#
# Update Permisssions
#
########################


command "${DIR%%/}/set-permissions-stage.sh";

#############################