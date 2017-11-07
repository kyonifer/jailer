#!/usr/bin/env bash
set -e

apt-add-repository universe -y
apt update
apt install lyx git -y
