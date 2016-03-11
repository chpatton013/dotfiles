#!/usr/bin/env bash

set -euo pipefail

tmux_ppa="ppa:pi-rho/dev"
neovim_ppa="ppa:neovim-ppa/unstable"
rust_install_url="https://static.rust-lang.org/rustup.sh"

sudo apt-get install --assume-yes software-properties-common

# Tmux PPA
sudo add-apt-repository --yes "$tmux_ppa"

# Neovim PPA
sudo add-apt-repository --yes "$neovim_ppa"

# Package installation
sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install --assume-yes \
   clang-3.6 \
   clang-format-3.6 \
   cmake \
   g++ \
   gcc \
   git \
   gnome-tweak-tool \
   htop \
   make \
   neovim \
   nodejs \
   nodejs-legacy \
   npm \
   openssh-client \
   openssh-server \
   python-dev \
   python-pip \
   python3-dev \
   python3-pip \
   tmux=2.0-1~ppa1~t \
   tree \
   vagrant \
   vim \
   zsh

# Rust install
rust_install_file="$(mktemp)"
wget --quiet --output-document="$rust_install_file" "$rust_install_url"
sudo sh "$rust_install_file" --yes
rm "$rust_install_file"
