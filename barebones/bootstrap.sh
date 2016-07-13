#!/bin/bash

## core packages
sudo locale-gen en_AU.UTF-8
sudo apt-get install -y git
sudo apt-get install -y subversion

## Time
# Vbox time drift between host is significant. NTP doesn't solve this.
#  better change vbox settings for provisioned environment as follows:
#    VBoxManage guestproperty set "VBOX name here" "/VirtualBox/GuestAdd/VBoxService/PARAMETER" --timesync-set-threshold=500
#    http://www.virtualbox.org/manual/ch09.html#changetimesync

echo "Australia/Sydney" | sudo tee /etc/timezone
#echo "Europe/London" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata


## File System



