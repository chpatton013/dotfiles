#!/bin/sh

# Update repository.
git stash &&
git pull --rebase &&
git submodule init &&
git submodule update &&
git stash pop

# Remove config file links in home folder.
rm -f ~/.alias
rm -f ~/.bashrc
rm -f ~/.commonrc
rm -rf ~/.config/terminator
rm -rf ~/.dircolors
rm -f ~/.git-completion.sh
rm -f ~/.gitconfig
rm -f ~/.gitignore
rm -rf ~/.i3
rm -rf ~/.themes
rm -f ~/.tmux.conf
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.xinitrc
rm -f ~/.zshrc

# Make sure required directories exist.
mkdir -p ~/Code
mkdir -p ~/.config

# Link config files in home folder.
ln -sf ~/dotfiles/sh/alias.sh ~/.alias
ln -sf ~/dotfiles/sh/bashrc.bash ~/.bashrc
ln -sf ~/dotfiles/sh/commonrc.sh ~/.commonrc
ln -sf ~/dotfiles/config/terminator ~/.config/terminator
ln -sf ~/dotfiles/dircolors/solarized/dircolors.256dark ~/.dircolors
ln -sf ~/dotfiles/sh/git-completion.sh ~/.git-completion.sh
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
ln -sf ~/dotfiles/git/gitignore ~/.gitignore
ln -sf ~/dotfiles/config/i3 ~/.i3
ln -sf ~/dotfiles/sh/themes ~/.themes
ln -sf ~/dotfiles/config/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/sh/xinitrc.sh ~/.xinitrc
ln -sf ~/dotfiles/sh/zshrc.zsh ~/.zshrc
