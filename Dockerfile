FROM phusion/baseimage:latest

# apt-get
RUN apt-get update && apt-cache showpkg tmux && apt-get install -y \
    gcc \
    gdb \
    git \
    make \
    netcat \
    netcat6 \
    python2.7 \
    python2.7-dev \
    python-pip \
    ruby \
    vim

# pwntools
RUN pip install pwntools

# rubypwn
RUN git clone https://bitbucket.org/atdog/rubypwn.git ~/rubypwn

# peda
RUN git clone https://github.com/longld/peda.git ~/peda

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
