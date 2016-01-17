#!/usr/bin/env bash

set -euo pipefail

neovim_ppa="ppa:neovim-ppa/unstable"
google_signing_key=https://dl-ssl.google.com/linux/linux_signing_key.pub
chrome_source_url="http://dl.google.com/linux/chrome/deb/"
chrome_source_entry="deb $chrome_source_url stable main"
chrome_source_list="/etc/apt/sources.list.d/google-chrome.list"
rust_install_url="https://static.rust-lang.org/rustup.sh"

# Neovim PPA
sudo apt-get install software-properties-common
sudo add-apt-repository --yes "$neovim_ppa"

# Google chrome repository
wget --quiet --output-document=- "$google_signing_key" | sudo apt-key add -
sudo sh --command="echo '$chrome_source_entry' >> $chrome_source_list"

# Packages
sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install --assume-yes \
  clang-3.6 \
  clang-3.7 \
  clang-format-3.6 \
  clang-format-3.7 \
  cmake \
  g++ \
  gcc \
  git \
  google-chrome-stable \
  gnome-tweak-tool \
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

# Rust
curl --silent --fail --location="$rust_install_url" | sudo sh
