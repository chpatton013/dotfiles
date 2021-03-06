#!/usr/bin/env bash
set -euo pipefail

debian_version="$(lsb_release --short --codename)"
kernel_version="$(uname --kernel-release)"

debian_source_entry="deb http://ftp.us.debian.org/debian jessie main non-free"

docker_keyserver="hkp://p80.pool.sks-keyservers.net:80"
docker_key="58118E89F3A912897C070ADBF76221572C52609D"
docker_source_entry="deb https://apt.dockerproject.org/repo debian-$debian_version main"

rust_install_url="https://static.rust-lang.org/rustup.sh"

sudo apt-get update
sudo apt-get install --assume-yes \
  apt-transport-https \
  ca-certificates \
  software-properties-common

# Debian non-free repository
sudo apt-add-repository --yes "$debian_source_entry"

# Docker repository
sudo apt-key adv --keyserver "$docker_keyserver" --recv-keys "$docker_key"
sudo apt-add-repository --yes "$docker_source_entry"

# Package installation
sudo apt-get update
sudo apt-get install --assume-yes \
  avahi-autoipd \
  avahi-daemon \
  clang-3.5 \
  clang-format-3.5 \
  cmake \
  docker-engine \
  g++ \
  gcc \
  git \
  golang-go \
  htop \
  ifstat \
  "linux-headers-$kernel_version" \
  "linux-image-$kernel_version" \
  lm-sensors \
  make \
  nodejs \
  nodejs-legacy \
  npm \
  openssh-client \
  openssh-server \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  ruby \
  stow \
  tmux \
  tree \
  vagrant \
  vagrant-libvirt \
  vim \
  zsh

# Install etckeeper separately so we can specify "git mode".
sudo apt-get install --assume-yes etckeeper git-core

# Vim linter.
sudo pip2 install vim-vint

# Neovim python support
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim

# Neovim ruby support
sudo gem install neovim

# Rust install
rust_install_file="$(mktemp)"
wget --quiet --output-document="$rust_install_file" "$rust_install_url"
sudo sh "$rust_install_file" --yes
rm "$rust_install_file"

# Code formatting.
sudo pip2 install yapf
sudo npm install --global js-beautify remark-cli
sudo gem install rubocop sass
cargo install rustfmt
go get github.com/bazelbuild/buildtools/buildifier
go get -u mvdan.cc/sh/cmd/shfmt

# Extra dev tools.
sudo pip2 install grip
cargo install fd-find ripgrep
sudo pip3 install --upgrade gdbgui

# Docker service and user account
sudo service docker restart
sudo usermod --append --groups docker "$(id --user --name)"

# Increase inotify maximum watch count.
echo 'fs.inotify.max_user_watches = 1048575' | sudo tee /etc/sysctl.d/99-max-user-watches.conf
sudo sysctl --load --system
