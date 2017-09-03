#!/usr/bin/bash

#################
# 
#
#
# Uploads Public Key and Sets proper permissions for PPK access
#
#  Usage:
# 
#
#
# @author andrew@nomstock.com
# @todo: Add error handling for ssh script.

#################


#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#get the configuration variables
source "${DIR%%/}/.bin/lancer.conf.sh";

#include common functions
source "${DIR%%/}/.bin/functions.sh";

#check that server environment was passed
setServerEnvFromArg $1

#Now that we know environment, get appropriate values
getEnvVars

#set PUBLIC_KEY
setPublicKey

#Stop Upload if Key Has Already Been Uploaded
preventDuplicateKeyUpload



#add our public key to authorized_keys
remote_command="\
mkdir -p ${REMOTE_DIR_PATH}/.ssh;\
chmod  700 ${REMOTE_DIR_PATH}/.ssh;\
chmod 700 ${REMOTE_DIR_PATH}/.ssh/authorized_keys;\
chmod 700 ${REMOTE_DIR_PATH}/.ssh/authorized_keys-backup;\
cp ${REMOTE_DIR_PATH}/.ssh/authorized_keys \"${REMOTE_DIR_PATH}/.ssh/authorized_keys-backup\";\

echo \""${PUBLIC_KEY}\"" >> ${REMOTE_DIR_PATH}/.ssh/authorized_keys;\
chmod 500 ${REMOTE_DIR_PATH}/.ssh/authorized_keys;\
chmod 500 \"${REMOTE_DIR_PATH}/.ssh/authorized_keys-backup\";\
chmod  500 ${REMOTE_DIR_PATH}/.ssh;\
";  






message="Press [Enter] to  upload your public key to the remote server..."

show_remote_exec_message "${message}"







exec_remote "${remote_command}" 

#track the keys that have been uploaded so we don't duplicate the upload
echo "\"${PUBLIC_KEY}\"" >> "${UPLOADED_KEYS_FILE}"





echo "Completed Key Upload";