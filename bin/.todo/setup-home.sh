#!/usr/bin/bash

#################
# setup-home.sh
#
#
# Copies over the configured template into the home directory
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


mkdir -p ${LOCAL_REPO_PATH};


#copy the template into the repo directory
command="cp  -rv ${SITE_TEMPLATE_PATH}/* ${LOCAL_REPO_PATH}"
eval $command;

command="cp  -v ${SITE_TEMPLATE_PATH}/.gitignore ${LOCAL_REPO_PATH}"
eval $command;
command="cp  -v ${SITE_TEMPLATE_PATH}/.gitattributes ${LOCAL_REPO_PATH}"
eval $command;

#make sure the repo ignores the _dev and _live configuration directories
command="echo -e \"\n_live\n_stage\" >>${LOCAL_REPO_PATH}/.gitignore;"
eval $command;

#run skip worktree script in local repo
command "${LOCAL_REPO_PATH}/config/git-skip-worktree.sh";