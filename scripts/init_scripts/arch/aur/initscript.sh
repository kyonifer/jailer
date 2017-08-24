#!/usr/bin/env bash
set -e

source /etc/profile.d/perlbin.sh
pacman -Sy base-devel yajl expac git --noconfirm

pushd /home/$CONTAINER_USER
sudo -u kyonifer git clone https://aur.archlinux.org/pacaur.git
sudo -u kyonifer git clone https://aur.archlinux.org/cower.git

sudo -u kyonifer gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

pushd cower && sudo -u kyonifer makepkg && pacman -U --noconfirm cower*.tar.xz && popd
pushd pacaur && sudo -u kyonifer makepkg && pacman -U --noconfirm pacaur*.tar.xz && popd

popd

