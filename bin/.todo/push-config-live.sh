#!/usr/bin/bash

#################
# push-configs.sh
#
#
# Description
#
#  Usage:
# ./push-configs.sh
#
#
# @author <user@example.com>
#
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read common variables for all bash scripts
source "${DIR%%/}/config-bash.conf";


#config 
DRY_RUN=false; ## set to true to add --dry-run

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
# Rsync to live
#
########################

command="rsync  -azvH   ${dry_run_option} ${LOCAL_REPO_PATH}/_live/*  -e ssh ${SSH_CONN}:${LIVE_DIR_PATH}";
#echo $command;
eval $command;

#run skip worktree. this ensures that any edits of password files wont be committed.
command="ssh ${SSH_CONN} sh ${LIVE_DIR_PATH}/config/git-skip-worktree.sh";
eval $command;