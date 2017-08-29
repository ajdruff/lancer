#!/usr/bin/bash

#################
# push-options-dev-to-stage.inc.sh
#
#
# Pushes Select wp_options to Staging Database
#
# Never use standalone - always include from another bash file.
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
ssh -f -o ExitOnForwardFailure=yes -L "${LOCAL_SSH_FORWARDING_PORT}":localhost:3306 "${SSH_CONNECTION}" sleep 10;

fi


######################
#
# Export Options From Source Database
#
######################

echo "Exporting Options from Database ${SOURCE_DB_NAME}" ;


#make sure there is a temp directory to dump to
#mkdir -p "${DIR_PARENT%%/}/temp";

#change to the current directory
#this is required since --defaults-file cant take an absolute path without interpreting the path wrong.



if [ -f "${MYSQL_DATADIR%%/}wp_options.csv" ]; then
# echo 'skipping file removal';
# rm -r "${MYSQL_DATADIR%%/}wp_options.csv";
mv "${MYSQL_DATADIR%%/}wp_options.csv" "${MYSQL_DATADIR%%/}wp_options_old.csv";
fi


cd "${DIR%%/}"; 


if [[ "${SOURCE_DATABASE_IS_REMOTE}" == true ]]; then 
echo 'MySQL connecting to source database over SSH tunnel';
    #backup live database
    command=" cat ${EXPORT_OPTIONS_QUERY_FILE} | mysql --defaults-file=${SOURCE_MYSQL_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1 ";
  
  
else
echo 'MySQL connecting to source database over local connection';
command="cat ${EXPORT_OPTIONS_QUERY_FILE} | mysql --defaults-file=${SOURCE_MYSQL_DEFAULTS_FILE} ${SOURCE_DB_NAME}";


fi

# echo "command  = $command";

eval $command;


########################
#
# Update Stage
#
########################
echo "Updating ${DEST_DB_NAME} Database";

#pipe different sql files to the mysql command, which will run them against the local port, which is being forwarded to the remote port
cd "${DIR%%/}"; 
if [[ "${DEST_DATABASE_IS_REMOTE}" == true ]]; then 

echo 'MySQL connecting to destination database over SSH tunnel';

command="(echo 'use ${DEST_DB_NAME};'; cat ${IMPORT_OPTIONS_QUERY_FILE} ${SQL_SETTINGS_FILE} ${SQL_CONVERSION_FILE} ${DIR%%/}/fix-domain.sql )| mysql --defaults-file=${DEST_DEFAULTS_FILE} -P ${LOCAL_SSH_FORWARDING_PORT}  -h 127.0.0.1";

else
echo 'MySQL connecting to destination database over local connection';

command="(echo 'use ${DEST_DB_NAME};'; cat ${IMPORT_OPTIONS_QUERY_FILE} ${SQL_SETTINGS_FILE} ${SQL_CONVERSION_FILE} ${DIR%%/}/fix-domain.sql )| mysql --defaults-file=${DEST_DEFAULTS_FILE}";


fi

#echo "command  = $command";

eval $command;

if [ -f "${MYSQL_DATADIR%%/}wp_options.csv" ]; then

mv "${MYSQL_DATADIR%%/}wp_options.csv" "${MYSQL_DATADIR%%/}wp_options_old.csv";

fi

echo "${DEST_DB_NAME} database has been updated";