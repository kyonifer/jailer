#!/usr/bin/env bash
set -e

useradd $CONTAINER_USER -G sudo

# alternatively, consider 'echo "$CONTAINER_USER:foo" | chpasswd'
passwd -d $CONTAINER_USER
echo $JAIL_NAME > /etc/hostname

# appears to be issues with ubuntu and nspawn
rm /etc/resolv.conf
echo "nameserver 192.168.1.1" > /etc/resolv.conf

# fix for nspawn#852
rm /etc/securetty

# enable alsa -> pulse to enable legacy alsa applications
mv /initscripts/asound.conf /etc/asound.conf

# why are security updates off by default?
echo "deb http://archive.ubuntu.com/ubuntu/ zesty-security main restricted universe multiverse" >> /etc/apt/sources.list
apt update
apt upgrade -y

locale-gen en_US.UTF-8

apt-get install software-properties-common -y
apt-get install vim libvorbisfile3 curl -y
if compgen -G "/root/extra*.sh" > /dev/null; then
    for f in /root/extra*.sh; do source $f; done
fi

