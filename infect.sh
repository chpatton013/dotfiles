#!/usr/bin/env bash
set -xeuo pipefail

script_dir="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(builtin cd "$script_dir" && git rev-parse --show-toplevel)"

################################################################################
# Configure account
################################################################################

# Set shell
################################################################################

sudo chsh -s "$(which zsh)" "$(id -un)"

# Clear paths that will be managed by stow
################################################################################

(builtin cd stow && find -mindepth 1 -maxdepth 1) |
  xargs -I {} rm -rf "$HOME/{}"

# Link config files using stow
################################################################################

function stow_directory() {
  local target package
  target="$1"
  package="$2"
  readonly target package

  stow --verbose=1 --dir="$root_dir" --target="$target" --restow "$package"
}
stow_directory "$HOME" stow
stow_directory "$HOME/bin" bin

# Create directories expected by other applications
################################################################################

mkdir -p \
  ~/bin \
  ~/dependencies \
  ~/projects \
  ~/.bootstrap.d \
  ~/.bootstrap.bin \
  ~/.config/{bashrc.d,shellrc.d,zshrc.d} \
  ~/.local/share/applications

################################################################################
# Download dependencies
################################################################################

# Applications
################################################################################

# ssh-agent-canonicalize
wget --output-document ~/bin/ssh-agent-canonicalize \
  https://raw.githubusercontent.com/chpatton013/ssh-agent-canonicalize/master/ssh-agent-canonicalize
chmod +x ~/bin/ssh-agent-canonicalize

eval $(~/bin/ssh-agent-canonicalize)

# alacritty
if [ ! -d ~/dependencies/alacritty ]; then
  git clone git@github.com:jwilm/alacritty.git ~/dependencies/alacritty
fi
(
  builtin cd ~/dependencies/alacritty
  git fetch
  git clean --force -d
  git reset --hard origin/master

  source ~/.cargo/env
  rustup override set stable
  rustup update stable

  cargo build --release
  cp ./target/release/alacritty ~/bin
  cp Alacritty.desktop ~/.local/share/applications
)
(
  builtin cd "$root_dir/alacritty"
  ./make_config.py --output_file=~/.config/alacritty.yml
)

# fswatch
if [ ! -f ~/dependencies/fswatch-1.12.0.tar.gz ]; then
  wget --output-document ~/dependencies/fswatch-1.12.0.tar.gz \
      https://github.com/emcrisostomo/fswatch/releases/download/1.12.0/fswatch-1.12.0.tar.gz
fi
if [ ! -d ~/dependencies/fswatch-1.12.0 ]; then
  tar xzf ~/dependencies/fswatch-1.12.0.tar.gz --directory ~/dependencies
fi
(
  builtin cd ~/dependencies/fswatch-1.12.0

  ./configure --prefix ~
  make
  make check
  make install
)

# fzf
if [ ! -d ~/dependencies/fzf ]; then
  git clone git@github.com:junegunn/fzf.git ~/dependencies/fzf
fi
(
  builtin cd ~/dependencies/fzf
  git fetch
  git clean --force -d
  git reset --hard origin/master

  ./install --all
)
ln -sf ~/.fzf.bash ~/.config/bashrc.d/fzf.bash
ln -sf ~/.fzf.zsh ~/.config/zshrc.d/fzf.zsh

# worktree
wget --output-document ~/.config/shellrc.d/worktree.sh \
  https://raw.githubusercontent.com/chpatton013/worktree/master/worktree.sh

# Configurations
################################################################################

# GDB Dashboard
wget --output-document ~/.gdbinit git.io/.gdbinit

# Git shell completion
wget --output-document ~/.config/bashrc.d/git-completion.bash \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# Solarized color themes
if [ ! -d ~/.config/solarized ]; then
  git clone git@github.com:altercation/solarized.git ~/.config/solarized
fi
(
  builtin cd ~/.config/solarized
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

# Solarized dircolors
if [ ! -d ~/.config/solarized-dircolors ]; then
  git clone git@github.com:seebi/dircolors-solarized.git \
    ~/.config/solarized-dircolors
fi
(
  builtin cd ~/.config/solarized-dircolors
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

# Powerline for Tmux
if [ ! -d ~/.config/tmux-powerline ]; then
  git clone git@github.com:erikw/tmux-powerline.git ~/.config/tmux-powerline
fi
(
  builtin cd ~/.config/tmux-powerline
  git fetch
  git clean --force -d
  git reset --hard origin/master
)
ln -sf "$root_dir/tmux/theme.sh" ~/.config/tmux-powerline/themes/custom.sh

# Tmux plugins
################################################################################

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi
(
  builtin cd ~/.tmux/plugins/tpm
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

ln -sf "$root_dir/tmux/plugins/tmux-mem-cpu-load/tmux-mem-cpu-load" ~/bin

# Vim plugins
################################################################################

mkdir -p ~/.vim/autoload

# VimPlug download
wget --output-document ~/.vim/autoload/plug.vim \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim plugins
vim +PlugInstall +qall
