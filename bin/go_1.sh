  #!/usr/bin/env bash

#################
# 
#
#
# Backs up database
#
#  Usage:
# ./backup-db.sh live/dev/stage [dry]
#
#
# @author <andrew@nomstock.com>
# @todo :Examine scripts and split out getEnvVars to be specific for each script since there are target and sources.
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#get the configuration variables   
source "${DIR%%/}/.bin/lancer.conf.sh";

#include common functions
source "${DIR%%/}/.bin/functions.sh";

#include backup files functions
source "${DIR%%/}/.bin/functions.go.sh";

#check that server environment was passed
setTargetServerEnv $1

#Now that we know environment, get appropriate values

setTargetServerVars $TARGET_SERVER_ENV

setSourceServerVars  "DEV"





goLive  "${1}" "${2}"

exit;

#rename suffix to target  
#uploadDB

#show remote prompt
#check if on live branch
#backup live site (files and database)
#check again if on live branch
#rsyncs to the live site
#uploads dev database (add later)
#shows 'go live message'
#need to show message indicating that database still needs to be updated.

#safety: 
#you publish to db2 and switch over by changing the config in WordPress
#you publish to wp-content-pending and rename wp-content to wp-content-{date-time}, then wp-content-pending to wp-content
#this can be automated.... . if everything works, you can then drop the live database and do a reimport to the new db.



#create .my.cnf files to 
#createMyCnf


#uploadDB



