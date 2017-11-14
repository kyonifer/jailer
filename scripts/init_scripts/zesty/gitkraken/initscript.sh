#!/usr/bin/env bash
#set -e

curl -O https://release.gitkraken.com/linux/gitkraken-amd64.deb
dpkg -i gitkraken-amd64.deb || true
apt-get install -yf 
apt-get install libxss1 libgnome-keyring0 libxkbfile-dev -y
