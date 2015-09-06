FROM phusion/baseimage:latest

# apt-get
RUN apt-get update && apt-cache showpkg tmux && apt-get install -y \
    autojump \
    gcc \
    git \
    ipython \
    libc6-i386 \
    libc6-dev-i386 \
    libssl-dev \
    ltrace \
    make \
    man \
    nasm \
    nmap \
    python2.7 \
    python2.7-dev \
    python-pip \
    ruby2.0 \
    strace \
    wget \
    vim

# old gdb for peda
RUN curl -o /tmp/gdb.deb http://security.ubuntu.com/ubuntu/pool/main/g/gdb/gdb_7.4-2012.02-0ubuntu2_amd64.deb \
    && dpkg -i /tmp/gdb.deb

# tools
RUN pip install pwntools capstone ropgadget \
    && gem install bundler rubypwn
RUN git clone https://github.com/longld/peda.git ~/peda \
    && git clone https://github.com/niklasb/libc-database.git ~/libc-database && cd ~/libc-database && ./get

# qira
RUN cd ~/ && wget -qO- qira.me/dl | unxz | tar x \
    && cd qira && yes | ./install.sh

# enable ssh
RUN rm -f /etc/service/sshd/down && /etc/my_init.d/00_regen_ssh_host_keys.sh

# add ssh public key
ADD ssh /root/.ssh

# dotfiles
RUN git clone https://github.com/dm4/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh -f

# vim
ADD vim/vimrc /root/.vimrc
RUN git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall
