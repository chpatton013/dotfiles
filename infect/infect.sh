#!/usr/bin/env bash
set -xeuo pipefail

script_dir="$( (builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) )"
root_dir="$( (builtin cd "$script_dir" && git rev-parse --show-toplevel) )"

source "$script_dir/utilities.sh"

################################################################################
# Configure account
################################################################################

change_shell "$(which zsh)" "$(user_name)"
make_directory "$HOME/projects" "$HOME/.config" "$HOME/.tmux"

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

( # Airline patched fonts
  builtin cd vim/fonts
  ./install.sh
)

# Vundle plugins
vim +PluginInstall +qall

( # YouCompleteMe
  builtin cd "$root_dir/vim/bundle/YouCompleteMe"
  git submodule deinit --force .
  git submodule update --init --recursive
  ./install.py --clang-completer --racer-completer --tern-completer
)
