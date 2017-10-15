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
  install_core
  install_cpp
  install_java
  install_bazel
  install_python
  install_go
  install_js
  install_ruby
  install_rust
  install_docker
  install_vagrant
  install_web_tools
  install_dev_tools
  install_user_tools
}

function _ruby_version() {
  "$@" --version | sed 's/^ruby \([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/g'
}

function install_homebrew() {
  local install_url="https://raw.githubusercontent.com/Homebrew/install/master/install"

  # Replace stdin with /dev/null so this install script does not wait for input.
  /usr/bin/ruby -e "$(curl --fail --silent --show-error --location "$install_url")" </dev/null

  sudo mkdir -p /opt/homebrew-cask/Caskroom
  sudo chmod -R 755 /opt/homebrew-cask
  sudo chown -R "$(id -un):admin" /opt/homebrew-cask

  # Open all taps before updating.
  brew tap homebrew/dupes
  brew tap homebrew/versions
  brew tap neovim/neovim
  brew tap jeffreywildman/homebrew-virt-manager

  brew update
  brew upgrade
}

function install_core() {
  brew cask install Caskroom/cask/xquartz

  brew install file-formula fswatch nmap openssh rsync tree unzip wget

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
}

function install_cpp() {
  brew install clang-format cmake gcc gcc5
}

function install_java() {
  brew cask install java
}

function install_cpp() {
  brew install bazel buildifier
}

function install_python() {
  local packages_dir="$HOME/Library/Python/2.7/lib/python/site-packages"
  local brew_path_file="$packages_dir/homebrew.pth"
  local patch='import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")'

  brew install python python3 pyenv
  sudo pip2 install yapf

  mkdir -p "$packages_dir"
  if [ ! -f "$brew_path_file" ] || ! grep -q "$patch" "$brew_path_file"; then
    echo "$patch" >>"$brew_path_file"
  fi
}

function install_go() {
  brew install golang
}

function install_js() {
  brew install node
  sudo npm install --global js-beautify
}

function install_ruby() {
  brew install rbenv ruby ruby-build
  rbenv install "$(_ruby_version ruby)"
  sudo gem install rubocop
}

function install_rust() {
  local install_url="https://static.rust-lang.org/rustup.sh"
  curl --fail --silent --show-error --location "$install_url" | sh
  cargo install rustfmt
}

function install_docker() {
  brew install docker docker-compose docker-machine docker-machine-parallels
}

function install_vagrant() {
  brew cask install vagrant vagrant-manager virtualbox
  brew install libiconv libvirt virt-manager virt-viewer

  rbenv install "$(_ruby_version /opt/vagrant/embedded/bin/ruby)"
  vagrant plugin install vagrant-libvirt
}

function install_web_tools() {
  sudo gem install sass
}

function install_dev_tools() {
  brew install \
    fd \
    file-formula \
    fswatch \
    git \
    gpatch \
    gpg \
    grip \
    htop \
    ifstat \
    less \
    neovim \
    nmap \
    reattach-to-user-namespace \
    ripgrep \
    stow \
    tmux \
    vim \
    zsh

  sudo pip2 install vim-vint

  sudo pip2 install --upgrade neovim
  sudo pip3 install --upgrade neovim

  sudo gem install neovim

  sudo npm install --global remark-cli

  go get -u mvdan.cc/sh/cmd/shfmt
}

function install_user_tools() {
  brew cask install shiftit karabiner-elements
}

main
