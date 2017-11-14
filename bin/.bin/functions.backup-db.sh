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
# @todo db1.2:bug: latest directory retains old sql downloads. need to delete contents before backup or will wind up accumulating old backups in zip
# @todo db1.3:bug: names of backup zips do not include name of database
# @todo db1.4:bug: the files zip and backup zips are indistinguishable - add 'files' and 'db' to the zip naming scheme



#################



################################
function setSourceDBVars() {
############################


#SOURCE_SSH_DB_ACCESS
var="$SERVER_ENV"_SSH_DB_ACCESS
SOURCE_SSH_DB_ACCESS=$(echo "${!var}" | xargs ); 

#SOURCE_MYSQL_DEFAULTS_FILE
var="$SERVER_ENV"_MYSQL_DEFAULTS_FILE
SOURCE_MYSQL_DEFAULTS_FILE="${!var}"


#SOURCE_DB_USER
var="$SERVER_ENV"_DB_USER
SOURCE_DB_USER="${!var}"

#SOURCE_DB_PASSWORD
var="$SERVER_ENV"_DB_PASSWORD
SOURCE_DB_PASSWORD="${!var}"


#SOURCE_DB_NAME
var="$SERVER_ENV"_DB_NAME
SOURCE_DB_NAME="${!var}"

#SOURCE_DB_PORT
var="$SERVER_ENV"_DB_PORT
SOURCE_DB_PORT="${!var}"


#SOURCE_DB_HOST
var="$SERVER_ENV"_DB_HOST
SOURCE_DB_HOST="${!var}"




}

