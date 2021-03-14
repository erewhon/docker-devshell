#!/bin/bash

# script adapted from interwebs
#   https://github.com/docker-library/mysql/issues/99

# TARGET_UID=$(stat -c "%u" /u/erewhon/.ssh)
# TARGET_GID=$(stat -c "%g" /u/erewhon/.ssh)

# echo "Setting erewhon:erewhon uid / gid to ${TARGET_UID}:${TARGET_GID}"
# usermod -o -u $TARGET_UID erewhon || true
# groupmod -o -g $TARGET_GID erewhon || true

# chown -R erewhon:erewhon /u/erewhon > /dev/null 2>&1 

export TERM=xterm-256color

su --login erewhon

# useradd -d /u/erewhon --uid $userid -p password -m -s /usr/bin/zsh erewhon

# git config --global user.email "you@example.com"
# git config --global user.name "Your Name”
# git config --global core.editor "vim”

