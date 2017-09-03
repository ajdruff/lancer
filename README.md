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

For Windows users, cygwin is not supported. Instead, install the excellent Git for Windows, and run lancer from within the Git Bash. 




## SSH Keys

Lancer makes extensive use of SSH for access to remote servers.

To generate your Public/Private key pair:

    ssh-keygen
    
and follow the prompts. When you are finished, you will have 2 files, .id_rsa, the private key and id_rsa.pub, the public key.     

>To avoid overwriting any existing private key, create a project directory at ~/.ssh/project-name and create the keys there.


**Windows Users**

PuttyGen can be used to generate keys but it is not recommended since by default the public key it saves is in a format that will not work 

In Putty Key Generator (puttygen.exe):
 
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

>IdentifyFile = private key file. tells ssh where to find the private key. if it has a passphrase, you'll be prompted for it each time you login unless you are running ssh-agent
>**for more information, see [OpenSSH/Client Configuration Files](https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files)


For the given ssh config file, all the following logins are valid:

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
