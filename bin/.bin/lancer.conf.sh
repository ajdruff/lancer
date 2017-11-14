#!/usr/bin/bash

#################
# 
#
#
# Include configuration variables and process them.
# 
#
#
# @author andrew@nomstock.com
# @todo: Replace references of DIR_PARENT with LANCER_DIR
# @todo: make sure all variables with paths are stripped of trailing slash

#################


#get the parent directory of calling script
#this works because calling script is in bin and its including this file.
LANCER_DIR=$(dirname ${DIR%%/})

#order of inclusion is important. lancer.conf must come after .lancer-conf
#this allows you to change values of .lancer-conf by adding the variable to lancer-conf and changing it to its new value, avoding over-writing 'factory defaults' and leading to git modifictions.

#read variables in hidden advanced configuration file in .lancer-conf
lancer_hidden_conf="${LANCER_DIR%%/}/etc/.lancer-conf"
source <(grep = ${lancer_hidden_conf} | sed 's/ *= */=/g')


#read variables in lancer.conf
lancer_conf="${LANCER_DIR%%/}/etc/lancer.conf"
source <(grep = ${lancer_conf} | sed 's/ *= */=/g')


#strip trailing slash ref: https://stackoverflow.com/a/1848456/3306354
LIVE_FILE_ROOT=${LIVE_FILE_ROOT%/}
DEV_FILE_ROOT=${DEV_FILE_ROOT%/}
STAGING_FILE_ROOT=${STAGING_FILE_ROOT%/}
CACHE_DIR="${CACHE_DIR%/}"


LIVE_TARGET_PUBLISH_DIR=${LIVE_TARGET_PUBLISH_DIR%/}
DEV_TARGET_PUBLISH_DIR=${DEV_TARGET_PUBLISH_DIR%/}


#check that cache directory exists
mkdir -p "${CACHE_DIR}"
mkdir -p "${ARCHIVES_DIR}"


