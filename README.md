#Vagrant Boxes

A series of portable VM instances that can be fired up on the host (Windows) machine that I am invariably required to use.

##Requires

All boxes require the following on the host machine:

- Oracle Virtual Box
- Vagrant
- Git (or copy files direct)

##Usage:

Clone this repo

```git clone https://github.com/jonbartlett/portable-dev-box```

If behind a corporate firewall that requires the use of a proxy and using Windows, set the following environment variables:

```
HTTP_PROXY=http://proxy.company.com.au:8080
HTTPS_PROXY=https://proxy.company.com.au:8080
VAGRANT_HTTP_PROXY=http://proxy.company.com.au:8080
VAGRANT_HTTPS_PROXY=https://proxy.company.com.au:8080
VAGRANT_NO_PROXY=localhost,127.0.0.1,.company.com.au
```

*all steps that follow should take place within the same directory as the ```Vagrant``` file for the machine you want to use.*

Add proxy support in Vagrant:

```vagrant plugin install vagrant-proxyconf```

Import Ubuntu box

```vagrant box add ubuntu/trusty64```

Bring up and provision instance

```vagrant up```

Connect into VM. Only works if using a command interpreter with a built in SSH client (Git Bash, etc.). Alternatively SSH using favourite client (creds vagrant/vagrant)

```vagrant ssh```

or

```ssh -p 2222 vagrant@127.0.0.1```


##The Boxes
- generic-dev: *base install with all my goodies installed*
- database-dev: base install + DB2 Client + Oracle Client

##Generic-Dev

Base box with all my config installed. Will be used as a base to build other technology specific machines.

###Installed:
- git
- svn
- vim
- tmux
- wget
- curl
- java
- ruby + rbenv

for up-to-date list of packages installed see ```bootstrap.sh```.

*config sourced via https://github.com/jonbartlett/dotfiles*

##Database-Dev

Includes everything in the Generic-Dev box with the addition of database developement tools. Specifically:

* DB2 Database Drivers for Linux
* Oracle Instant Client including SQL*PLus - coming.....

See README for more information
