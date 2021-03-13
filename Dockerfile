#
# Generic development Docker
#
# docker build -t devshell .
# docker run -it --rm devshell
#   map in .ssh, .devshell
#

# todo:
# - modularize Docker files?
#
# Tools:
# - [ ] pandoc
# - [ ] rlwrap
#
# Languages:
# - Java 8
# - Java 11
# - Java <most recent>
#

#
# below version is AMD64 v8.3.2011 as of 2021/03/12
#                  ARM is 7723d6b5d15b1c64d0a82ee6298c66cf8c27179e1c8a458e719041ffd08cd091
#
FROM docker.io/centos@sha256:dbbacecc49b088458781c16f3775f2a2ec7521079034a7ba499c8b0bb7f86875

#
# Update yum, turn on EPEL
#
RUN yum update -y -q && \
    yum install -y -q epel-release && \
    yum update -y -q

#
# Install all the toolz!
#
RUN dnf install -y -q \
    ack \
    emacs \
    git \
    git-svn \
    jq \
    man \
    mc \
    mosh \
    mysql \
    nc \
    tmux \
    wget \
    which \
    xz \
    zsh

#
# Install a bunch of development-related packages that later
#   stages will need

RUN dnf -y -q groupinstall 'development tools' && \
    dnf -y -q install bzip2-devel expat-devel gdbm-devel \
        libffi-devel ncurses-devel openssl-devel readline-devel \
        sqlite-devel tk-devel xz-devel zlib-devel wget

RUN mv /etc/localtime /etc/localtime.bak && \
    ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

#
# Install the following outside of EPEL because they tend to be updated
#   more frequently
#
##################################################
#
# Go and dependent tools
#

RUN curl --silent https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz | \
    tar -C /usr/local -xzf - && \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile && \
    echo 'export PATH=$PATH:/usr/local/opt/bin' >> /etc/profile

RUN export GOPATH=/usr/local/opt && \
    export PATH=/usr/local/go/bin:$PATH && \
    go get github.com/yudai/gotty && \
    go get github.com/fullstorydev/grpcurl && \
    go install github.com/fullstorydev/grpcurl/cmd/grpcurl && \
    go get -u github.com/xo/usql && \
    go get -u github.com/golang/protobuf/protoc-gen-go && \
    go get -u github.com/davecheney/httpstat

#
# bling
#
RUN env GOPATH=/usr/local/opt /usr/local/go/bin/go get -u github.com/justjanne/powerline-go


##################################################
#
# Python and dependent tools
#

RUN cd /tmp && \
    curl --silent https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz | tar xzf - && \
    cd /tmp/Python-3.8*/ && \
    echo "$(date) configuring python 3" && \
    ./configure --enable-optimizations --quiet && \
    echo "$(date) building python 3" && \
    make -j 4 install > /dev/null && \
    echo "$(date) done" && \
    rm -rf /tmp/Python-3*
 
RUN pip3 install --upgrade pip && \
    pip3 install httpie && \
    pip3 install httpie-jwt-auth && \
    pip3 install pygments && \
    pip3 install ansible

#    pip3 install glances

##################################################
#
# Node and dependent tools
#
RUN curl --silent https://nodejs.org/dist/v13.8.0/node-v13.8.0-linux-x64.tar.xz | \
    tar --strip-components 1 -xJf - -C /usr/local

RUN npm install -g yarn && \
    npm install -g cowsay && \
    npm install -g lolcatjs && \
    npm install -g fx && \
    npm install -g quicktype

##################################################
#
# Rust and dependent tools
#
RUN wget -q -O /usr/local/bin/rustup-init https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init && \
    chmod 755 /usr/local/bin/rustup-init && \
    mkdir -p /usr/local/rust && \
    export HOME=/usr/local/rust && \
    /usr/local/bin/rustup-init -y

RUN export HOME=/usr/local/rust && \
    source /usr/local/rust/.cargo/env && \
    cargo install --root /usr/local exa

RUN export HOME=/usr/local/rust && \
    source /usr/local/rust/.cargo/env && \
    cargo install --root /usr/local ripgrep

RUN wget --quiet https://github.com/protocolbuffers/protobuf/releases/download/v3.11.3/protoc-3.11.3-linux-x86_64.zip && \
    unzip protoc-3.11.3-linux-x86_64.zip -d /usr/local && \
    chmod 755 /usr/local/bin/protoc && \
    chmod -R +rx /usr/local/include/google

##################################################

# temp: need to figure out better way of doing this!
ARG USER_ID
ARG GROUP_ID
RUN groupadd -g ${GROUP_ID} self || true
RUN useradd -u ${USER_ID} -g ${GROUP_ID} self

ENV HOME /u/self
ENV TERM xterm-256color

WORKDIR /u/self

##################################################
#
# Gratuitous bling
#

##################################################
#
# Done
#
CMD [ "/usr/bin/zsh", "--login" ]
