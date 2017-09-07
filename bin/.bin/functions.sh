#!/usr/bin/bash

#################
# 
#
#
# Description
#
#  Usage:
# 
#
#
# @author andrew@nomstock.com
# @todo low: consider refactoring to use get_script_dir. see http://www.ostricher.com/2014/10/the-right-way-to-get-the-directory-of-a-bash-script/
# @todo low: consider downloading authorized_keys file to cache and using it to compare key for upload instead of to cached file.
#################


#sets SERVER_ENV variable from passed $1 argument
function setServerEnvFromArg()
{
   if [ $# -eq 0 ]
  then
    echo "Missing argument: server environment (live,dev,or stage)"
    exit;
fi
if [[ $1 != live ]] && [[ $1 != dev ]] && [[ $1 != stage ]] ; then
        echo "Invalid argument: server environment must be (live,dev, or stage)"
else

#capitalize ENV
SERVER_ENV=$(echo $1 | awk '{print toupper($1)}')
    
fi

}



#uses dynamic variables to assign values to variables that change with environment
function getEnvVars()
{

#assign variables for environment
#ref: https://stackoverflow.com/a/10757531/3306354
#SSH_USER
var="$SERVER_ENV"_SSH_USER
SSH_USER="${!var}"


#SSH_HOST

var="${SERVER_ENV}"_SSH_HOST
SSH_HOST="${!var}"


#SSH_CONN ; we use SSH_CONNECT since SSH_CONNECTION is a system variable
SSH_CONN="${SSH_USER}"@"${SSH_HOST}"

#REMOTE_FILE_ROOT
var="$SERVER_ENV"_FILE_ROOT
REMOTE_FILE_ROOT="${!var}"

##Backup Files
#SOURCE_SSH_FILE_ACCESS
var="$SERVER_ENV"_SSH_FILE_ACCESS
SOURCE_SSH_FILE_ACCESS=$(echo "${!var}" | xargs ); 

#SOURCE_DIRECTORY
var="$SERVER_ENV"_FILE_ROOT
SOURCE_DIRECTORY_PATH="${!var}"


#RSYNC_EXCLUDE_FILE
var="$SERVER_ENV"_RSYNC_EXCLUDE_FILE
RSYNC_EXCLUDE_FILE="${!var}"







}





#Checks cache that holds uploaded keys to see if key has already been uploaded
#exits if it does
function preventDuplicateKeyUpload ()
{
#UPLOADED_KEYS_FILE is the local file that keeps track of any public keys that are uploaded. we wont upload the same key if it exists in this file.

UPLOADED_KEYS_FILE="${CACHE_DIR}"/"${SERVER_ENV}"_uploaded_keys


if [[ "${PUBLIC_KEY}" == "" ]];then

echo 'Public Key is empty, exiting...';
exit;
fi


#if the uploaded keys file exists, check if it contains the public key
if [ -e ${UPLOADED_KEYS_FILE} ]

then

local_key_file=$( cat "${UPLOADED_KEYS_FILE}" )
        if [[ "${local_key_file}" == *"${PUBLIC_KEY}"* ]];then
        echo Key is already uploaded to this server. To reset, remove it from  "${UPLOADED_KEYS_FILE}"
exit;
    fi

#doesnt exist

fi

}



#checks for local key paths then uses variable variables to assign $PUBLIC_KEY
function setPublicKey()

{

#Initialize
LIVE_PUBLIC_KEY=
DEV_PUBLIC_KEY=
STAGE_PUBLIC_KEY=

if [ -e "${LIVE_LOCAL_PUBLIC_KEY_PATH}" ]
then
LIVE_PUBLIC_KEY=$( cat "${LIVE_LOCAL_PUBLIC_KEY_PATH}" )
fi

if [ -e "${DEV_LOCAL_PUBLIC_KEY_PATH}" ]
then
DEV_PUBLIC_KEY=$( cat "${DEV_LOCAL_PUBLIC_KEY_PATH}" )
fi

if [ -e "${STAGE_LOCAL_PUBLIC_KEY_PATH}" ]
then
STAGE_PUBLIC_KEY=$( cat "${STAGE_LOCAL_PUBLIC_KEY_PATH}" )
fi


var="$SERVER_ENV"_PUBLIC_KEY
PUBLIC_KEY=$(echo "${!var}" | xargs ); #xargs to trim spaces

if [[ "${PUBLIC_KEY}" == "" ]];then

echo 'Public Key is empty, exiting...';
exit;
fi

}



function show_remote_exec_message()
{

local message
message=$(echo -e "${1}")

read -p "${message}"

}


function exec_remote()
{

remote_command="${1}";

echo "${remote_command}" | ssh ${SSH_CONN} 'bash -s';


}












#like it says
#usage var=$( trim " something " ) #'something';
function trim()
{
echo "   ${1}  " | xargs
}





get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}



#debug message
function debugM {

if [[ "${LANCER_DEBUG}" == true ]]; then
echo -e "DEBUG:${1}"
fi

}


spinner()
{
#usage: do_something & spinner

    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

