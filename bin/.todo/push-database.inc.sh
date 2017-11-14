#!/usr/bin/bash

#################
# push-database.inc.sh
#
#
# Replaces Destination Database with Source Database Data
# Also converts the domain
#
# Never use standalone - always include in a another bash file 
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

if [[ "${SOURCE_DATABASE_IS_REMOTE}" == true ]] || [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 
## setup tunnel
echo 'Creating SSH Tunnel to secure remote MySQL connection';
ssh -f -o ExitOnForwardFailure=yes -L "${LOCAL_SSH_FORWARDING_PORT}":localhost:3306 "${SSH_CONN}" sleep 10;

fi


######################
#
# Backup Source Database
#
######################

echo "Making a Copy of Database ${SOURCE_DB_NAME} to ${SOURCE_BACKUP_FILE}" ;

#make sure there is a temp directory to dump to
temp_dir=$(dirname ${SOURCE_BACKUP_FILE});
mkdir -p "${temp_dir}";

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

#echo "command  = $command";
eval $command;

########################
#
# Update Destination Database
#
########################
echo "Updating ${DEST_DB_NAME} Database";

#pipe different sql files to the mysql command, which will run them against the local port, which is being forwarded to the remote port
cd "${DIR%%/}"; 
if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 

echo 'MySQL connecting to destination database over SSH tunnel';

command="cat ${SOURCE_BACKUP_FILE} ${SQL_SETTINGS_FILE} ${SQL_CONVERSION_FILE} ${DIR%%/}/fix-domain.sql | mysql --defaults-file=${DEST_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1 --database=${DEST_DB_NAME};rm -r ${SOURCE_BACKUP_FILE}";
else
echo 'MySQL connecting to destination database over local connection';
command="cat ${SOURCE_BACKUP_FILE} ${SQL_SETTINGS_FILE} ${SQL_CONVERSION_FILE} ${DIR%%/}/fix-domain.sql | mysql --defaults-file=${DEST_DEFAULTS_FILE} --database=${DEST_DB_NAME};rm -r ${SOURCE_BACKUP_FILE}";

fi

#echo "command  = $command";
eval $command;


echo "${DEST_DB_NAME} database has been updated";