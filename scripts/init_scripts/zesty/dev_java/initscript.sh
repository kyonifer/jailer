#!/usr/bin/env bash
set -e

apt-add-repository universe -y
apt-add-repository multiverse -y
apt update
apt install openjdk-8-jdk openjfx gradle libgfortran3 -y

