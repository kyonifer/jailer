#!/usr/bin/env bash
set -e

useradd $CONTAINER_USER -G wheel || true

# Alternatively consider: echo "$CONTAINER_USER:foo" | chpasswd
passwd -d $CONTAINER_USER

mkdir -p /home/$CONTAINER_USER
chown $CONTAINER_USER:$CONTAINER_USER /home/$CONTAINER_USER

pacman -Syu vim sudo --noconfirm

echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo $JAIL_NAME > /etc/hostname

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
