#!/usr/bin/env bash
set -xeuo pipefail

script_dir="$( (builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) )"
root_dir="$( (builtin cd "$script_dir" && git rev-parse --show-toplevel) )"

################################################################################
# Configure account
################################################################################

sudo chsh --shell "$(which zsh)" "$(id --user --name)"
mkdir --parents "$HOME/projects" "$HOME/.config" "$HOME/.tmux"

################################################################################
# Update repository
################################################################################

git submodule deinit --force .
git submodule update --init --recursive

################################################################################
# Link config files in home folder
################################################################################

(builtin cd stow && find -mindepth 1 -maxdepth 1) | \
    xargs -I {} rm --recursive --force "$HOME/{}"
stow --verbose=1 --dir="$root_dir" --target="$HOME" --restow stow

################################################################################
# Build dependencies
################################################################################

# Worktree download
wget --output-document="$HOME/.worktree" \
     https://raw.githubusercontent.com/chpatton013/worktree/master/worktree.sh

# VimPlug download
mkdir --parents ./vim/autoload
wget --output-document=./vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim plugins
vim +PlugInstall +qall
