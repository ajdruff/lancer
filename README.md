# lancer


A WordPress Toolset that helps to manage local dev and live environments.


# Who needs it

If you develop on WordPress and/or do frequent WordPress setups, and migrations (from one domain or host to another).

# Why you need it

* Easily upload keys with one command
* Easily backup, publish without relying on plugins.
* packages all configuration on one place 

# Tutorials

* see [Lancer for WordPress Tutorials](#)


# Requirements

* bash
* git
* openssh
* rsync
* mysql client and mysql dump


            
# Installation


## Step 1 - Download



## Step 2 - Configure

Create `etc/lancer.conf` from `etc/lancer.conf-sample`  and edit it with values for your installation.

For detailed SSH setup, see the **SSH Connections** section later in this README.

For more information on configuration files, see the **Lancer Configuration Files** section.


            
## Step 3 - Upload Public Keys

### setup keys for each environment that you will be remotely conntecting to:

    ./setup-keys.sh live

###(optional) if your dev and stage servers are remote:


    ./setup-keys.sh dev
    ./setup-keys.sh stage

  



# Usage

## backup-files.sh


    bin/backup-files.sh <env> [<dry>]
        
  Backs up files in the DIR_PATH value configured for the specified environment in  `etc/lancer.conf`. By default, backups are located in the `backups` directory within the `lancer` project directory.

  * env = live/dev/stag
  * dry = will do a simulated backup
  
  File backups are done with rsync. A dry file backup will use the --dry-run flag for rsync.
  
  
## backup-db.sh 

    bin/backup-db.sh <env> [<db|all>]
    
  * env = live/dev/stag
  * db = name of the database to backup or `all` which will backup all databases.
  
  By default, if no db option is given , lancer will backup the database configured for the specified environment in your `etc/lancer.conf` file.
  
  
 Backs up the database to `backups` folder.

 
# Lancer Configuration Files


* *etc/lancer.conf* - This file contains user configurable values specific to your installation. Create from its sample file.

* *etc/.lancer-conf* - Hidden configuration file that contains default values for pre-defined variables common for all installations and **should never be edited**. If you need to change the value for any of these variables, add the same variable to `etc/lancer.conf` and change its value. See the *Debugging* section for an example using the `LANCER_DEBUG` pre-defined variable. 
    
* *etc/rsync-exclude-LIVE/DEV/STAGE.conf* - Create from their sample file. Used to exclude any rsync patterns (files or directories) you don't want to backup when running the `backup-files` script. See the **Include/Exclude Pattern Rules** section at the [rsync man page](https://linux.die.net/man/1/rsync) for more information.


**database connections**

Configuration for database connections should only be done using the `etc/lancer-conf` file.


Database connections are made using a MySQL option file that is created by the backup script based on your `etc/lancer-conf` values and copied to your local home directory or uploaded to your remote server over a secure SSH connection. 

The file created for this purpose is `etc/.lancer-my.conf` and should never be edited.  

During use,the permissions set on the file are 0600, securing access to all but the user of the script. After each connection, the file is deleted. 



Database connections are done this way to ensure passwords are never passed through clear text, left in history, or can be seen using the `ps` command, and because MySQL tunnelling cannot always be used since  port forwarding is frequently disabled on some shared hosts.


            
            
 
# Git Repo & Sensitive Data
 
 If you clone or fork the **lancer** repository, please avoid committing any sensitive information such as passwords to the repo.
 
 
 To avoid commiting passwords to the repo, **lancer's** repository contains configuration files ending in '-sample'. Lancer's `.gitignore` file ignores those `.conf` files that do not include `-sample` as a suffix. 

 
 If you download this repo without cloning it and don't have the original `.gitignore` rules, add the following to your `.gitignore` file . Note that entries are cascaded, so it matters the order you place the entries.
 
 

       /etc/*.conf*
       !/etc/*.conf-sample
       !/etc/*.conf.tpl




 
# SSH Connections

**Lancer** makes extensive use of SSH for access to remote servers. To properly work with your configuration, keys must be saved in the format required by your remote server's `~/.ssh/authorized_keys` file.

**Lancer** leverages the `ssh_config` style configuration for SSH clients, and does not require you to add duplicate SSH port, username or other information to `lancer-config`. For more information see the *SSH Configuration* section below.


## SSH Keys
To generate your Public/Private key pair:

    ssh-keygen
    
and follow the prompts. When you are finished, you will have 2 files, .id_rsa, the private key and id_rsa.pub, the public key.     

>To avoid overwriting any existing private key, create a project directory at ~/.ssh/project-name and create the keys there.


**SSH Keys for Windows Users**

[PuttyGen](https://www.ssh.com/ssh/putty/windows/puttygen) can be used to generate keys but it is not recommended since by default the public key it saves (even if converted to openssh) is not compatible with **lancer**. 

**To create a compatible public key using PuTTYGen:** 

 
1. Click `Generate`
2. Click `Save private key` and save as `id_rsa.ppk`. This will save a file for use by PuTTY only. It contains both public and private keys.
3. Click `Conversions / Export OpenSSH key` and save as `id_rsa` with no file extension. This saves the private key in the standard OpenSSH format.
4. **Do NOT  use the `save public key' feature of PuTTYGen.** 
    Instead do this :

    * Copy the contents within the text box labeled `Public key for pasting into OpenSSH authorized_keys file`.
    * Create a file in notepad and name it `id_rsa.pub`. Paste the contents that you just copied into the file and save it. 

>PuTTYGen's `Save Public Key` button should not be used to save public keys. The reason is that it will save the key with dashed lines and without the `ssh-rsa` prefix that openssh  looks for.



## SSH Configuration

If your remote server's ssh connection is on an alternate port or requires custom switches, create or edit `~/.ssh/config` on your **client** machine : 



            Host ex example.com
                 User joe
                 HostName example.com
                 Port 2222
                 PreferredAuthentications publickey,password
                 IdentityFile /path/to/local/id_rsa
                 AddKeysToAgent yes



>*IdentifyFile* = Tells ssh where to find the private key. Tf your private key has a passphrase, you'll be prompted for it each time you login unless you are running ssh-agent

>*AddKeysToAgent* : Tells ssh to automatically add the private key to ssh-agent once you've successfully added your passphrase.    

>**for more information, see [OpenSSH/Client Configuration Files](https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files)**




For the above ssh config, you can login to example.com using any of the following commands:

            ssh joe@example.com
            ssh ex
            ssh -p 2222 joe@example.com

 
# Debugging


If you want to see additional debug output, add the following variable to your `etc/lancer.conf` file: 

    LANCER_DEBUG=true;
    

## Windows

Lancer *almost* works within a [Cygwin](https://www.cygwin.com/)/[MinGW](http://www.mingw.org/)/[MSYS](http://www.mingw.org/wiki/MSYS) environment. However. Because `rsync` reads any path with a colon inside of it as a remote server, it refuses to work correctly when using Windows absolute paths.

For this reason, it is strongly recommended that you a VirtualBox or other Virtual environment that runs your favorite Linux distribution.

If you really want to try running it on Windows anyway without a VM, take a look at the [Windows Setup Readme]()  (included in the lancer download).


# Contributors

Andrew Druffner `<andrew@nomstock.com>`
    
# Dev Notes


## History

lancer is a rewrite of [slide rule](https://github.com/ajdruff/slide-rule)

The intent of the rewrite is to:

* remove the need for git on the live server (will use rsync to publish) 
* more explicitly cater to WordPress (slide-rule was intended to be platform agnostic with some WordPress features)
* simplify it so setup and usage is suitable for mortals.
* increase code maintainability


## RoadMap

lancer is destined to be a nodejs app once its been refactored as a messy set of bash scripts.




## ChangeLog


**9-6-2017**

* rewrote backup scripts
* added backup-files.sh
* added backup-db.sh
* refactored configuration file inclusion so can override .lancer-conf
* added LANCER_DEBUG
* updated README
* cleaned up bin directory and moved all deprecated/todo scripts to hidden directories that are excluded from downloads.


**8/29/2017**

* refactored config files to use lancer.conf, .lancer-conf, and native bash ini parsing
* refactored directory structures to use .bin/bin/etc structure
* rewrote setup-keys.sh 
* added support for dev,stage environments for setup-keys
* refactored setup-keys to support multiple environments using SERVER_ENV argument. Use as template for all scripts.
* leverage use of ssh_config instead of local configuration of SSH connection.




