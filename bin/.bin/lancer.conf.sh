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
#################


#get the parent directory of calling script
#this works because calling script is in bin and its including this file.
LANCER_DIR=$(dirname ${DIR%%/})


#read variables in lancer.conf
lancer_conf="${LANCER_DIR%%/}/etc/lancer.conf"
source <(grep = ${lancer_conf} | sed 's/ *= */=/g')


#read variables in hidden advanced configuration file in .lancer-conf
lancer_hidden_conf="${LANCER_DIR%%/}/etc/.lancer-conf"
source <(grep = ${lancer_hidden_conf} | sed 's/ *= */=/g')


#strip trailing slash ref: https://stackoverflow.com/a/1848456/3306354
LIVE_DIR_PATH=${LIVE_DIR_PATH%/}
DEV_DIR_PATH=${DEV_DIR_PATH%/}
STAGING_DIR_PATH=${STAGING_DIR_PATH%/}
CACHE_DIR="${CACHE_DIR%/}"


#check that cache directory exists
mkdir -p $CACHE_DIR



