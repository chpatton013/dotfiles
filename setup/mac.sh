#!/usr/bin/env bash
set -xeuo pipefail

# Installed via getmacapps.com:
#   alfred
#   caffeine
#   chrome
#   cyberduck
#   flux
#   iterm2
#   skype
#   spotify
#   steam
#   textwrangler
#   vlc

function main() {
  install_homebrew
  install_packages
  install_rust
}

function install_homebrew() {
  local install_url="https://raw.githubusercontent.com/Homebrew/install/master/install"
  local install_file="$(mktemp)"

  curl --fail --silent --show-error --location "${install_url}" > "${install_file}"
  # Replace stdin with /dev/null so this install script does not wait for user.
  ruby -- "${install_file}" </dev/null
  rm "${install_file}"

  sudo mkdir -p /opt/homebrew-cask/Caskroom
  sudo chmod -R 755 /opt/homebrew-cask
  sudo chown -R "$(id -un):admin" /opt/homebrew-cask
}

function install_packages() {
  brew cask

  brew tap homebrew/dupes
  brew tap homebrew/versions
  brew tap neovim/neovim

  brew update
  brew upgrade

  brew cask install \
    Caskroom/cask/xquartz \
    java \
    shiftit \
    vagrant \
    vagrant-manager \
    virtualbox

  # Missing or out-dated utilities.
  brew install \
    bazel \
    clang-format \
    cmake \
    docker \
    docker-compose \
    docker-machine \
    docker-machine-parallels \
    file-formula \
    fswatch \
    gcc5 \
    git \
    gpatch \
    gpg \
    htop \
    less \
    neovim \
    nmap \
    node \
    openssh \
    python \
    python3 \
    rsync \
    stow \
    tmux \
    tree \
    unzip \
    vim \
    wget \
    zsh

  # GNU utilities.
  brew install binutils
  brew install coreutils
  brew install diffutils
  brew install ed --default-names
  brew install findutils --with-default-names
  brew install gawk
  brew install gnu-indent --with-default-names
  brew install gnu-sed --with-default-names
  brew install gnu-tar --with-default-names
  brew install gnu-which --with-default-names
  brew install gnutls
  brew install grep --with-default-names
  brew install gzip
  brew install screen
  brew install watch
  brew install wdiff --with-gettext
  brew install wget

  sudo pip2 install --upgrade neovim
  sudo pip3 install --upgrade neovim
}

function install_rust() {
  local install_url="https://static.rust-lang.org/rustup.sh"
  local install_file="$(mktemp)"

  curl --fail --silent --show-error --location "${install_url}" > "${install_file}"
  sudo sh "${install_file}" --yes
  rm "${install_file}"
}

main
