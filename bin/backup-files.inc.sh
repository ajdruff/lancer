#!/usr/bin/bash

#################
# backup-files.inc.sh
#
#
# Backs up files to local directory
# Never use standalone - always include in a another bash file 
# See the backup-files-dev.sh to see how this should be included.
# Running this will rsync the directory to your backups folder, then compress it to a separate file.
# So the rsync'd target will always contain the most current snapshot. 

#################





#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)

#read the config file
source "${DIR%%/}/config-bash.conf";

#read the advanced config file
source "${DIR%%/}/config-bash-advanced.conf";




if [[ "${SOURCE_DIRECTORY_IS_REMOTE}" == true ]]; then

SOURCE_DIRECTORY_PATH="-e ssh ${SSH_CONNECTION}:${SOURCE_DIRECTORY_PATH}"


fi




#######################
#
# Rsync to target
#
########################


mkdir -p ${LOCAL_BACKUP_DIR};

#################
# Compression
#################

# Compression type
if [ "${COMPRESSION}" = "zip" ]; then
compress_option="zip -r ";
compress_file_suffix="zip";
else 
#tar is failsafe. in case someone uses an invalid compression type
compress_option="tar -zcvf ";
compress_file_suffix="tar.gz";
fi

# Check for Dry Run
if [[ "${DRY_RUN}" == true ]]; then 
command="rsync  -azvH   --delete  --dry-run  ${SOURCE_DIRECTORY_PATH} ${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}";
compress_command="${compress_option}  /dev/null ${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}";
else
mkdir -p "${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}";
command="rsync  -azvH   --delete  ${SOURCE_DIRECTORY_PATH} ${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}";



compress_command="${compress_option}  ${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}-${SOURCE_ENVIRONMENT}-${ARCHIVE_FILE_ENDING}.${compress_file_suffix}  ${LOCAL_BACKUP_DIR}/${SOURCE_DOMAIN}" 
fi
echo $SOURCE_DIRECTORY_PATH
echo $command;



#backup
eval $command;


echo '########### Backup Command Used: ######';
echo $command



if [ "${COMPRESSION}" != "none" ]; then
echo '########### Compression Command Used: ######';
echo $compress_command
eval $compress_command;
echo '########### Compression Command Used: ######';
echo $compress_command
fi


#######################
#
# Dry Run Messaging
#
########################
if [[ "${DRY_RUN}" == true ]]; then 
echo '##############################################';
echo '########### Backup Executed as a Dry Run ######';
echo '##############################################';
fi

#######################
