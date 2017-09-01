#!/usr/bin/bash

#################
# load-staging-database-with-dev.sh
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

#read common variables for all bash scripts
source "${DIR%%/}/config-bash.conf";

# use cat + no echo 
# cat ${DIR%%/}/commands.inc.sh | ssh ${SSH_CONNECTION} 'bash -s';
# git init;
#or
# use source + echo . this allows you to source in local scripts  
# cat ${DIR%%/}/commands.inc.sh | ssh ${SSH_CONNECTION} 'bash -s';
# echo 'git init';
source ${DIR%%/}/setup-repo-remote.inc.sh | ssh ${SSH_CONNECTION} 'bash -s';

echo 'Creating New Repo on remote server and uploading post-receive script';

source ${DIR%%/}/upload-git-hooks.sh;

echo 'Completed remote repo creation';