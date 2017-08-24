#!/usr/bin/env bash
set -e

if [ ! -x "$(command -v pacaur)" ]; then
    echo "error: this addon requires the +aur addon"
    exit 1
fi

pushd /home/$CONTAINER_USER

sudo -u kyonifer pacaur -Sy libgfortran6 --noconfirm --noedit

popd

