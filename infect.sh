#!/bin/sh

# Update repository
git stash
git pull --rebase
git submodule init
git submodule update
git stash pop

# Remove config file links in home folder
rm -f ~/.alias
rm -f ~/.git-completion.sh
rm -f ~/.mybashrc
rm -f ~/.no_mux_hosts
rm -f ~/.zshrc
rm -f ~/.vimrc
rm -f ~/.vim

# Remove additional executable links
rm -f ~/bin/premake

# Link config files in home folder
ln -sf ~/dotfiles/sh/.alias ~/.alias
ln -sf ~/dotfiles/sh/.git-completion.sh ~/.git-completion.sh
ln -sf ~/dotfiles/sh/.mybashrc ~/.mybashrc
ln -sf ~/dotfiles/sh/.no_mux_hosts ~/.no_mux_hosts
ln -sf ~/dotfiles/sh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/vim/.vim ~/.vim

# Link additional executable files
mkdir -p ~/bin
ln -sf ~/dotfiles/premake4 ~/bin/premake
