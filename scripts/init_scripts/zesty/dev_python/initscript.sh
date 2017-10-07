#!/usr/bin/env bash
set -e

apt-add-repository universe -y
apt-add-repository multiverse -y

apt install python3-pip python3-matplotlib cython3 python3-ipython python3-notebook pylint3 -y


