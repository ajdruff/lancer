#!/usr/bin/bash

#################
# scrub-wp-database.inc.sh
#
#
# Removes WordPress Installation Cruft
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

if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]] ; then 
## setup tunnel
echo 'Creating SSH Tunnel to secure remote MySQL connection';
ssh -f -o ExitOnForwardFailure=yes -L "${LOCAL_SSH_FORWARDING_PORT}":localhost:3306 "${SSH_CONNECTION}" sleep 10;

fi



########################
#
# Convert Destination Database
#
########################
echo "Removing posts, plugins,etc from ${DEST_DB_NAME} Database";

#pipe different sql files to the mysql command, which will run them against the local port, which is being forwarded to the remote port
cd "${DIR%%/}"; 
if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 

echo 'MySQL connecting to destination database over SSH tunnel';

command="cat  ${DIR%%/}/scrub-wp-database.sql | mysql --defaults-file=${DEST_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1 --database=${DEST_DB_NAME};";
else
echo 'MySQL connecting to destination database over local connection';
command="cat  ${DIR%%/}/scrub-wp-database.sql |  mysql --defaults-file=${DEST_DEFAULTS_FILE} --database=${DEST_DB_NAME};";

fi

echo "command  = $command";
eval $command;


echo "${DEST_DB_NAME} database has been updated";