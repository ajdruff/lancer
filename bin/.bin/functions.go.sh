#!/usr/bin/bash


#################
# 
#
#  
# Functions to backup files to local directory.
# This will    the source directory to your backups folder, then compress it.
# rsync is used for these reasons: https://stackoverflow.com/a/20257021/3306354
#
# @author andrew@nomstock.com
# @todo db1.0 :create query script
# @todo db1.1:revise file backup script to follow same function pattern and function names 
#################



#sets SERVER_ENV variable from passed $1 argument

################################
function setTargetServerEnv()
################################
{
   if [ $# -eq 0 ]
  then
    echo "Missing argument: server environment (live or stage)"
    exit;
fi
if [[ $1 != live ]] && [[ $1 != dev ]] && [[ $1 != stage ]] ; then
        echo "Invalid argument: server environment must be live or stage"
else

#capitalize ENV
TARGET_SERVER_ENV=$(echo $1 | awk '{print toupper($1)}')
    
fi

}




################################
function setTargetServerVars() {
############################

TARGET_SERVER_ENV="${1}"

#TARGET_PUBLISH_DIR
var="${TARGET_SERVER_ENV}"_TARGET_PUBLISH_DIR
TARGET_PUBLISH_DIR=$(echo "${!var}" | xargs ); 


#TARGET_SSH_DB_ACCESS
var="${TARGET_SERVER_ENV}"_SSH_DB_ACCESS
TARGET_SSH_DB_ACCESS=$(echo "${!var}" | xargs ); 


#TARGET_SSH_FILE_ACCESS
var="${TARGET_SERVER_ENV}"_SSH_FILE_ACCESS
TARGET_SSH_FILE_ACCESS=$(echo "${!var}" | xargs ); 



#TARGET_MYSQL_DEFAULTS_FILE
var="${TARGET_SERVER_ENV}"_MYSQL_DEFAULTS_FILE
TARGET_MYSQL_DEFAULTS_FILE="${!var}"


#TARGET_DB_USER
var="${TARGET_SERVER_ENV}"_DB_USER
TARGET_DB_USER="${!var}"

#TARGET_DB_PASSWORD
var="${TARGET_SERVER_ENV}"_DB_PASSWORD
TARGET_DB_PASSWORD="${!var}"


#TARGET_DB_NAME
var="${TARGET_SERVER_ENV}"_DB_NAME
TARGET_DB_NAME="${!var}"

#TARGET_DB_PORT
var="${TARGET_SERVER_ENV}"_DB_PORT
TARGET_DB_PORT="${!var}"


#TARGET_DB_HOST
var="${TARGET_SERVER_ENV}"_DB_HOST
TARGET_DB_HOST="${!var}"



#TARGET_SSH_USER
var="${TARGET_SERVER_ENV}"_SSH_USER
TARGET_SSH_USER="${!var}"

#TARGET_SSH_HOST
var="${TARGET_SERVER_ENV}"_SSH_HOST
TARGET_SSH_HOST="${!var}"


#TARGET_SSH_CONN user@example.com for target system
TARGET_SSH_CONN="${TARGET_SSH_USER}"@"${TARGET_SSH_HOST}"



}



################################
function setSourceServerVars() {
############################
SOURCE_SERVER_ENV="${1}"




#SOURCE_PUBLISH_DIR
var="$SOURCE_SERVER_ENV"_SOURCE_PUBLISH_DIR
SOURCE_PUBLISH_DIR=$(echo "${!var}" | xargs ); 


#SOURCE_SSH_DB_ACCESS
var="$SOURCE_SERVER_ENV"_SSH_DB_ACCESS
SOURCE_SSH_DB_ACCESS=$(echo "${!var}" | xargs ); 

#SOURCE_MYSQL_DEFAULTS_FILE
var="$SOURCE_SERVER_ENV"_MYSQL_DEFAULTS_FILE
SOURCE_MYSQL_DEFAULTS_FILE="${!var}"


#SOURCE_DB_USER
var="$SOURCE_SERVER_ENV"_DB_USER
SOURCE_DB_USER="${!var}"

#SOURCE_DB_PASSWORD
var="$SOURCE_SERVER_ENV"_DB_PASSWORD
SOURCE_DB_PASSWORD="${!var}"


#SOURCE_DB_NAME
var="$SOURCE_SERVER_ENV"_DB_NAME
SOURCE_DB_NAME="${!var}"

#SOURCE_DB_PORT
var="$SOURCE_SERVER_ENV"_DB_PORT
SOURCE_DB_PORT="${!var}"


#SOURCE_DB_HOST
var="$SOURCE_SERVER_ENV"_DB_HOST
SOURCE_DB_HOST="${!var}"


#SOURCE_SSH_USER
var="${SOURCE_SERVER_ENV}"_SSH_USER
SOURCE_SSH_USER="${!var}"

#SOURCE_SSH_HOST
var="${SOURCE_SERVER_ENV}"_SSH_HOST
SOURCE_SSH_HOST="${!var}"


#SOURCE_SSH_CONN user@example.com for target system
SOURCE_SSH_CONN="${SOURCE_SSH_USER}"@"${SOURCE_SSH_HOST}"




}

###########################
function checkForDryRun ()
###########################
{
DRY_RUN=false; #default

if [[ "$2" == "dry" ]] || [[ "$2" == "dryrun" ]]
  then
    DRY_RUN=true;


fi
}


##################################################
function uploadFiles ()
##################################################
{



if [[ "${TARGET_SSH_FILE_ACCESS}" == true ]]; then

#use SSH if source is on remote server



uploadFilesRemote

else



uploadFilesLocal

fi



}



####################################
function uploadFilesLocal () 
####################################
{

upload_files_command_dryrun="rsync  -azvH --delete  --dry-run   ${SOURCE_PUBLISH_DIR} ${TARGET_PUBLISH_DIR}";


upload_files_command="rsync  -azvH --delete ${SOURCE_PUBLISH_DIR} ${TARGET_PUBLISH_DIR}";





if [[ "${DRY_RUN}" == true ]];then 

eval "${upload_files_command_dryrun}"
else




eval "${upload_files_command}"

fi










}


####################################
function uploadFilesRemote () 
####################################
{




#if debugging, do verbose output
rsync_options="-azh";

if [[ "${LANCER_DEBUG}"==true ]]
then
rsync_options="-azvh";
fi


upload_files_command_dryrun="rsync  ${rsync_options} --delete  --dry-run   ${SOURCE_PUBLISH_DIR}/ ${TARGET_SSH_CONN}:${TARGET_PUBLISH_DIR}-${LANCER_SUFFIX}"  & spinner;



upload_files_command="rsync  ${rsync_options} --delete ${SOURCE_PUBLISH_DIR}/ ${TARGET_SSH_CONN}:${TARGET_PUBLISH_DIR}-${LANCER_SUFFIX} & spinner";

echo 'uploading files..';

if [[ "${DRY_RUN}" == true ]];then 

eval "${upload_files_command_dryrun}"
else

#upload files 
eval "${upload_files_command}"

fi




}


####################################
function uploadDBLocal () 
####################################
{



#copy the my.cnf file to home directory. 
#we do this because virtualbox shared permissions can't be changed and we assume
#that lancer project folder is being shared.
cp "${LANCER_DIR}"/etc/"${MYSQL_DEFAULTS_FILE}" ~/"${MYSQL_DEFAULTS_FILE}"

#change permissions for security
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;


mysqldump --defaults-file="~/${MYSQL_DEFAULTS_FILE}" -h "${SOURCE_DB_HOST}" -P "${SOURCE_DB_PORT}" "${MYSQLDUMP_DB}">"${LOCAL_BACKUP_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}"/"${DOMAIN}-${SERVER_ENV}-${SOURCE_DB_NAME}.sql"


}


####################################
function uploadDBRemote () 
####################################
{



show_remote_exec_message "Press [Enter] to start backing up the ${SERVER_ENV} MySQL server";


#upload the mycnf file, output only error
scp ${LANCER_DIR}/etc/${MYSQL_DEFAULTS_FILE} ${SSH_CONN}:~/${MYSQL_DEFAULTS_FILE} 1>/dev/null


backup_command="
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

mysqldump --defaults-file=~/${MYSQL_DEFAULTS_FILE} -h ${SOURCE_DB_HOST} -P ${SOURCE_DB_PORT}  ${MYSQLDUMP_DB};
rm ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

"


#backup
ssh "${SSH_CONN}" "${backup_command}"> "${LOCAL_BACKUP_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}"/"${DOMAIN}"-"${SERVER_ENV}"-"${SOURCE_DB_NAME}".sql;





}

##################################################
function uploadDB ()
##################################################
{


if [[ "${SOURCE_SSH_FILE_ACCESS}" == true ]]; then

#use SSH if source is on remote server
backupDBServerRemote

else

backupDBServerLocal

fi



}





##################################################
function createMyCnf()
##################################################
{
local local_command="
USER=${SOURCE_DB_USER} PASSWORD=${SOURCE_DB_PASSWORD} envsubst < ${LANCER_DIR}/etc/${MYSQL_DEFAULTS_TEMPLATE} > ${LANCER_DIR}/etc/${MYSQL_DEFAULTS_FILE};
"
eval "${local_command}"

}


####################################
function backupDBServerLocal () 
####################################
{



#copy the my.cnf file to home directory. 
#we do this because virtualbox shared permissions can't be changed and we assume
#that lancer project folder is being shared.
cp "${LANCER_DIR}"/etc/"${MYSQL_DEFAULTS_FILE}" ~/"${MYSQL_DEFAULTS_FILE}"

#change permissions for security
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;


mysqldump --defaults-file="~/${MYSQL_DEFAULTS_FILE}" -h "${SOURCE_DB_HOST}" -P "${SOURCE_DB_PORT}" "${MYSQLDUMP_DB}">"${LOCAL_BACKUP_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}"/"${DOMAIN}-${SERVER_ENV}-${SOURCE_DB_NAME}.sql"


}


####################################
function backupDBServerRemote () 
####################################
{



show_remote_exec_message "Press [Enter] to start backing up the ${SERVER_ENV} MySQL server";


#upload the mycnf file, output only error
scp ${LANCER_DIR}/etc/${MYSQL_DEFAULTS_FILE} ${SSH_CONN}:~/${MYSQL_DEFAULTS_FILE} 1>/dev/null


backup_command="
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

mysqldump --defaults-file=~/${MYSQL_DEFAULTS_FILE} -h ${SOURCE_DB_HOST} -P ${SOURCE_DB_PORT}  ${MYSQLDUMP_DB};
rm ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

"


#backup
ssh "${SSH_CONN}" "${backup_command}"> "${LOCAL_BACKUP_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}"/"${DOMAIN}"-"${SERVER_ENV}"-"${SOURCE_DB_NAME}".sql;





}

##################################################
function backupDB ()
##################################################
{


if [[ "${SOURCE_SSH_FILE_ACCESS}" == true ]]; then

#use SSH if source is on remote server
backupDBServerRemote

else

backupDBServerLocal

fi



}




##################################################
function showUploadCommand() {
##################################################
message="
########### Upload Command Used: ######\n
$upload_files_command\n
";

debugM "${message}";



}





##################################################
function showGoLiveCompleteMessage() {
##################################################





message="
\n##################################
\n########### Go Live Complete #####
\n${SOURCE_SERVER_ENV} Deployment to ${TARGET_SERVER_ENV} is complete.
\n####################################
";

echo -e "${message}";




}



function makeArchivesDirectory() {


#files
mkdir -p "${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}";
mkdir -p "${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}"/"${FILES_BACKUP_DIRNAME}";
mkdir -p "${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}"/"${FILES_BACKUP_DIRNAME}"/"${MIRROR_BACKUP_DIRNAME}";



#database
mkdir -p "${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}"/"${DB_BACKUP_DIRNAME}";
mkdir -p "${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}"/"${DB_BACKUP_DIRNAME}"/"${MIRROR_BACKUP_DIRNAME}";

#/archives/LIVE/files
ARCHIVES_DIR_EXTENDED="${ARCHIVES_DIR}"/"${TARGET_SERVER_ENV}"/"${FILES_BACKUP_DIRNAME}";
}



##################################################
function archiveTargetFilesToLocal ()
##################################################
{
#Before rsyncing to target, 'archive' the target files by backing them up to the /lancer/archives folder

archived_dirname=$(basename "${TARGET_PUBLISH_DIR}")

#make sure the archives exist
makeArchivesDirectory

echo "copying old files to a local archive... [${ARCHIVES_DIR_EXTENDED}]"
if [[ "${TARGET_SSH_FILE_ACCESS}" == true ]]; then


#remote
rsync -azH --delete "${TARGET_SSH_CONN}":"${TARGET_PUBLISH_DIR}" "${ARCHIVES_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}/" 2>/dev/null & spinner


else

echo  -azH --delete "${TARGET_PUBLISH_DIR}" "${ARCHIVES_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}" 2>/dev/null & spinner

fi


#compress
tar --remove-files -zcf "${ARCHIVES_DIR_EXTENDED}"/"${DOMAIN}"-"${TARGET_SERVER_ENV}"-"${archived_dirname}"-"${ARCHIVE_FILE_ENDING}".tar.gz -C  "${ARCHIVES_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}" ./ 2>/dev/null & spinner





}

##########################################
function removeTargetFiles() {

#Moves to old files to ~./lancer-archives

###########################################


#########################
#
#  Caution - this will remove old files and shouldnt be done until you are ready to go live
#
#########################



#TARGET_PUBLISH_DIR="/home/adruff/www/clients/wwmattress/lancer/temp/log";
#cp -R /var/log log; # for testing only
archived_dirname=$(basename "${TARGET_PUBLISH_DIR}")
archived_path=$(dirname "${TARGET_PUBLISH_DIR}")
## abort if anything goes wrong

command="

mkdir -p "'$HOME'"/\"${ARCHIVES_DIR_REMOTE}\";

#only remove if there are uploaded files to take their place
if [[ -e \"${TARGET_PUBLISH_DIR}-${LANCER_SUFFIX}\" ]]
then

#archive only if it exists
if [[ -e \"${TARGET_PUBLISH_DIR}\" ]]
then

tar -zcf "'$HOME'"/\"${ARCHIVES_DIR_REMOTE}\"/\"${archived_dirname}\".tar.gz -C \"${archived_path}\"   \"${archived_dirname}\" && rm -R \"${TARGET_PUBLISH_DIR}\"

fi

else 
echo 'You need to upload files first before we can archive the old files.';
exit 125
fi




"


if [[ "${TARGET_SSH_FILE_ACCESS}" == true ]]; then

#execute remote command
#ssh "${TARGET_SSH_CONN}" "${command}" & spinner ;


local RESULTS;
ssh "${TARGET_SSH_CONN}" "${command}";

RESULTS=$?
if [ "$RESULTS" != 0 ]; then
  return $RESULTS
fi 


message="
########### archiveTargetOnRemote Command ##############


ssh ${TARGET_SSH_CONN}  \"${command}\"

########################################################
";

else

#execute local command
(${command});

RESULTS=$?
if [ "$RESULTS" != 0 ]; then
  return $RESULTS
fi 


message="
########### archiveTargetOnRemote Command ##############

${command}

########################################################
";
fi




debugM "${message}";


command="":


}


#########################
function makeUploadedFilesLive(){
#########################


set -e

archived_dirname=$(basename "${TARGET_PUBLISH_DIR}")
archived_path=$(dirname "${TARGET_PUBLISH_DIR}")


command="
set -e

mv \"${TARGET_PUBLISH_DIR}\"-\"${LANCER_SUFFIX}\"   \"${TARGET_PUBLISH_DIR}\"

"


if [[ "${TARGET_SSH_FILE_ACCESS}" == true ]]; then

#execute remote command
ssh "${TARGET_SSH_CONN}" "${command}" & spinner;


message="
########### makeUploadedFilesLive Command ##############


ssh ${TARGET_SSH_CONN}  \"${command}\"

########################################################
";

else

#execute local command
eval "${command}" & spinner;


message="
########### makeUploadedFilesLive Command ##############

${command}

########################################################
";
fi




debugM "${message}";



}



#########################
function goLive(){
#########################


if [[ "$2" == "!" ]]
  then


show_remote_exec_message "Press [Enter] to place online the new files that you uploaded to the ${TARGET_SERVER_ENV} server , \nfiles to be replaced: ${TARGET_PUBLISH_DIR}";


#moves old files out of the way into ~/.lancer-archives on target server
#removeTargetFiles && makeUploadedFilesLive

#moves new files into their place


if removeTargetFiles ; then
    #succeeded
     makeUploadedFilesLive
fi



#places new database online





else

show_remote_exec_message "Press [Enter] to publish files to ${TARGET_SERVER_ENV} Server and replace files in ${TARGET_PUBLISH_DIR}";


checkForDryRun "${1}" "${2}"
#do a full backup here...
archiveTargetFilesToLocal
uploadFiles
#uploadDB
showUploadCommand


echo "Files are uploaded, but they  will not ovewrite old files until you throw the '!' switch";




return
fi


showGoLiveCompleteMessage


}