#!/usr/bin/env bash
set -e

VERSION="2017.2.6"
NAME="ideaIC-$VERSION"

curl -LO https://download.jetbrains.com/idea/$NAME-no-jdk.tar.gz
mkdir -p /opt/$NAME
tar -C /opt/$NAME --strip-components=1 -zxvf $NAME-no-jdk.tar.gz
