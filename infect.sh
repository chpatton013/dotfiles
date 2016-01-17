#!/usr/bin/env bash

set -euo pipefail

function link() {
   local source_file="$1"
   local link_file="$2"

   rm --recursive --force "$link_file"
   ln --symbolic --force "$source_file" "$link_file"
}

home="$HOME"

################################################################################
# Update repository
################################################################################

git submodule update --init --recursive

################################################################################
# Configure account
################################################################################

sudo chsh --shell "$(which zsh)" "$(id --user --name)"

################################################################################
# Create required directories
################################################################################

mkdir --parents $home/projects $home/.config

################################################################################
# Link config files in home folder
################################################################################

# Shell
link $home/dotfiles/sh/alias.sh $home/.alias
link $home/dotfiles/sh/function.sh $home/.function
link $home/dotfiles/sh/variables.sh $home/.variables
link $home/dotfiles/sh/commonrc.sh $home/.commonrc
link $home/dotfiles/sh/bashrc.bash $home/.bashrc
link $home/dotfiles/sh/zshrc.zsh $home/.zshrc
link $home/dotfiles/dircolors/solarized/dircolors.256dark $home/.dircolors
link $home/dotfiles/config/tmux.conf $home/.tmux.conf

# Git
link $home/dotfiles/sh/git-completion.sh $home/.git-completion.sh
link $home/dotfiles/git/gitconfig $home/.gitconfig
link $home/dotfiles/git/gitignore $home/.gitignore

# Vim
link $home/dotfiles/vim $home/.vim
link $home/dotfiles/vim/vimrc $home/.vimrc
link $home/dotfiles/nvim $home/.nvim
link $home/dotfiles/nvim/nvimrc $home/.nvimrc
link $home/dotfiles/nvim/ycm_extra_conf.py $home/.ycm_extra_conf.py

# X
link $home/dotfiles/sh/background.sh $home/.background
link $home/Pictures/Wallpapers $home/.wallpaper
link $home/dotfiles/sh/xinitrc.sh $home/.xinitrc
link $home/dotfiles/config/X/xscreensaver $home/.xscreensaver
link $home/dotfiles/sh/xsession.sh $home/.xsession
link $home/dotfiles/config/i3 $home/.i3
link $home/dotfiles/config/X $home/.config/X

# Other
link $home/dotfiles/themes $home/.themes
link $home/dotfiles/ctags $home/.ctags
link $home/dotfiles/clang-format.conf $home/.clang-format

################################################################################
# Build dependencies
################################################################################

( # YouCompleteMe
   builtin cd ./nvim/bundle/YouCompleteMe
   ./install.sh --clang-completer --omnisharp-completer
)
