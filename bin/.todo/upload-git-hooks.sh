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
# cat ${DIR%%/}/commands.inc.sh | ssh ${SSH_CONN} 'bash -s';
# git init;
#or
# use source + echo . this allows you to source in local scripts  
# cat ${DIR%%/}/commands.inc.sh | ssh ${SSH_CONN} 'bash -s';
# echo 'git init';


scp ${DIR%%/}/post-receive.sh ${SSH_CONN}:.git/hooks/post-receive;
scp ${DIR%%/}/post-receive-functions.sh ${SSH_CONN}:.git/hooks/post-receive-functions.sh;
scp ${DIR%%/}/config-bash.conf ${SSH_CONN}:.git/hooks/config-bash.conf;
scp ${DIR%%/}/config-bash.conf ${SSH_CONN}:.git/hooks/config-bash-advanced.conf;

scp ${DIR%%/}/git-info-exclude.conf ${SSH_CONN}:.git/info/exclude;

echo 'chmod 700 .git/hooks/post-receive' | ssh ${SSH_CONN} 'bash -s';
echo 'chmod 700 .git/hooks/config-bash.conf' | ssh ${SSH_CONN} 'bash -s';
echo 'chmod 700 .git/hooks/config-bash-advanced.conf' | ssh ${SSH_CONN} 'bash -s';
echo 'Completed post receive upload';