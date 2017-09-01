#!/usr/bin/bash

#################
# git-skip-worktree.sh
#
#
# Description
#
#  Usage:
# ./git-skip-worktree.sh
#
# You should never have to use this since we should never be committing any config files that are in the admin folder (they are ignored).
# Purpose is to prevent any configuration files from being pushed to the central repo, preventing any potential security configuration info to be exposed.
# @author <andrew@nomstock.com.com>
#
#################
 
skip_worktree='--skip-worktree';
options=':n'
while getopts $options option
do
    case $option in
        n  )    skip_worktree='--no-skip-worktree';;
    esac
done

shift $(($OPTIND - 1))


#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR);
#read common variables for all bash scripts
#source "${DIR%%/}/config-bash.conf";

#git update-index --skip-worktree "conf-*";
command="git update-index ${skip_worktree} ${DIR%%/}/config-*";
eval $command;
command="git update-index ${skip_worktree} ${DIR%%/}/change-password.sql";
eval $command;
command="git update-index ${skip_worktree} ${DIR%%/}/create-new-admin-user.sql";
eval $command;


# list all those being skipped
echo 'git will skip the following files';
git ls-files -v . | grep ^S

