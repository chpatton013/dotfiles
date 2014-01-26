#!/bin/sh

# Update repository.
git stash &&
git pull --rebase &&
git submodule update --init &&
git stash pop

# Remove config file links in home folder.
rm -f ~/.alias
rm -f ~/.background
rm -f ~/.bashrc
rm -f ~/.commonrc
rm -rf ~/.dircolors
rm -f ~/.function
rm -f ~/.git-completion.sh
rm -f ~/.gitconfig
rm -f ~/.gitignore
rm -rf ~/.themes
rm -f ~/.tmux.conf
rm -f ~/.variables
rm -rf ~/.vim
rm -rf ~/.wallpaper
rm -f ~/.vimrc
rm -f ~/.xinitrc
rm -rf ~/.xscreensaver
rm -f ~/.xsession
rm -f ~/.zshrc
rm -rf ~/.i3
rm -rf ~/.config/X

# Make sure required directories exist.
mkdir -p ~/Code
mkdir -p ~/include
mkdir -p ~/.config

# Link config files in home folder.
ln -sf ~/dotfiles/sh/alias.sh ~/.alias
ln -sf ~/dotfiles/sh/background.sh ~/.background
ln -sf ~/dotfiles/sh/bashrc.bash ~/.bashrc
ln -sf ~/dotfiles/sh/commonrc.sh ~/.commonrc
ln -sf ~/dotfiles/dircolors/solarized/dircolors.256dark ~/.dircolors
ln -sf ~/dotfiles/sh/function.sh ~/.function
ln -sf ~/dotfiles/sh/git-completion.sh ~/.git-completion.sh
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/gitignore ~/.gitignore
ln -sf ~/dotfiles/themes ~/.themes
ln -sf ~/dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/sh/variables.sh ~/.variables
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/sh/xinitrc.sh ~/.xinitrc
ln -sf ~/dotfiles/config/X/xscreensaver ~/.xscreensaver
ln -sf ~/dotfiles/sh/xsession.sh ~/.xsession
ln -sf ~/dotfiles/sh/zshrc.zsh ~/.zshrc
ln -sf ~/dotfiles/config/i3 ~/.i3
ln -sf ~/dotfiles/config/X ~/.config/X
ln -sf ~/Pictures/Wallpapers ~/.wallpaper
