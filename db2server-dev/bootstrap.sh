#!/bin/bash

## DB2 Server provisioning
##  based on https://github.com/angoca/db2unit/blob/master/.travis.yml

DB2_SOURCE_LOCATION="$1"

## core packages
#sudo apt-get update
sudo apt-get install -y ksh
sudo apt-get install -y libaio1 libaio-dev

# if DB2 source location passed in then use this
if [ -r "$DB2_SOURCE_LOCATION" ]
then

  # move source to /tmp
  cp "$DB2_SOURCE_LOCATION" /tmp

else

  echo "could not find DB2 source file"
  exit 1

fi

# un-compress
cd /tmp ; tar zxvf ./*.tar.gz


# INSTALL

# dodgy hack to work around issues reported by db2prereqcheck
sudo ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0

# Checks the prerequisites
cd /tmp/server_t ; ./db2prereqcheck -l

# Install DB2 and creates an instance (Response file)
cp /vagrant/db2/db2.rsp /tmp
cd /tmp/server_t ; sudo ./db2setup -r /tmp/db2.rsp || cat /tmp/db2setup.log

# Changes the security
sudo usermod -a -G db2iadm1 "$USER"
sudo chsh -s /bin/bash db2inst1
sudo su - db2inst1 -c "db2 update dbm cfg using SYSADM_GROUP db2iadm1 ; db2stop ; db2start"

# Creates the database
sudo su - db2inst1 -c "db2 create db TSTDWD01 ; db2 connect to TSTDWD01 ; db2 grant dbadm on database to user $USER"

# Export database schema

# generate schema DDL
#ssh hostname -c "db2look -d tstdwd01 -o db2look_tst_layout.sql -l"
#ssh hostname -c "db2look -d tstdwd01 -e -o db2look_tst.sql"
#scp hostname:db2look_tst_layout.sql .
#scp hostname:db2look_tst.sql .

# Modify export files for filesystem differences
# db2look_tst_layout.sql
#   comment out custom storage group creation
# db2look_tst.sql
#   %s/USING STOGROUP.*/USING STOGROUP "IBMSTOGROUP"/gc

# Import database schema

# Tablespaces (from 'db2look -d tstdwd01 -o db2look_tst_layout.sql -l')
echo "create Tablespaces"
sudo su - db2inst1 -c "db2 connect to TSTDWD01 ; db2 -tvf /vagrant/db2/db2look_tst_layout.sql" > /vagrant/db2/db2look_tst_layout.log

# Schemas (from db2look -d tstdwd01 -e -o db2look_tst.sql)
echo "create Schema"
sudo su - db2inst1 -c "db2 connect to TSTDWD01 ; db2 -tvf /vagrant/db2/db2look_tst.sql" > /vagrant/db2/db2look_tst.log


# Change password for db2inst1 to something we know (same as username)
sudo su - root -c "echo 'db2inst1:db2inst1' | chpasswd"

# Retrieve, extract and install log4db2
#sudo su - db2inst1 -c "cd ; wget https://github.com/angoca/log4db2/releases/download/log4db2-1-Beta-A/log4db2.tar.gz ; tar zxvf log4db2.tar.gz"
#sudo su - db2inst1 -c "db2 connect to db2unit ; cd ; cd log4db2 ; . ./init ; . ./install"

# Retrieve, extract and install db2unit
#sudo su - db2inst1 -c "cd ; wget https://github.com/angoca/db2unit/releases/download/db2unit-1/db2unit.tar.gz ; tar zxvf db2unit.tar.gz"
#sudo su - db2inst1 -c "db2 connect to db2unit ; cd ; cd db2unit ; . ./init ; . ./install"

echo "end script"
