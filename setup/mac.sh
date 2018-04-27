#!/usr/bin/env bash
set -xeuo pipefail

function main() {
  if [ "$(id -u)" -eq 0 ]; then
    echo This script should not be run as root. Exiting. >&2
    exit 1
  fi

  sudo --validate

  make_destination_dirs
  install_homebrew
  install_core
  install_cpp
  install_bazel
  install_python
  install_go
  install_js
  install_lua
  install_ruby
  install_rust
  install_docker
  install_vagrant
  install_web_tools
  install_dev_tools
  install_user_tools
  install_vim
}

function _ruby_version() {
  "$@" --version | sed 's/^ruby \([0-9]*\.[0-9]*\.[0-9]*\).*$/\1/g'
}

function make_destination_dirs() {
  mkdir -p ~/bin ~/dependencies ~/projects
}

function install_homebrew() {
  local install_url="https://raw.githubusercontent.com/Homebrew/install/master/install"

  # Replace stdin with /dev/null so this install script does not wait for input.
  /usr/bin/ruby -e "$(curl --fail --silent --show-error --location "$install_url")" </dev/null

  sudo mkdir -p /opt/homebrew-cask/Caskroom
  sudo chmod -R 755 /opt/homebrew-cask
  sudo chown -R "$(id -un):admin" /opt/homebrew-cask

  # Open all taps before updating.
  brew tap neovim/neovim
  brew tap jeffreywildman/homebrew-virt-manager

  brew update
  brew upgrade
  brew cask upgrade
}

function install_core() {
  brew cask install Caskroom/cask/xquartz

  brew install file-formula fswatch nmap openssh rsync tree unzip wget

  # GNU utilities.
  brew install binutils --with-default-names
  brew install coreutils --with-default-names
  brew install diffutils --with-default-names
  brew install ed --with-default-names
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

function install_bazel() {
  brew cask install java caskroom/versions/java8
  brew install bazel buildifier
}

function install_python() {
  local packages_dir="$HOME/Library/Python/2.7/lib/python/site-packages"
  local brew_path_file="$packages_dir/homebrew.pth"
  local patch='import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")'

  brew install python python3 pyenv
  pip2 install --user yapf

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
  npm install --global --prefix=~/.npm js-beautify
}

function install_lua() {
  brew install lua
}

function install_ruby() {
  brew install rbenv ruby ruby-build
  rbenv install --skip-existing "$(_ruby_version ruby)"
  gem install --user-install rubocop
}

function install_rust() {
  sh <(curl --fail --silent --show-error --location https://sh.rustup.rs) \
    --no-modify-path -y
  [ -f ~/.cargo/bin/rustfmt ] || cargo install rustfmt
  rustup install nightly
  rustup default nightly
}

function install_docker() {
  brew install docker docker-compose docker-machine docker-machine-parallels
}

function install_vagrant() {
  brew cask install vagrant vagrant-manager virtualbox
  brew install libiconv libvirt virt-manager virt-viewer

  local vagrant_ruby_version
  vagrant_ruby_version="$(_ruby_version /opt/vagrant/embedded/bin/ruby)"
  readonly vagrant_ruby_version

  rbenv install --skip-existing "$vagrant_ruby_version"

  (
    export CONFIGURE_ARGS="with-ldflags=-L/opt/vagrant/embedded/lib with-libvirt-include=/usr/local/include/libvirt with-libvirt-lib=/usr/local/lib"
    export GEM_HOME="~/.vagrant.d/gems/$vagrant_ruby_version"
    export GEM_PATH="$GEM_HOME:/opt/vagrant/embedded/gems"
    export PATH="/opt/vagrant/embedded/bin:$PATH"

    vagrant plugin install vagrant-libvirt vagrant-docker-compose
  )
  vagrant plugin install vagrant-vbguest
}

function install_web_tools() {
  gem install --user-install rails sass
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

  pip2 install --user vim-vint

  pip2 install --user --upgrade neovim
  pip3 install --user --upgrade neovim

  gem install --user-install neovim

  npm install --global --prefix=~/.npm remark-cli

  go get -u mvdan.cc/sh/cmd/shfmt
}

function install_user_tools() {
  brew cask install \
    alfred \
    caffeine \
    cyberduck \
    discord \
    firefox \
    flux \
    google-chrome \
    iterm2 \
    karabiner-elements \
    plex-media-player \
    shiftit \
    signal \
    slack \
    spotify \
    steam \
    tunnelblick \
    vlc
}

function _install_vim_lua_prefix() {
  local cellar version
  cellar="$(brew --cellar lua)"
  version="$(
    brew list --versions lua | \
    awk '{print $2}' | \
    sort --reverse | \
    head -n 1
  )"
  readonly cellar version

  echo "$cellar/$version"
}

function _install_vim_python2_config_dir() {
  local cellar version identifier
  cellar="$(brew --cellar python2)"
  version="$(
    brew list --versions python2 | \
    tr "[[:space:]]" "\n" | \
    grep -E "^2\." | \
    sort --reverse | \
    head -n 1
  )"
  identifier="$(echo "$version" | sed -E 's#(^[^\.]+\.[^\.]+)\..*#\1#')"
  readonly cellar version identifier

  echo "$cellar/$version/Frameworks/Python.framework/Versions/$identifier/lib/python$identifier/config"
}

function _install_vim_python3_config_dir() {
  local cellar version identifier
  cellar="$(brew --cellar python3)"
  version="$(
    brew list --versions python3 | \
    tr "[[:space:]]" "\n" | \
    grep -E "^3\." | \
    sort --reverse | \
    head -n 1
  )"
  identifier="$(echo "$version" | sed -E 's#(^[^\.]+\.[^\.]+)\..*#\1#')"
  readonly cellar version identifier

  find \
    "$cellar/$version/Frameworks/Python.framework/Versions/$identifier/lib/python$identifier" \
    -maxdepth 1 \
    -type d \
    -name "config-$identifier*"
}

function install_vim() {
  if [ ! -d ~/dependencies/vim ]; then
    git clone \
      --branch=master \
      --single-branch \
      --depth=1 \
      git@github.com:vim/vim.git \
      ~/dependencies/vim
  fi

  mkdir -p ~/dependencies/vim_install

  (
    builtin cd ~/dependencies/vim
    ./configure \
      --disable-darwin \
      --enable-autoservername \
      --enable-cscope \
      --enable-fail-if-missing \
      --enable-luainterp=yes \
      --enable-multibyte \
      --enable-mzschemeinterp \
      --enable-perlinterp=yes \
      --enable-python3interp=yes \
      --enable-pythoninterp=yes \
      --enable-rubyinterp=yes \
      --enable-tclinterp=yes \
      --enable-terminal \
      --exec-prefix="$HOME/dependencies/vim_install" \
      --prefix="$HOME/dependencies/vim_install" \
      --with-compiledby="$(id -un)" \
      --with-features=huge \
      --with-lua-prefix="$(_install_vim_lua_prefix)" \
      --with-python-command=python \
      --with-python-config-dir="$(_install_vim_python2_config_dir)" \
      --with-python3-command=python3 \
      --with-python3-config-dir="$(_install_vim_python3_config_dir)" \
      --with-ruby-command=ruby \
      --with-x
    make
    make test
    make install
  )
}

main
