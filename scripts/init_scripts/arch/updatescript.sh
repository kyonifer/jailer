#!/usr/bin/env bash
set -e

pacman -Syu --noconfirm

if [ -x "$(command -v pacaur)" ]; then
    pushd /home/$CONTAINER_USER
    sudo -u $CONTAINER_USER pacaur -Syau --noconfirm --noedit
    popd
fi
