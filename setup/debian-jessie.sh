#!/usr/bin/env bash

set -euo pipefail

debian_version="$(lsb_release --short --codename)"
kernel_version="$(uname --kernel-release)"

docker_keyserver="hkp://p80.pool.sks-keyservers.net:80"
docker_key="58118E89F3A912897C070ADBF76221572C52609D"
docker_source_entry="deb https://apt.dockerproject.org/repo debian-$debian_version main"

rust_install_url="https://static.rust-lang.org/rustup.sh"

sudo apt-get update
sudo apt-get install --assume-yes \
   apt-transport-https \
   ca-certificates \
   software-properties-common

# Docker repository
sudo apt-key adv --keyserver "$docker_keyserver" --recv-keys "$docker_key"
sudo apt-add-repository --yes "$docker_source_entry"

# Package installation
sudo apt-get update
sudo apt-get install --assume-yes \
   clang-3.5 \
   clang-format-3.5 \
   cmake \
   docker-engine \
   g++ \
   gcc \
   git \
   htop \
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
   tmux \
   tree \
   vagrant \
   vim \
   zsh

# Rust install
rust_install_file="$(mktemp)"
wget --quiet --output-document="$rust_install_file" "$rust_install_url"
sudo sh "$rust_install_file" --yes
rm "$rust_install_file"

# Docker service and user account
sudo service docker restart
sudo usermod --append --groups docker "$(id --user --name)"
