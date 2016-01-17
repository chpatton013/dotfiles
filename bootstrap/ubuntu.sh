#!/usr/bin/env bash

set -euo pipefail

sudo apt-get update
sudo apt-get upgrade --assume-yes
sudo apt-get install software-properties-common
sudo add-apt-repository --yes ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install --assume-yes \
  clang-3.6 \
  clang-3.7 \
  clang-format-3.6 \
  clang-format-3.7 \
  cmake \
  g++ \
  gcc \
  git \
  gnome-tweak-tool \
  make \
  neovim \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  tmux \
  tree \
  vim \
  zsh
