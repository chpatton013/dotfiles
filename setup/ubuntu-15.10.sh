#!/usr/bin/env bash
set -euo pipefail

ubuntu_version="$(lsb_release --short --codename)"
kernel_version="$(uname --kernel-release)"

git_ppa="ppa:git-core/ppa"
tmux_ppa="ppa:pi-rho/dev"
neovim_ppa="ppa:neovim-ppa/unstable"

google_signing_key="https://dl-ssl.google.com/linux/linux_signing_key.pub"
chrome_source_entry="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"

docker_keyserver="hkp://p80.pool.sks-keyservers.net:80"
docker_key="58118E89F3A912897C070ADBF76221572C52609D"
docker_source_entry="deb https://apt.dockerproject.org/repo ubuntu-$ubuntu_version main"

virtualbox_signing_key="https://www.virtualbox.org/download/oracle_vbox.asc"
virtualbox_source_entry="deb http://download.virtualbox.org/virtualbox/debian $ubuntu_version contrib"

rust_install_url="https://static.rust-lang.org/rustup.sh"

sudo apt-get update
sudo apt-get install --assume-yes software-properties-common

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

# Virtualbox repository
wget --quiet --output-document=- "$virtualbox_signing_key" | sudo apt-key add -
sudo apt-add-repository --yes "$virtualbox_source_entry"

# Package installation
sudo apt-get update
sudo apt-get install --assume-yes \
  avahi-autoipd \
  avahi-daemon \
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
  nodejs \
  nodejs-legacy \
  npm \
  openssh-client \
  openssh-server \
  python-dev \
  python-pip \
  python3-dev \
  python3-pip \
  rbenv \
  ruby \
  ruby-build \
  stow \
  tmux=2.0-1~ppa1~t \
  tree \
  vagrant \
  vagrant-libvirt \
  vim \
  virtualbox-5.0 \
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
