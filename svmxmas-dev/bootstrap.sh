#!/bin/bash

## core packages
sudo apt update
sudo locale-gen en_AU.UTF-8
sudo apt-get install -y git
sudo apt-get install -y subversion
sudo apt-get install -y wget
sudo apt-get install -y unzip


## Time
# Vbox time drift between host is significant. NTP doesn't solve this.
#  better change vbox settings for provisioned environment as follows:
#    VBoxManage guestproperty set "VBOX name here" "/VirtualBox/GuestAdd/VBoxService/PARAMETER" --timesync-set-threshold=500
#    http://www.virtualbox.org/manual/ch09.html#changetimesync

echo "Australia/Sydney" | sudo tee /etc/timezone
#echo "Europe/London" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Node
sudo apt-get install -y nodejs
sudo apt-get install -y npm

# SQLLite
sudo apt-get install -y sqlite3

# fetch MAS tool
wget -q https://help.servicemax.com/resources/Storage/servicemax-go/go-debug-tool-1.5-GO1.6.0.zip
unzip go-debug-tool-1.5-GO1.6.0.zip

# move config file
mv go-debug-tool-1.5-GO1.6.0/config/default.json go-debug-tool-1.5-GO1.6.0/config/default.json.bak
cp /vagrant_config/default.json go-debug-tool-1.5-GO1.6.0/config/default.json

# run sync
cd ~/go-debug-tool-1.5-GO1.6.0
npm run init-db

# get db and run stats
cp ~/go-debug-tool-1.5-GO1.6.0/database/fsa.db /vagrant_data
chmod +x /vagrant_config/stats.sh
/vagrant_config/stats.sh > /vagrant_data/stats.csv

