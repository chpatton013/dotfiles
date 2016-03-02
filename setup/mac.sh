#!/usr/bin/env bash

set -euo pipefail

# Manually installed:
#   teamviewer
#   osxfuse
#
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
   # configure_ntfs
}

function install_homebrew() {
   local install_url="https://raw.githubusercontent.com/Homebrew/install/master/install"
   local install_file="$(mktemp)"

   curl --fail --silent --show-error --location "${install_url}" > "${install_file}"
   # Replace stdin with /dev/null so this install script does not wait for user.
   sudo ruby -- "${install_file}" </dev/null
   rm "${install_file}"

   sudo mkdir -p /opt/homebrew-cask/Caskroom
   sudo chmod -R 755 /opt/homebrew-cask
   sudo chown -R "$(id -un):admin" /opt/homebrew-cask
}

function install_packages() {
   brew cask

   brew tap homebrew/fuse
   brew tap homebrew/versions
   brew tap neovim/neovim

   brew update
   brew upgrade

   brew cask install \
      Caskroom/cask/xquartz \
      shiftit \
      vagrant \
      vagrant-manager \
      virtualbox

   brew install \
      clang-format \
      cmake \
      docker \
      docker-compose \
      docker-machine \
      docker-machine-parallels \
      gcc5 \
      git \
      htop \
      neovim \
      node \
      ntfs-3g \
      python \
      python3 \
      tmux \
      tree \
      vim \
      wget \
      zsh
}

function install_rust() {
   local install_url="https://static.rust-lang.org/rustup.sh"
   local install_file="$(mktemp)"

   curl --fail --silent --show-error --location "${install_url}" > "${install_file}"
   sudo sh "${install_file}" --yes
   rm "${install_file}"
}

# This only works in recovery mode.
function configure_ntfs() {
   local system_executable="/Volumes/Macintosh HD/sbin/mount_ntfs"
   local brew_executable="/usr/local/sbin/mount_ntfs"

   sudo mv "${system_executable}" "${system_executable}.original"
   sudo ln -s "${brew_executable}" "${system_executable}"
}

main