########################################
function makeDestinationDirectory() {
########################################
#add some subdirectories to local backup path to help organize into server env and files/sql

mkdir -p "${LOCAL_BACKUP_DIR}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${DB_BACKUP_DIRNAME}";
mkdir -p "${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${DB_BACKUP_DIRNAME}/${MIRROR_BACKUP_DIRNAME}";


LOCAL_BACKUP_DIR_EXTENDED="${LOCAL_BACKUP_DIR}/${SERVER_ENV}/${DB_BACKUP_DIRNAME}";
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


function doDBQueryRemote(){

upload_mycnf_command="


scp ${LANCER_DIR}/etc/${MYSQL_DEFAULTS_FILE} ${SSH_CONN}:~/${MYSQL_DEFAULTS_FILE}


";



#upload the mycnf file.
eval "${upload_mycnf_command}";

remote_commands="
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;




mysqldump --defaults-file~/${MYSQL_DEFAULTS_FILE} ${SOURCE_DB_NAME};
rm ~/${SOURCE_MYSQL_DEFAULTS_FILE};

"

remote_commands="
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

mysql --defaults-file=~/${MYSQL_DEFAULTS_FILE} -h 127.0.0.1 ab4210_wrdp -e \"show databases;\";
rm ~/${MYSQL_DEFAULTS_FILE};
"





exit;

show_remote_exec_message "Press [Enter] to start backing up the ${SERVER_ENV} MySQL server";

exec_remote $remote_commands;
}


#allows you to pass all or the name of a db to backup
###########################
function setMysqlDumpArgs()
##########################
{

if [ -z "${2}" ];then
MYSQLDUMP_DB=${SOURCE_DB_NAME}
return
fi

if [[ "${2}" == 'all' ]]; then

MYSQLDUMP_DB="--all-databases";
SOURCE_DB_NAME="all";
else
MYSQLDUMP_DB=${2}
SOURCE_DB_NAME=${2};
fi



}


#function doDBQueryLocal(){

#}

####################################
function backupDBServerLocal () 
####################################
{



#copy the my.cnf file to home directory. 
#we do this because virtualbox shared permissions can't be changed and we assume
#that lancer project folder is being shared.
cp "${LANCER_DIR}"/etc/"${MYSQL_DEFAULTS_FILE}" "${HOME}"/"${MYSQL_DEFAULTS_FILE}"

#change permissions for security
chmod 0600 "${HOME}"/"${MYSQL_DEFAULTS_FILE}" > /dev/null;



mysqldump_arguments=""\
" -v"\
" -h \"${SOURCE_DB_HOST}\""\
" -P \"${SOURCE_DB_PORT}\""\
" \"${MYSQLDUMP_DB}\" 1>\"${LOCAL_BACKUP_DIR_EXTENDED}\"/\"${MIRROR_BACKUP_DIRNAME}\"/\"${DOMAIN}-${SERVER_ENV}-${SOURCE_DB_NAME}.sql\""\
"";
#defaults-file must be first arg passed or it will tie error of unrecognized option/variable
#-v #gives updates on which rows and tables are being saved





backup_command="mysqldump --defaults-file=\"$HOME/${MYSQL_DEFAULTS_FILE}\" ${mysqldump_arguments}";



#echo "${backup_command}";

eval "${backup_command}";

}


####################################
function backupDBServerRemote () 
####################################
{



show_remote_exec_message "Press [Enter] to start backing up the ${SERVER_ENV} MySQL server";






mysqldump_arguments=""\
" -v"\
" -h \"${SOURCE_DB_HOST}\""\
" -P \"${SOURCE_DB_PORT}\""\
" \"${MYSQLDUMP_DB}\""\
"";
#defaults-file must be first arg passed or it will tie error of unrecognized option/variable
#-v #gives updates on which rows and tables are being saved





#mysqldump --defaults-file="~/.lancer-my.conf"  -v -h "127.0.0.1" -P "3306" "ab4210_wrdp";
mysqldump_command="mysqldump --defaults-file=\"~/${MYSQL_DEFAULTS_FILE}\" ${mysqldump_arguments}";

#backup command
backup_command="
chmod 0600 ~/${MYSQL_DEFAULTS_FILE} > /dev/null;
${mysqldump_command};

rm ~/${MYSQL_DEFAULTS_FILE} > /dev/null;

"
     
echo "Connecting to ${SSH_CONN}..."

#upload the mycnf file, output only error
scp "${LANCER_DIR}"/etc/"${MYSQL_DEFAULTS_FILE}" "${SSH_CONN}":'$HOME'/"${MYSQL_DEFAULTS_FILE}" 1>/dev/null

echo 'retrieving database records..';

#do the backup
#  1>"/home/adruff/www/clients/wwmattress/lancer/backups/LIVE/database"/"latest"/"worldwidemattressoutlet.com"-"LIVE"-"ab4210_wrdp".sql;
ssh "${SSH_CONN}" "${backup_command}" 1>"${LOCAL_BACKUP_DIR_EXTENDED}"/"${MIRROR_BACKUP_DIRNAME}"/"${DOMAIN}"-"${SERVER_ENV}"-"${SOURCE_DB_NAME}".sql;

#for debug messaging:
backup_command="${backup_command} ""1>\"${LOCAL_BACKUP_DIR_EXTENDED}\"/\"${MIRROR_BACKUP_DIRNAME}\"/\"${DOMAIN}\"-\"${SERVER_ENV}\"-\"${SOURCE_DB_NAME}\".sql;"



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


#####################################################
function compressDB () 
##################################################
{
compress_option="none";
if [ "${DB_BACKUP_COMPRESSION}" = "zip" ]; then

compress_command="cd ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME} /dev/null; zip -r ../${DOMAIN}-${SERVER_ENV}-${ARCHIVE_FILE_ENDING}.zip ./ > /dev/null ;cd -;> /dev/null"  





fi

if [ "${DB_BACKUP_COMPRESSION}" = "tar" ]; then
#tar is failsafe. in case someone uses an invalid compression type

compress_command="tar -zcvf ${LOCAL_BACKUP_DIR_EXTENDED}/${DOMAIN}-${SERVER_ENV}-${ARCHIVE_FILE_ENDING}.tar.gz -C  ${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME} ./ > /dev/null" 



fi


eval "${compress_command}";

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
function showBackupCompleteMessage() {
##################################################





message="
\n##################################
\n########### Backup Complete #####

\nFind Backup at :

\n"${LOCAL_BACKUP_DIR_EXTENDED}/${MIRROR_BACKUP_DIRNAME}/"

\n####################################
";

echo -e ${message};




}

