#!/bin/bash

# START Bootstrap script for Database Dev Box provisioning

# core packages
sudo apt-get install -y ksh   # for DB2 client install
sudo apt-get install -y libaio1 libaio-dev
sudo apt-get install -y rpm   # for IBM GSKIT
sudo apt-get install -y alien # for IBM GSKIT

# Install DB2 Client
#  client download from http://www-01.ibm.com/support/docview.wss?uid=swg21385217
sudo mkdir /opt/ibm
sudo chown -R vagrant:vagrant /opt/ibm

# copy client install source to /opt/ibm then extract
cd /opt/ibm
cp /vagrant/ibm_data_server_runtime_client_linuxx64_v11.1.tar.gz /opt/ibm
gunzip ibm_data_server_runtime_client_linuxx64_v11.1.tar.gz
tar -xvf ibm_data_server_runtime_client_linuxx64_v11.1.tar

# remove source tar ball
rm ibm_data_server_runtime_client_linuxx64_v11.1.tar

# dodgy hack to work around issues reported by db2prereqcheck
sudo ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so

# run pre-reqs script
cd rtcl
./db2prereqcheck

# run install script
./db2_install

# install GSKit (for DB2 SSL Connections)
# see README


# Modify bashrc to source db2profile (not needed for none root install)
#cat <<EOT >> ~/.bashrc
## source db2 profile
#if [ -f /opt/ibm/dsdriver/db2profile ]; then
    #source /opt/ibm/dsdriver/db2profile
#fi

## force db2 client to open in termnial mode
#alias clpplus="clpplus -nw"

#EOT

# END Bootstrap script for Database Dev Box provisioning
