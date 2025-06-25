#!/bin/sh

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

VIM_SRC=/tmp/vim
PREFIX=/usr/local
STRIP_CMD=/usr/bin/true

export DEBIAN_FRONTEND=noninteractive

install_dependencies() {
    echo "Installing dependencies for Vim..."
    apt-get update
    apt-get install -y --no-install-recommends \
        git \
        make \
        clang \
        libtool-bin \
        lua5.1 \
        liblua5.1-0-dev \
        perl \
        libperl-dev \
        python3 \
        libpython3-dev \
        ruby \
        ruby-dev
}

clone_vim() {
    echo "Cloning Vim source code..."
    git clone --depth 1 https://github.com/vim/vim.git $VIM_SRC
}

build_and_install_vim() {
    echo "Building and installing Vim..."
    cd $VIM_SRC
    ./configure --prefix=$PREFIX \
        --with-features=huge \
        --enable-multibyte \
        --with-tlib=ncurses \
        --enable-cscope \
        --enable-terminal \
        --enable-luainterp=yes \
        --enable-perlinterp=yes \
        --enable-rubyinterp=yes \
        --enable-python3interp=yes \
        --enable-gui=no \
        --without-x \
        --enable-fail-if-missing
    make -j$(nproc)
    make install prefix=$PREFIX STRIP=$STRIP_CMD
}

cleanup() {
    echo "Cleaning up..."
    rm -rf $VIM_SRC
}

install_dependencies
clone_vim
build_and_install_vim

vim --version

cleanup

echo "Vim installation completed successfully!"
