#!/bin/bash

#################
# setup-repo-remote.sh
#
#
# Creates a remote repo and adds the post-receive script.
#
#  Usage:
#  either run this script locally or include in setup-repo-remote.sh
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

echo "git init";

echo "git checkout --orphan master";
echo "git checkout --orphan live";

echo "git config --global user.email ${GIT_USER_EMAIL}";
echo "git config --global user.name ${GIT_USER_NAME}";
exit;
# add here your git ignore file (see archived example)
# setup the post-receive-hook
#cp .git/hooks/post-receive.sample .git/hooks/post-receive;
#chmod o+x .git/hooks/post-receive;
#create the  functions file ( this should be replaced with a scp)
cp .git/hooks/post-receive.sample .git/hooks/post-receive-functions.sh;

#need to create orphan branches or
git checkout --orphan master;
git checkout --orphan live;
echo ${GIT_USER_EMAIL};
git config --global user.email ${GIT_USER_EMAIL};
git config --global user.name "${GIT_USER_NAME}";