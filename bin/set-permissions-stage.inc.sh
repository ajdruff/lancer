#################
# set-permissions-staging.inc.sh
# 
#
# Run this script only as input to a remote ssh session
#
# Sets Permissions on remote site
# Usage:
# "cat ${DIR%%/}/config-bash.conf ${DIR%%/}/set-permissions-staging.inc.sh |ssh ${SSH_CONNECTION} bash -s"
# @author <andrew@nomstock.com>
#################

##config
## you can't include the config-bash.conf file here since it won't be found on remote server. Instead include it before you call it



echo '##### Setting Stage Permissions ######';
echo '...'
##staging
chmod 600  "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/wp-config.php"
chmod 600  "${STAGE_DIR_PATH%%/}/config/wp-config.php"
chmod 600  "${STAGE_DIR_PATH%%/}/config/wp-config-db.php"
chmod 644 "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/.htaccess"
chmod 644 "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/wp-admin/.htaccess"
chmod 644 "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/index.php"
find "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/" -type d -exec chmod 755 {} \;
find "${STAGE_DIR_PATH%%/}/${HTML_DIRNAME}/" -type f -exec chmod 644 {} \;

echo '##### Finished Setting Stage Permissions ######';