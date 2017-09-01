# lancer


A WordPress Toolset that helps to manage local dev and live environments.


#Who needs it

If you develop on WordPress and/or do frequent WordPress setups, and migrations (from one domain or host to another).

#Why you need it

* Easily upload keys with one command
* Easily backup, publish without relying on plugins.
* packages all configuration on one place 

#Tutorials

* see [Lancer for WordPress Tutorials](#)


#Requirements

* bash
* git 

For Windows users, cygwin is not supported. Instead, install the excellent Git for Windows, and run it from within the Git Bash. 

For more on how you can setup a nice Windows environment, see [Setup an Awesome MingGW Linux Development Environment in Windows](#)


#Configure

Configuration files consist of:

* `lancer.conf`  
    * contains general configuration options.
    * you must first create it on installation from lancer.conf-sample
* `.lancer-conf`
    * contains advanced configuration options
* `~/.ssh/config` (optional)
    * if your ssh connection requires a different port or other command line switches, configure it using a ssh_config file located within your local .ssh directory. see open_ssh documentation for more details or README for basic usage.

#Usage


##Step 1 - Configure

1. create lancer.conf from lancer.conf-sample 
2. edit lancer.conf for your installation
3. For each remote server, if ssh connection is on a alternate port or requires custom switches, create or edit `.ssh/config` .
4. If you use a passphrase on your keys, you'll need to run `ssh-agent` or [pageant](https://www.ssh.com/ssh/putty/putty-manuals/0.68/Chapter9.html)


sample file:


    Host example.com
        HostName example.com
        Port 2222
        PreferredAuthentications publickey,password
        IdentityFile /path/to/local/id_rsa

>IdentifyFile = private key file. if you have this, you don't need ssh-agent or pageant, if you don't use a passphra
>**for more information, see [OpenSSH/Client Configuration Files](https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files)

            
            
##Step X - Upload Public Keys

###setup keys for each environment that you will be remotely conntecting to:

    ./setup-keys.sh live

###option if your dev and stage servers are remote:


    ./setup-keys.sh dev
    ./setup-keys.sh stage

###Step X -     


#Contributors

Andrew Druffner `<andrew@nomstock.com>`
    
#Dev Notes


##History

lancer is a rewrite of [slide rule](https://github.com/ajdruff/slide-rule)

The intent of the rewrite is to:

* remove the need for git on the live server (will use rsync to publish) 
* more explicitly cater to WordPress (slide-rule was intended to be platform agnostic with some WordPress features)
* simplify it so setup and usage is suitable for mortals.
* increase code maintainability


##RoadMap

lancer is destined to be a nodejs app once its been refactored as a messy set of bash scripts.

##todo

* create branch lancerjs
* create console wizard that will prompt user for configuration. do this as a lancerjs app first, don't bother writing it in bash.
* change all sql scripts to bash scripts using this as a guide: https://stackoverflow.com/a/25109187/3306354 . take into  consideration moving sql variables to lancer.conf, so should be no need for lancer.sql.conf


##ChangeLog

**8/29/2017**

* refactored config files to use lancer.conf, .lancer-conf, and native bash ini parsing
* refactored directory structures to use .bin/bin/etc structure
* rewrote setup-keys.sh 
* added support for dev,stage environments for setup-keys
* refactored setup-keys to support multiple environments using SERVER_ENV argument. Use as template for all scripts.
* leverage use of ssh_config instead of local configuration of SSH connection.
