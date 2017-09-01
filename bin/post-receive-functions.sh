#!/usr/bin/bash

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
echo loaded post-receive-functions;

#############################
# Checkout Live Branch
#
# Make sure we are on the Live Branch
#
##############################

function checkoutLive {



if [ -n "$LIVE_BRANCH_EXISTS" ]; then
git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git checkout live;
	echo -e 'checked out live branch';

else

git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git checkout -b live;
 echo -e 'created new live branch';

fi

}


#############################
# archive Live Changes
#
# Save any File Changes
# from last Live Commit
# these should have already made 
# it into Dev but saving them just in case

# this may look a little odd, i commit, create a new branch, and then switch back to live branch
# the reason we do it this way is that it captures all changes in both branches, before resetting
# the live branch to match the master. it works great, don't screw it up. 
#
##############################

function archiveLiveChanges() {





#############################
#
# Create a new archived live branch saving the changes
#
##############################

if [ -n "${CHANGED}" ]; then

STATUS_MESSAGE="Live Site Changed Since Previous Commit, archiving those changes before applying Master";
COMMIT_MESSAGE="Archived Site Changes from latest Live Release, prior to applying Master. Maybe admin tweaked css or added plugins?";

else

STATUS_MESSAGE="Archiving Last Live Commit prior to applying Master";
COMMIT_MESSAGE="Archived Last Live Commit prior to applying Master";

fi

# Update Git User
echo -e ${STATUS_MESSAGE};

#############################
#
# Add any new files
#
##############################
# note that when using --git-dir and work-tree, you cant just use git add . , you need to specify the filespec, git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git add  ${WORKTREE}/
# if you dont you'll see some strange failures.
git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git add  ${WORKTREE}
#############################
#
# Commit Live
#
##############################
echo -e "commiting  to live";
git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git commit -a -m "${COMMIT_MESSAGE}" ;


#############################
#create a new archive branch based on live
##############################
echo -e "creating archive branch ${ARCHIVE_BRANCH}";
git --work-tree=${WORKTREE}   --git-dir=${WORKTREE}/.git checkout -f -b "${ARCHIVE_BRANCH}" live



#############################

#checkout main Live Branch again
##############################

git --work-tree=${WORKTREE}  --git-dir=${WORKTREE}/.git checkout live


}



function resetLiveToMaster {

#############################
# reset Live back to master or alternately, do a rebase master live to preserve admin changes
##############################

cd ${WORKTREE};
echo 'cleaning worktree';
git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git  clean -fd ${WORKTREE};

git --work-tree=${WORKTREE} --git-dir=${WORKTREE}/.git  reset --hard master;



}