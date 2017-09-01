#!/usr/bin/bash

#################
# git-archive-live.sh
#
#
# Creates a remote branch that is a copy of the live branch
#
#  Usage:
# ./git-archive-live.sh
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
source "${DIR%%/}/config-bash-advanced.conf";



echo 'Creating an archive branch from the remote live ranch';


ARCHIVE_BRANCH=LIVE-ARCHIVE-"${ARCHIVE_FILE_ENDING}"

#execute the create branch command on the remote server
echo "git add . && git commit -am 'Archived live changes'"  | ssh ${SSH_CONNECTION} 'bash -s';
echo "git branch ${ARCHIVE_BRANCH} live"  | ssh ${SSH_CONNECTION} 'bash -s';

#fetch the branches and show them

cd ${LOCAL_REPO_PATH}
git fetch;
git branch -a;

echo 'Completed archiving the live branch';