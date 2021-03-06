FROM phusion/baseimage:latest

# apt-get
RUN dpkg --add-architecture i386 && apt-get update && apt-cache showpkg tmux && apt-get install -y \
    autojump \
    gawk \
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
    ruby \
    strace \
    sudo \
    wget \
    vim

# compile glibc-2.19 with debug symbol
ADD http://ftp.gnu.org/gnu/glibc/glibc-2.19.tar.gz /tmp/
RUN mkdir -p /root/glibc/64 /root/glibc/32 \
    && tar zxvf /tmp/glibc-2.19.tar.gz -C /root/glibc \
    && mkdir -p /root/glibc/glibc-2.19/build64 /root/glibc/glibc-2.19/build32 \
    && cd /root/glibc/glibc-2.19/build64 \
    && CFLAGS="-g -g3 -ggdb -gdwarf-4 -Og"  \
        CXXFLAGS="-g -g3 -ggdb -gdwarf-4 -Og" \
        ../configure --prefix=/root/glibc/64 \
    && make all && make install \
    && cd /root/glibc/glibc-2.19/build32 \
    && CC="gcc -m32" CXX="g++ -m32" \
        CFLAGS="-g -g3 -ggdb -gdwarf-4 -Og" \
        CXXFLAGS="-g -g3 -ggdb -gdwarf-4 -Og" \
        ../configure --prefix=/root/glibc/32 --host=i686-linux-gnu \
    && make all && make install

# old gdb for peda
RUN curl -o /tmp/gdb.deb http://security.ubuntu.com/ubuntu/pool/main/g/gdb/gdb_7.4-2012.02-0ubuntu2_amd64.deb \
    && dpkg -i /tmp/gdb.deb

# tools
RUN pip install pwntools capstone ropgadget \
    && gem install bundler # rubypwn
RUN git clone https://github.com/longld/peda.git ~/peda \
    && git clone https://github.com/niklasb/libc-database.git ~/libc-database && cd ~/libc-database && ./get

# qira
RUN cd /root \
    && wget -qO- https://github.com/BinaryAnalysisPlatform/qira/archive/v1.2.tar.gz \
    | tar zx && cd qira-1.2 && ./install.sh

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
