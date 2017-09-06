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
# @todo:
#################

#####################################################
function setCompressionCommands () 
##################################################
{
compress_option="none";
if [ "${FILE_BACKUP_COMPRESSION}" = "zip" ]; then

compress_command="cd ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME}; zip -r ../${DOMAIN}-${SERVER_ENV}-${ARCHIVE_FILE_ENDING}.zip ./;cd -;" 

compress_command_dryrun="cd ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME}; zip -r - ./ | echo ;cd -;" 




fi

if [ "${FILE_BACKUP_COMPRESSION}" = "tar" ]; then
#tar is failsafe. in case someone uses an invalid compression type

compress_command="tar -zcvf ${LOCAL_BACKUP_DIR_EXTENDED}/${DOMAIN}-${SERVER_ENV}-${ARCHIVE_FILE_ENDING}.tar.gz -C  ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME} ./" 

compress_command_dryrun="tar -zcvf /dev/null -C  ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME} ./" 

fi


}
#####################################################
function checkIfRemoteSource() {
##################################################



#use SSH if source is on remote server
if [[ "${SOURCE_DIRECTORY_IS_REMOTE}" == true ]]; then
SOURCE_DIRECTORY_PATH="-e ssh ${SSH_CONN}:${SOURCE_DIRECTORY_PATH}"
fi

}

##################################################
function setBackupCommands ()
##################################################
{
setCompressionCommands

# Check for Dry Run

backup_command_dryrun="rsync  -azvH   --delete  --exclude-from ${LANCER_DIR}/etc/${RSYNC_EXCLUDE_FILE} --dry-run  ${SOURCE_DIRECTORY_PATH} ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME}";

backup_command="rsync  -azvH   --delete --exclude-from ${LANCER_DIR}/etc/${RSYNC_EXCLUDE_FILE} ${SOURCE_DIRECTORY_PATH} ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME}";



}

function makeDestinationDirectory() {
mkdir -p "${LOCAL_BACKUP_DIR}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${FILES_BACKUP_DIRNAME}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${FILES_BACKUP_DIRNAME}/${MIRROR_BACKUP_DIRNAME}";

#add some subdirectories to local backup path to help organize into server env and files/sql
LOCAL_BACKUP_DIR_EXTENDED="${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${FILES_BACKUP_DIRNAME}";
}



##################################################
function doBackup() {
##################################################

if [[ "${DRY_RUN}" == true ]];then 

eval "${backup_command_dryrun}"
else

eval "${backup_command}"

fi




}

##################################################
function showBackupCommand() {
##################################################
message="
########### Backup Command Used: ######\n
$backup_command\n
";

debugM "${message}";



}

##################################################
function showCompressCommand() {
##################################################
message="
########### Compression Command Used: ######\n
$compress_command\n
";

debugM "${message}";

}

##################################################
function compressFiles() {
##################################################

if [ "${COMPRESSION}" != "none" ]; then


if [[ "${DRY_RUN}" == true ]]; then 


eval "${compress_command_dryrun}"

else

eval "${compress_command}";

fi





fi
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
function showBackupCompleteMessage() {
##################################################

if [[ "${DRY_RUN}" == true ]]; then 

message="
\n##############################################
\n########### 'Backup' Complete, Executed as a Dry Run #####
\n##############################################
";

echo -e ${message};


else

message="
\n##################################
\n########### Backup Complete #####

\nFind Backup at :

\n"${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${FILES_BACKUP_DIRNAME}"

\n####################################
";

echo -e ${message};


fi

}

