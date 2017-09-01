

#check $1 is a valid environment
function getServerEnvFromArg()
{
   if [ $# -eq 0 ]
  then
    echo "Missing argument: server environment for key destination (live,staging,or dev)"
    exit;
fi
if [[ $1 != live ]] && [[ $1 != dev ]] && [[ $1 != stage ]] ; then
        echo "Invalid argument: server environment for key destination must b (live,dev, or stage)"
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
echo $SSH_USER

#SSH_HOST
var="$SERVER_ENV"_SSH_HOST
SSH_HOST="${!var}"
echo $SSH_HOST

#SSH_CONNECTION
SSH_CONNECTION="${SSH_USER}"@"${SSH_HOST}"
echo $SSH_CONNECTION







#REMOTE_DIR_PATH
var="$SERVER_ENV"_DIR_PATH
REMOTE_DIR_PATH="${!var}"
echo $REMOTE_DIR_PATH;

}



#Checks cache that holds uploaded keys to see if key has already been uploaded
#exits if it does
function preventDuplicateKeyUpload ()
{
#UPLOADED_KEYS_FILE is the local file that keeps track of any public keys that are uploaded. we wont upload the same key if it exists in this file.

UPLOADED_KEYS_FILE="${CACHE_DIR}"/"${SERVER_ENV}"_uploaded_keys


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
echo exists
DEV_PUBLIC_KEY=$( cat "${DEV_LOCAL_PUBLIC_KEY_PATH}" )
fi

if [ -e "${STAGE_LOCAL_PUBLIC_KEY_PATH}" ]
then
STAGE_PUBLIC_KEY=$( cat "${STAGE_LOCAL_PUBLIC_KEY_PATH}" )
fi


var="$SERVER_ENV"_PUBLIC_KEY
PUBLIC_KEY="${!var}"

}
