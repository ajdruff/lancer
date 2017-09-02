#!/bin/bash

#################
# post-receive
#
# This script resets the Live Branch to Master
# Upon receipt of a Push to Origin/Master
# It also saves any changes that occurred in Live Branch as 
# an Archive-Live branch
# 
# Usage:
# Add this to the hooks/ directory of your 
#
# @author <andrew@nomstock.com>
#
###################################

#############################
# Directory
##############################

#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#read common variables for all bash scripts
source "${DIR%%/}/config-bash.conf";
source "${DIR%%/}/config-bash-advanced.conf";


#############################
# Configure
##############################

LOGFILE="${DIR%%/}/post-receive.log";
WORKTREE="${LIVE_DIR_PATH}";
ARCHIVE_BRANCH=LIVE-ARCHIVE-$( date +%Y-%m-%d-%H-%M-%S)
ARCHIVE_BRANCH=LIVE-ARCHIVE-"${ARCHIVE_FILE_ENDING}"
#############################
# Initialize
##############################
#set vars
CHANGED=$(git --work-tree=${WORKTREE} status --porcelain);
LIVE_BRANCH_EXISTS=`git --work-tree=${WORKTREE} show-ref refs/heads/live`





########################
# Include functions library
########################

#read common variables for all bash scripts
source "${DIR%%/}/post-receive-functions.sh";

########################
# Main
########################



while read oldrev newrev refname
do


branch=$(git rev-parse --symbolic --abbrev-ref $refname)
echo -e "Push is for ${branch}" ;
    if [ "master" == "$branch" ]; then

echo -e "[log] Executing post-receive script for master $( date +%Y-%m-%d-%H-%M-%S)"  >> $LOGFILE;
echo -e "[log] Executing post-receive script for master $( date +%Y-%m-%d-%H-%M-%S)" ;
# Make sure we are on the live branch
checkoutLive;

# Create an Archive Branch that contains any changes since last update
archiveLiveChanges;



# Reset the Live Branch to be the same as the master
resetLiveToMaster;




	fi
done