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

mkdir -p $HOME/.ds

OTHER_ARGS="--pid host --user $( id -u ):$( id -g )"

exec docker run \
       $OTHER_ARGS \
       --detach-keys="ctrl-@" \
       --hostname $( hostname -s ) \
       -v $HOME/.ssh:/u/erewhon/.ssh:ro \
       -v $HOME/.ds:/u/erewhon \
       -it \
       --rm \
       devshell
