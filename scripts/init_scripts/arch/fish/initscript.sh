#!/usr/bin/env bash

set -e

pacman -Sy fish git --noconfirm
chsh $CONTAINER_USER -s /usr/bin/fish
chsh root -s /usr/bin/fish
mkdir -p /root/.local/bin
