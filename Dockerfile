#
# Generic development Docker
#
# docker build -t devshell .
# docker run -it --rm devshell
#   map in .ssh, .devshell
#

#
# Tools:
# - [X] mysql tools
# - [ ] ansible
# - [ ] jq
# - [ ] fx
# - [ ] httpie
# - [ ] exa
# - [ ] rg
# - [X] git
# - [X] zsh
# - [X] mosh
# - [X] nc
# - [ ] pandoc
# - [ ] rlwrap
# - [X] tmux
# - [ ] usql
#
# Languages:
# - Java 8
# - Java 11
# - Java <most recent>
# - Go
# - Python
#

#
# below version is 8.1.1911 as of 2020/02/09
#
FROM docker.io/centos@sha256:fe8d824220415eed5477b63addf40fb06c3b049404242b31982106ac204f6700

#
# Update yum, turn on EPEL
#
RUN yum update -y -q && \
    yum install -y -q epel-release && \
    yum update -y -q

#
# Install all the toolz!
#
RUN yum install -y -q \
    ack \
    emacs \
    git \
    git-svn \
    man \
    mc \
    mosh \
    mysql \
    nc \
    tmux \
    wget \
    which \
    zsh

# temp: need to figure out better way of doing this!
ARG USER_ID
RUN useradd -u ${USER_ID} self

ENV HOME /u/self

WORKDIR /u/self


#
# Install the following outside of EPEL because they tend to be updated
#   more frequently
#

# Go and dependent tools

# Node and dependent tools

# Python and dependent tools

# Rust and dependent tools

# Gratuitous bling


# Done

CMD [ "/usr/bin/zsh", "--login" ]
