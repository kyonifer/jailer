#!/usr/bin/env bash
set -e

if [ ! -x "$(command -v pacaur)" ]; then
    echo "error: this addon requires the +aur addon"
    exit 1
fi


pacman -Sy gdb lldb rustup clang eigen cmake go go-tools --noconfirm

pushd /home/$CONTAINER_USER

# sudo -u kyonifer pacaur -S  --noconfirm --noedit

popd

