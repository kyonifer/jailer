#!/usr/bin/env bash
set -e

sudo dpkg --add-architecture i386 

apt-get install wget apt-transport-https -y
wget -nc https://dl.winehq.org/wine-builds/Release.key
apt-key add Release.key
apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/ -y
apt-add-repository universe -y
apt-add-repository multiverse -y
apt-get update
apt-get install --install-recommends winehq-devel -y

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt install ttf-mscorefonts-installer -y
