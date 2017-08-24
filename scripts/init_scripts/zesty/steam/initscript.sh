#!/usr/bin/env bash
set -e

dpkg --add-architecture i386
apt-add-repository multiverse -y
apt update
apt install steam mesa-utils -y
