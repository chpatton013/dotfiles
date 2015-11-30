#!/bin/bash

set -e

function link() {
   local source_file="$1"
   local link_file="$2"

   rm -rf "$link_file"
   ln -sf "$source_file" "$link_file"
}

################################################################################
# Update repository
################################################################################

git submodule update --init --recursive

################################################################################
# Create required directories
################################################################################

mkdir -p ~/projects ~/.config

################################################################################
# Link config files in home folder
################################################################################

# Shell
link ~/dotfiles/sh/alias.sh ~/.alias
link ~/dotfiles/sh/function.sh ~/.function
link ~/dotfiles/sh/variables.sh ~/.variables
link ~/dotfiles/sh/commonrc.sh ~/.commonrc
link ~/dotfiles/sh/bashrc.bash ~/.bashrc
link ~/dotfiles/sh/zshrc.zsh ~/.zshrc
link ~/dotfiles/dircolors/solarized/dircolors.256dark ~/.dircolors
link ~/dotfiles/config/tmux.conf ~/.tmux.conf

# Git
link ~/dotfiles/sh/git-completion.sh ~/.git-completion.sh
link ~/dotfiles/git/gitconfig ~/.gitconfig
link ~/dotfiles/git/gitignore ~/.gitignore

# Vim
link ~/dotfiles/vim ~/.vim
link ~/dotfiles/vim/vimrc ~/.vimrc
link ~/dotfiles/nvim ~/.nvim
link ~/dotfiles/nvim/nvimrc ~/.nvimrc
link ~/dotfiles/nvim/ycm_extra_conf.py ~/.ycm_extra_conf.py

# X
link ~/dotfiles/sh/background.sh ~/.background
link ~/Pictures/Wallpapers ~/.wallpaper
link ~/dotfiles/sh/xinitrc.sh ~/.xinitrc
link ~/dotfiles/config/X/xscreensaver ~/.xscreensaver
link ~/dotfiles/sh/xsession.sh ~/.xsession
link ~/dotfiles/config/i3 ~/.i3
link ~/dotfiles/config/X ~/.config/X

# Other
link ~/dotfiles/themes ~/.themes
link ~/dotfiles/ctags ~/.ctags

################################################################################
# Build dependencies
################################################################################

( # YouCompleteMe
   cd ./nvim/bundle/YouCompleteMe
   ./install.sh --clang-completer --omnisharp-completer
)
