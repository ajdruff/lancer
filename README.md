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


# Prepare

## Requirements
* bash
* git
* openssh
* rsync
* mysql client and mysql dump


## Windows

Windows users should  install Git for Windows and add rsync using mingw-get. Cygwin is not directly supported, although Git for Windows uses some cygwin translation layers.

Once installed,  you can execute **lancer** from the Git for Windows Git bash console.


**Step 1 - Install [Git For Windows](https://git-for-windows.github.io/)**

**Step 2 - Install rsync** :

* Install [mingw-get](https://downloads.sourceforge.net/project/mingw/Installer/mingw-get-setup.exe?r=&ts=1504488387)

* Once mingw-get is installed, install the msys-rsync package:

            /c/mingw/bin/mingw-get install msys-rsync

* Finally, update your path by editing  `~/.bashrc` and adding the following lines :

            PATH=$PATH:/c/mingw/msys/1.0/bin
            PATH=$PATH:/c/mingw/bin

** Step 3 - Install the mysql client and mysqldump **

Check to see if you can run mysql and mysqldump from the command line. If you are running MySQL server on your local machine for your dev environment, you likely already have them. However, if you are accessing a virtual machine and using a console on your windows host, you might not.

To get them both, install [MySQL WorkBench](https://dev.mysql.com/downloads/workbench/) .

Once installed, add the following lines to your `~/.bashrc` to update your path:

            PATH="/c/Program Files/MySQL/MySQL Workbench 6.3 CE":$PATH


** Step 4 - Restart your shell or source your ~/.bashrc **

Before the PATH changes can take effect, you'll need to re-run your `~/.bashrc ` script. You can do that either by starting a new bash shell, or re-sourcing:

            source ~/.bashrc


## SSH Keys

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

## Step X - Upload Public Keys

### setup keys for each environment that you will be remotely conntecting to:

    ./setup-keys.sh live

###(optional) if your dev and stage servers are remote:


    ./setup-keys.sh dev
    ./setup-keys.sh stage

###Step X -     



# Usage




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
