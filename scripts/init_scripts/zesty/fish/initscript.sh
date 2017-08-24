#!/usr/bin/env bash
set -e

apt-add-repository ppa:fish-shell/release-2 -y
apt-get update
apt-get install fish -y
chsh $CONTAINER_USER -s /usr/bin/fish
chsh root -s /usr/bin/fish

