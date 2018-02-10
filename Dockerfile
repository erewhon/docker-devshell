#
# Generic development Docker
#
# docker build -t devshell .
# docker run -it --rm devshell
#

FROM docker.io/centos:centos7

#
# todo:
# - modern Ruby environment so I can install canonical Lolcat :)
# - modern Python environment?
# - newer node!
# - pass in user ID from outside; wrapper script to start it
# - java (not openjdk)
# - ack
# - gravitational teleport
# - CA?  Boulder?
#

#
# Install a few of my favorite things and prepare the environment.
#

#
# Remove manpage suppression from yum.conf, update, and install EPEL.
#   Then install a number of packages I like using.
#
RUN sed -i '/tsflags=nodocs/d' /etc/yum.conf && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y man
RUN yum install -y \
        ack \
        autossh \
        bind-utils \
        docker-client \
        emacs \
        expect \
        git \
        git-p4 \
        git-svn \
        golang \
        htop \
        jq \
        less-458-9.el7.x86_64 \
        mc \
        mosh \
        nc \
        ncurses-devel \
        net-tools \
        nodejs \
        npm \
        python-pip \
        rlwrap \
        the_silver_searcher \
        tmux \
        wget \
        which \
        yum-plugin-copr
#
# Build zsh since EPEL version is tool old...
#
# Weirdness with "expect" and "unbuffer" is because
#   configure script doesn't like being run without
#   a tty, so we fake it!
#
RUN cd /usr/local/src && \
    curl -L http://sourceforge.net/projects/zsh/files/zsh/5.4.2/zsh-5.4.2.tar.xz/download -o zsh-5.4.2.tar.xz && \
    tar xvJf zsh-5.4.2.tar.xz && \
    cd zsh-5.4.2 && \
    unbuffer ./configure && \
    make && \
    make install
RUN echo '/bin/zsh' >> /etc/shells && \
    ln -sv /usr/local/bin/zsh /bin/zsh

#
# Python things
#
RUN pip install httpie && \
    pip install httpie-jwt-auth && \
    pip install pygments
#   pip install glances

#
# Node things
#
RUN npm install -g yarn && \
    npm install -g cowsay && \
    npm install -g lolcatjs && \
    npm install -g vtop && \
    npm install -g slackadaisical
#
# Bling
#
RUN yum copr -y enable konimex/neofetch && \
    yum install -y neofetch

RUN mv /etc/localtime /etc/localtime.bak && \
    ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

#
# Set up an account.  We don't care about uid / gid as we'll
#   fix it in start.sh
#
RUN groupdel games && \
    mkdir -p /u && \
    useradd -d /u/erewhon -p password -m -s /usr/bin/zsh erewhon
    
#    useradd -d /u/erewhon --uid 501 -p password -m -s /usr/bin/zsh erewhon

#
# Install some things as embedded user
#
RUN su -c 'wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true' erewhon
RUN su -c 'git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k || true' erewhon
COPY scratch/dotfiles /u/erewhon/.dotfiles

#
# Fixup dotfiles
#
RUN su -c 'cd /u/erewhon; ./.dotfiles/mklinks' erewhon

# Ideally we should just clone inside container, but for now,
#   we clone outside container and copy into it...
# RUN su -c 'git clone git@github.com:erewhon/dotfiles.git ~/.dotfiles' erewhon
#   or.... I move to using homeshick

# ADD scripts/start.sh .

USER erewhon
WORKDIR /u/erewhon
ENV TERM xterm-256color

# CMD [ "/start.sh" ]

CMD [ "/usr/bin/zsh", "--login" ]
