#!/usr/bin/env bash
set -e

if [ ! -x "$(command -v pacaur)" ]; then
    echo "error: this addon requires the +aur addon"
    exit 1
fi

pacman -Sy unzip gedit gedit-plugins ttf-inconsolata openssh pkgfile --noconfirm
pkgfile --update

pushd /home/$CONTAINER_USER

# ncurses
sudo -u $CONTAINER_USER gpg --recv-keys C52048C0C0748FEE227D47A2702353E0F7E48EDB
#curl via gitkraken
sudo -u $CONTAINER_USER gpg --recv-key 5CC908FDB71E12C2
# currently broken: ncurses5-compat-libs 
# libxkbfile needed for kraken
sudo -u $CONTAINER_USER pacaur -S libxkbfile gitkraken lcm --noconfirm --noedit

popd

