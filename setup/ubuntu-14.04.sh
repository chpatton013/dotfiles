#!/usr/bin/env bash
set -euo pipefail

ubuntu_version="$(lsb_release --short --codename)"
kernel_version="$(uname --kernel-release)"

ruby_ppa="ppa:brightbox/ruby-ng"
nodejs_ppa="ppa:chris-lea/node.js"
git_ppa="ppa:git-core/ppa"
tmux_ppa="ppa:pi-rho/dev"
neovim_ppa="ppa:neovim-ppa/unstable"

google_signing_key="https://dl-ssl.google.com/linux/linux_signing_key.pub"
chrome_source_entry="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"

docker_keyserver="hkp://p80.pool.sks-keyservers.net:80"
docker_key="58118E89F3A912897C070ADBF76221572C52609D"
docker_source_entry="deb https://apt.dockerproject.org/repo ubuntu-$ubuntu_version main"

rust_install_url="https://static.rust-lang.org/rustup.sh"

sudo apt-get update
sudo apt-get install --assume-yes software-properties-common

# Ruby PPA
sudo apt-add-repository --yes "$ruby_ppa"

# NodeJS PPA
sudo add-apt-repository --yes "$nodejs_ppa"

# Git PPA
sudo add-apt-repository --yes "$git_ppa"

# Tmux PPA
sudo add-apt-repository --yes "$tmux_ppa"

# Neovim PPA
sudo add-apt-repository --yes "$neovim_ppa"

# Google chrome repository
wget --quiet --output-document=- "$google_signing_key" | sudo apt-key add -
sudo apt-add-repository --yes "$chrome_source_entry"

# Docker repository
sudo apt-key adv --keyserver "$docker_keyserver" --recv-keys "$docker_key"
sudo apt-add-repository --yes "$docker_source_entry"

# Package installation
sudo apt-get update
sudo apt-get install --assume-yes \
  avahi-autoipd \
  avahi-daemon \
  chromium-browser \
  clang-3.6 \
  clang-format-3.6 \
  cmake \
  cmake-data \
  docker-engine \
  g++ \
  gcc \
  git \
  golang-go \
  google-chrome-stable \
  gnome-tweak-tool \
  htop \
  ifstat \
  inotify-tools \
  "linux-image-extra-$kernel_version" \
  lm-sensors \
  make \
  neovim \
  openssh-client \
  openssh-server \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  ruby2.4 \
  ruby2.4-dev \
  stow \
  tmux=2.0-1~ppa1~t \
  tree \
  vagrant \
  vim \
  zsh

# Install etckeeper separately so we can specify "git mode".
sudo apt-get install --assume-yes etckeeper git-core

# Go setup
export GOPATH=~/go
mkdir --parents "$GOPATH"

# Vim linter.
sudo pip2 install vim-vint

# Neovim python support
sudo pip2 install --upgrade neovim
sudo pip3 install --upgrade neovim

# Neovim ruby support
sudo gem install neovim

# NodeJS install
curl --silent --location https://deb.nodesource.com/setup_6.x | sudo --preserve-env bash -
sudo apt-get install --assume-yes nodejs

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

# Docker service and user account
sudo service docker restart
sudo usermod --append --groups docker "$(id --user --name)"
