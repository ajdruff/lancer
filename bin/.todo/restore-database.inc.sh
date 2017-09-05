#!/usr/bin/bash

#################
# push-database.inc.sh
#
#
# Replaces Destination Database with Source Database Data
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

if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 
## setup tunnel
echo 'Creating SSH Tunnel to secure remote MySQL connection';
ssh -f -o ExitOnForwardFailure=yes -L "${LOCAL_SSH_FORWARDING_PORT}":localhost:3306 "${SSH_CONN}" sleep 10;

fi


########################
#
# Update Destination Database
#
########################
echo "Restoring ${DEST_DB_NAME} Database";

#pipe different sql files to the mysql command, which will run them against the local port, which is being forwarded to the remote port
cd "${DIR%%/}"; 
if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 

echo 'MySQL connecting to destination database over SSH tunnel';

command="cat ${SOURCE_BACKUP_FILE} | mysql --defaults-file=${DEST_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1 --database=${DEST_DB_NAME};";
else
echo 'MySQL connecting to destination database over local connection';
command="cat ${SOURCE_BACKUP_FILE}| mysql --defaults-file=${DEST_DEFAULTS_FILE} -h ${DEST_DB_HOST} --database=${DEST_DB_NAME};";

fi

#echo "command  = $command";
eval $command;


echo "${DEST_DB_NAME} database has been restored";