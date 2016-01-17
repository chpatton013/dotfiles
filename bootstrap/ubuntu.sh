#!/usr/bin/env bash

set -euo pipefail

neovim_ppa="ppa:neovim-ppa/unstable"
google_signing_key="https://dl-ssl.google.com/linux/linux_signing_key.pub"
chrome_source_entry="deb http://dl.google.com/linux/chrome/deb/ stable main"
chrome_source_list="/etc/apt/sources.list.d/google-chrome.list"
docker_keyserver="hkp://p80.pool.sks-keyservers.net:80"
docker_key="58118E89F3A912897C070ADBF76221572C52609D"
docker_source_list="/etc/apt/sources.list.d/docker.list"
docker_source_entry="deb https://apt.dockerproject.org/repo ubuntu-vivid main"
rust_install_url="https://static.rust-lang.org/rustup.sh"

# Neovim PPA
sudo apt-get install software-properties-common
sudo add-apt-repository --yes "$neovim_ppa"

# Google chrome repository
wget --quiet --output-document=- "$google_signing_key" | sudo apt-key add -
sudo su --command="echo '$chrome_source_entry' > $chrome_source_list"

# Docker repository
sudo apt-key adv --keyserver "$docker_keyserver" --recv-keys "$docker_key"
sudo su --command="echo '$docker_source_entry' > $docker_source_list"

# Package installation
sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install --assume-yes \
   chromium-browser \
   clang-3.6 \
   clang-3.7 \
   clang-format-3.6 \
   clang-format-3.7 \
   cmake \
   docker-engine \
   g++ \
   gcc \
   git \
   google-chrome-stable \
   gnome-tweak-tool \
   linux-image-extra-$(uname -r) \
   make \
   neovim \
   nodejs \
   nodejs-legacy \
   npm \
   python-dev \
   python-pip \
   python3-dev \
   python3-pip \
   tmux \
   tree \
   vim \
   zsh

# Rust install
wget --quiet --output-document=/tmp/rustup.sh "$rust_install_url"
sudo sh /tmp/rustup.sh --yes
rm /tmp/rustup.sh

# Docker service and user account
sudo service docker start
sudo usermod --append --groups docker "$(id --user --name)"
