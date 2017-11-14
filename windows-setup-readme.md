# How to Setup a Linux Environment in Windows


#Method 1

The preferred method of running lancer is to run it on a VirtualBox virtual machine.

1) share your project folders with virtualbox
2) startup your virtualbox virtual machine
2) ssh into is using Git for Windows Git Bash console (or a terminal emulator like ConEMU)
3) cd to your lancer/bin directory to start lancer. See the main readme for details on using lancer.


#Method 2


>**disclaimer** This method has issues in backing up local to local (dev environment) since rsync is used for backup and rsync doesn't do well with colons in path names ( it assumes they are all remote). 


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

**Step 3 - Install the mysql client and mysqldump**

Check to see if you can run mysql and mysqldump from the command line. If you are running MySQL server on your local machine for your dev environment, you likely already have them. However, if you are accessing a virtual machine and using a console on your windows host, you might not.

To get them both, install [MySQL WorkBench](https://dev.mysql.com/downloads/workbench/) .

Once installed, add the following lines to your `~/.bashrc` to update your path:

            PATH="/c/Program Files/MySQL/MySQL Workbench 6.3 CE":$PATH


**Step 4 - Restart your shell or source your ~/.bashrc**

Before the PATH changes can take effect, you'll need to re-run your `~/.bashrc ` script. You can do that either by starting a new bash shell, or re-sourcing:

            source ~/.bashrc


