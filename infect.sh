#!/usr/bin/env bash

set -euo pipefail

script_dir="$( (builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) )"
home="$HOME"

function link() {
   local source_file="$1"
   local link_file="$2"

   rm --recursive --force "$link_file"
   ln --symbolic --force "$source_file" "$link_file"
}

################################################################################
# Configure account
################################################################################

sudo chsh --shell "$(which zsh)" "$(id --user --name)"

################################################################################
# Update repository
################################################################################

git submodule update --init --recursive

################################################################################
# Create required directories
################################################################################

mkdir --parents "$home/projects" "$home/.config"

################################################################################
# Link config files in home folder
################################################################################

# Shell
link "$script_dir/sh/alias.sh" "$home/.alias"
link "$script_dir/sh/function.sh" "$home/.function"
link "$script_dir/sh/variables.sh" "$home/.variables"
link "$script_dir/sh/commonrc.sh" "$home/.commonrc"
link "$script_dir/sh/bashrc.bash" "$home/.bashrc"
link "$script_dir/sh/zshrc.zsh" "$home/.zshrc"
link "$script_dir/dircolors/solarized/dircolors.256dark" "$home/.dircolors"
link "$script_dir/config/tmux.conf" "$home/.tmux.conf"

# Git
link "$script_dir/sh/git-completion.sh" "$home/.git-completion.sh"
link "$script_dir/git/gitconfig" "$home/.gitconfig"
link "$script_dir/git/gitignore" "$home/.gitignore"

# Vim
link "$script_dir/vim" "$home/.vim"
link "$script_dir/config/nvim" "$home/.config/nvim"
link "$script_dir/vim/vimrc" "$home/.vimrc"
link "$script_dir/vim/vimrc" "$home/.config/nvim/init.vim"
link "$script_dir/vim/ycm_extra_conf.py" "$home/.ycm_extra_conf.py"

# X
link "$script_dir/sh/background.sh" "$home/.background"
link "$script_dir/sh/xinitrc.sh" "$home/.xinitrc"
link "$script_dir/config/X/xscreensaver" "$home/.xscreensaver"
link "$script_dir/sh/xsession.sh" "$home/.xsession"
link "$script_dir/config/i3" "$home/.i3"
link "$script_dir/config/X" "$home/.config/X"

# Other
link "$script_dir/themes" "$home/.themes"
link "$script_dir/ctags" "$home/.ctags"
link "$script_dir/clang-format.conf" "$home/.clang-format"

################################################################################
# Build dependencies
################################################################################

( # YouCompleteMe
   builtin cd "$script_dir/vim/bundle/YouCompleteMe"
   ./install.sh --clang-completer --omnisharp-completer
)
