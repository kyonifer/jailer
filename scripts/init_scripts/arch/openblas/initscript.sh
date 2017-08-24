#!/usr/bin/env bash
set -e

if [ ! -x "$(command -v pacaur)" ]; then
    echo "error: this addon requires the +aur addon"
    exit 1
fi

pushd /home/$CONTAINER_USER

sudo -u kyonifer pacaur -Sy openblas-lapack-git --noconfirm --noedit

ln -s /usr/lib/libcblas.so /usr/lib/libcblas.so.3

popd

