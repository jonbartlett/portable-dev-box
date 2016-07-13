# Vagrant Db Development Box

A Ubuntu VM with database development in mind.

For now this includes the following clients for connecting to remote databases:

* DB2 Client (CLP and CLPPLUS)
* Oracle client (SQLPlus) 

## DB2 Client

CLI for DB2.

### Installation

* Download IBM Data Server Runtime Client from [here](http://www-01.ibm.com/support/docview.wss?uid=swg21385217). You may or may not have to sign up for an IBM account to be able to download. Select the Linux 32bit version "IBM Data Server Runtime Client (Windows 32-bit AMD and Intel x86)". 
* Place downloaded file ```ibm_data_server_runtime_client_linuxia32_v10.5.tar.gz``` in your Vagrant directory.
* [Provision](../README.markdown) Vagrant instance.

Provisioning steps are detailed in ```bootstrap-db.sh```. You may want to run these manually.

Currently the install is performed non-root as user vagrant. This results in the DB2 client being installed into ```~/sqllib```. Whilst this works, further investigation is to be performed to install as root in ```/opt/ibm``` as originally intended.

*NB: at the time of writing the current version of the IBM Data Server Driver Package was 10.5*

### Usage

Once installed, create a new session to call ```db2profile``` which was added to ```~/.bashrc``` by the DB2 Client installer. 

#### DB2 CLI

The traditional 'CLP' is available via the command ```db2```:

```
db2 catalog tcpip node <nodename> remote <db hostname> server <port>
db2 catalog database <database_name> at node <nodename>
db2 terminate
db2 connect to <database_name> user <user_name>
db2 select current timestamp from SYSIBM.SYSDUMMY1
```

#### DB2 CLPPLUS

The newer client CLPPlus is available via the command ```clpplus```:

```
clpplus -nw <username>@<db hostname>:<db port>/<db name>
```

## DB2 SSL

If the DB2 server you are connecting to requires a SSL connection, you will need to install IBM GSKit to enable this.

### Installation

* Download GSKit V8 from [here](http://www.ibm.com/support/fixcentral/swg/selectFixes?product=ibm/Tivoli/IBM+Global+Security+Kit&function=fixId&fixids=8.0.14.*-GSKIT-Linux32*). You may need a valid IBM support account to do this.
* Place downloaded file in the Vagrant directory so that is it accessible via the VM instance.
```
gunzip *.gz
tar -xvf *.tar
```
* Move the extracted directory and files onto the ext4 filesystem, and change permissions to 0755 (as dpkg-deb will complain about bad permissions and refuse to create the deb packages).
* Convert the IBM rpms to deb for use with Ubuntu (ensure ```rpm``` and ```alien``` are installed):
```
for rpm in gsk*.rpm ; do sudo alien -c -d $rpm ; done
```
* Install converted packages:
```
sudo dpkg -i gskcrypt32_8.0-15.43_i386.deb
sudo dpkg -i gskssl32_8.0-15.43_i386.deb
```
* Check ```/usr/local/ibm/gsk8``` created to verify installation.
* Create location for key files ```mkdir ~/.db2keystore``` and copy the server key (.kdb) and stash (.sth) files here.
* Update DB2 config:
```
db2 update dbm cfg using SSL_CLNT_KEYDB ~/.db2keystore/<keyfile>.kdb
db2 update dbm cfg using SSL_CLNT_STASH ~/.db2keystore/<stashfile>.sth
```
* Verify config update:
```db2 get dbm cfg```
* (Re)catalog databases with SSL:
```
db2 catalog tcpip node <nodename> remote <db hostname> server <port> security ssl
db2 catalog database <database_name> at node <nodename>
db2 terminate
db2 connect to <database_name> user <user_name>
db2 select current timestamp from SYSIBM.SYSDUMMY1
```

More reading:

* http://www.ibm.com/developerworks/data/library/techarticle/dm-1306securesocketlayers/
* http://www-01.ibm.com/support/docview.wss?uid=swg21631460
* https://www.ibm.com/developerworks/library/se-gskit/

## Oracle Client

Coming....
