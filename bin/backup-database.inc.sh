#!/usr/bin/bash

#################
# backup-database.inc.sh
#
#
# Core library for backing up a database to the local directory defined by SOURCE_BACKUP_FILE
#
#
#
# @author <andrew@nomstock.com>
#
#################
 
######################
#
# Setup Tunnel if Needed
#
######################

if [[ "${SOURCE_DATABASE_IS_REMOTE}" == true ]] ; then 
## setup tunnel
echo 'Creating SSH Tunnel to secure remote MySQL connection';
ssh -f -o ExitOnForwardFailure=yes -L "${LOCAL_SSH_FORWARDING_PORT}":localhost:3306 "${SSH_CONNECTION}" sleep 10;

fi


######################
#
# Backup Source Database
#
######################

echo "Making a Copy of Database ${SOURCE_DB_NAME} to ${SOURCE_BACKUP_FILE}" ;


if [ -f "${SOURCE_BACKUP_FILE}" ] ; then
rm "${SOURCE_BACKUP_FILE}"
fi

#make sure there is a temp directory to dump to
mkdir -p $(dirname "${SOURCE_BACKUP_FILE}");

#change to the current directory
#this is required since --defaults-file cant take an absolute path without interpreting the path wrong.
cd "${DIR%%/}"; 


if [[ "${SOURCE_DATABASE_IS_REMOTE}" == true ]]; then 
echo 'MySQL connecting to source database over SSH tunnel';
    #backup live database
    command="mysqldump --defaults-file=${SOURCE_MYSQL_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1 ${SOURCE_DB_NAME} > ${SOURCE_BACKUP_FILE}";
  
  
else
echo 'MySQL connecting to source database over local connection';
command="mysqldump --defaults-file=${SOURCE_MYSQL_DEFAULTS_FILE} ${SOURCE_DB_NAME} > ${SOURCE_BACKUP_FILE}";


fi

echo "command  = $command";
eval $command;

echo 'Compressing temporary backup file and copying it to the final backup location';

#tar database file to backup location
command="gzip -c  ${SOURCE_BACKUP_FILE} > ${LOCAL_BACKUP_DIR}/${DOMAIN}-${ENVIRONMENT}-${ARCHIVE_FILE_ENDING}.sql.gz";

#gzip -c  ${SOURCE_BACKUP_FILE} > ${LOCAL_BACKUP_DIR}/${DOMAIN}-${ENVIRONMENT}-${ARCHIVE_FILE_ENDING}.sql.gz
echo "command  = $command";
eval $command;

echo "${DEST_DB_NAME} database has been updated";