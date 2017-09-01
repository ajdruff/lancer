#!/usr/bin/bash

#################
# setup-repo-local.sh
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




#git remote add origin ssh://user@example.com/home/username/.git
cd ${LOCAL_REPO_PATH}

#skip worktree
command "${DIR%%/}/git-skip-worktree.sh";





#clone the remote directory to local. this will create the correct origin
git clone ssh://${SSH_CONNECTION}${LIVE_DIR_PATH}/.git ${LOCAL_REPO_PATH}/

#copy the web template into the repo directory
command "${DIR%%/}/setup-home.sh";



cd ${LOCAL_REPO_PATH}




#prevent git from tracking file permission changes.
#this is important to keep both cygwin and Git for Windows in sync
git config core.filemode false;

git add .


#initial commit
git commit -a -m 'initial commit'

#skip worktree password files
command "${LOCAL_REPO_PATH%%/}/config/git-skip-worktree.sh";



#create and checkout a dev branch
git checkout -b dev master
