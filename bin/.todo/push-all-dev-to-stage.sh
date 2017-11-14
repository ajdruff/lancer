#!/usr/bin/bash

#################
# push-all-dev-to-stage.sh
#
#
#
#
# @author <andrew@nomstock.com>
#
#################
 




#get the directory this file is in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#get its parent directory pat
DIR_PARENT=$(dirname $DIR)


#database
command "${DIR%%/}/push-database-dev-to-stage.sh";
#files
command "${DIR%%/}/push-files-dev-to-stage.sh";
#configuration file overwrite (must come after push-files)
command "${DIR%%/}/push-config-stage.sh";

#configuration file overwrite (must come after push-files)
command "${DIR%%/}/set-permissions-stage.sh";