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

OTHER_ARGS="--pid host --user $( id -u ):$( id -g )"

exec docker run \
       $OTHER_ARGS \
       --detach-keys="ctrl-@" \
       --hostname $( hostname -s ) \
       -v $HOME/.ssh:/u/self/.ssh:ro \
       -v $HOME/.devshell:/u/self \
       -p 8000:8000 \
       -p 8001:8001 \
       -p 8002:8002 \
       -p 8003:8003 \
       -p 8004:8004 \
       -p 8888:8888 \
       -it \
       --rm \
       devshell

# docker run -it --rm docker.io/centos:centos7 /bin/bash
