#!/bin/bash

# map files to external directory
# map history to external file?
# dotfiles are pulled off interwebs

#       -v /var/run/docker.sock:/var/run/docker.sock \

#
# Note: detach-keys option is necessary because otherwise
#   ctrl-p gets eaten, which is quite frustrating if you're
#   used to Emacs key bindings!
#
#       --user erewhon \
#       -v ~/.zsh_history:/u/erewhon/.zsh_history \
#       -v ~/.ssh:/u/erewhon/.ssh \

mkdir -p $HOME/.devshell

exec docker run \
       --user $( id -u ):$( id -g ) \
       --detach-keys="ctrl-@" \
       --pid host \
       --hostname $( hostname -s ) \
       -v $HOME/.ssh:/u/self/.ssh:ro \
       -v $HOME/.devshell:/u/self \
       -it \
       --rm \
       devshell

# docker run -it --rm docker.io/centos:centos7 /bin/bash
