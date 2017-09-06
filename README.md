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


# SSH Keys

**Lancer** makes extensive use of SSH for access to remote servers.

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







# Installation

##Step 1 - Configure

1. create lancer.conf from lancer.conf-sample 
2. edit lancer.conf with values for your installation
3. For each remote server, if ssh connection is on an alternate port or requires custom switches, create or edit `.ssh/config` : 



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

            
**configuration files**

There are 2 main configuration files.

* *etc/lancer.conf* - This file contains user configurable values specific to your installation.

* *etc/.lancer-conf* - Hidden configuration file that contains default values for pre-defined variables common for all installations and **should never be edited**. If you need to change the value for any of these variables, add the same variable to `etc/lancer.conf` and change its value. See the *Debugging* section for an example using the `LANCER_DEBUG` pre-defined variable. 
    

**database connections**

Configuration for database connections should only be done using the `etc/lancer-conf` file.


Database connections are made using a MySQL option file that is created by the backup script based on your `etc/lancer-conf` values and copied to your local home directory or uploaded to your remote server over a secure SSH connection. 

The file created for this purpose is `etc/.lancer-my.conf` and should never be edited.  

During use,the permissions set on the file are 0600, securing access to all but the user of the script. After each connection, the file is deleted. 



Database connections are done this way to ensure passwords are never passed through clear text, left in history, or can be seen using the `ps` command, and because MySQL tunnelling cannot always be used since  port forwarding is frequently disabled on some shared hosts.


            
            
            
## Step X - Upload Public Keys

### setup keys for each environment that you will be remotely conntecting to:

    ./setup-keys.sh live

###(optional) if your dev and stage servers are remote:


    ./setup-keys.sh dev
    ./setup-keys.sh stage

### Step X -     



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

 
# Git Repo & Sensitive Data
 
 If you clone or fork the repository, please avoid committing any sensitive information such as passwords to the repo.
 
 To avoid commiting passwords to the repo, lancer uses '-sample' files for most sensitive files and lancer's `.gitignore` file ignores those `.conf` files that do not include `-sample` as a suffix. 

 
 
 
## Debugging


If you want to see additional debug output, add the following variable to your `etc/lancer.conf` file: 

    LANCER_DEBUG=true;
    



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

**8/29/2017**

* refactored config files to use lancer.conf, .lancer-conf, and native bash ini parsing
* refactored directory structures to use .bin/bin/etc structure
* rewrote setup-keys.sh 
* added support for dev,stage environments for setup-keys
* refactored setup-keys to support multiple environments using SERVER_ENV argument. Use as template for all scripts.
* leverage use of ssh_config instead of local configuration of SSH connection.
