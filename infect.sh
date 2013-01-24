#!/bin/sh

# Update repository
git stash &&
git pull --rebase &&
git submodule init &&
git submodule update &&
git stash pop

# Remove config file links in home folder
rm -f ~/.alias
rm -f ~/.commonrc
rm -rf ~/.dircolors
rm -f ~/.git-completion.sh
rm -f ~/.mybashrc
rm -rf ~/.themes
rm -f ~/.tmux.conf
rm -rf ~/.vim
rm -f ~/.vimrc
rm -f ~/.xinitrc
rm -f ~/.zshrc

# Remove additional executable links
rm -f ~/bin/premake

# Link config files in home folder
ln -sf ~/dotfiles/sh/alias.sh ~/.alias
ln -sf ~/dotfiles/sh/commonrc.sh ~/.commonrc
ln -sf ~/dotfiles/dircolors/solarized/dircolors.256dark ~/.dircolors
ln -sf ~/dotfiles/sh/git-completion.sh ~/.git-completion.sh
ln -sf ~/dotfiles/sh/mybashrc.bash ~/.mybashrc
ln -sf ~/dotfiles/sh/themes ~/.themes
ln -sf ~/dotfiles/sh/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/vim ~/.vim
ln -sf ~/dotfiles/vim/vimrc ~/.vimrc
ln -sf ~/dotfiles/sh/xinitrc.sh ~/.xinitrc
ln -sf ~/dotfiles/sh/zshrc.zsh ~/.zshrc

# Link additional executable files
mkdir -p ~/bin
ln -sf ~/dotfiles/bin/premake4 ~/bin/premake
