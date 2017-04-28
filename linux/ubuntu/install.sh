#!/bin/bash
apt-get updgrade
apt-get update
apt-get install vim
apt-get install i3
apt-get install firefox

# Install ubuntu make in order to install the last developpers tools
sudo add-apt-repository ppa:ubuntu-desktop/ubuntu-make
sudo apt-get update
sudo apt-get install ubuntu-make

apt-get install git

# Install nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - 
sudo apt-get install -y nodejs

sudo apt-get install npm
sudo apt-get install xclip
