#!/bin/sh

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

install_dependencies() {
    echo "Installing dependencies for Homebrew..."
    apt-get update
    apt-get install -y --no-install-recommends \
        sudo \
        build-essential \
        procps \
        curl \
        ca-certificates \
        file \
        git
}

install_homebrew() {
    echo "Installing Homebrew..."
    if [ ! -d /home/linuxbrew/.linuxbrew ]; then
        /usr/bin/sudo -u ${_REMOTE_USER} NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> /etc/profile.d/00-restore-env.sh
}

install_dependencies
install_homebrew

/home/linuxbrew/.linuxbrew/bin/brew --version

echo "Homebrew installation completed successfully!"
