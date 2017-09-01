#################
# set-permissions-live.inc.sh
# 
#
# Run this script only as input to a remote ssh session
# see set-permissons-live.sh for example

# Sets Permissions on remote site
# @author <andrew@nomstock.com>
#################

##config
## you can't include the config-bash.conf file here since it won't be found on remote server. Instead include it before you call it



echo '#############################';



echo '##### Setting live Permissions ######';
echo '...'
##production
chmod 600  "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/wp-config.php"
chmod 600  "${LIVE_DIR_PATH%%/}/config/wp-config.php"
chmod 600  "${LIVE_DIR_PATH%%/}/config/wp-config-db.php"
chmod 644 "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/.htaccess"
chmod 644 "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/wp-admin/.htaccess"
chmod 644 "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/index.php"
find "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/" -type d -exec chmod 755 {} \;
find "${LIVE_DIR_PATH%%/}/${HTML_DIRNAME}/" -type f -exec chmod 644 {} \;

echo '##### Finished Setting live Permissions ######';
