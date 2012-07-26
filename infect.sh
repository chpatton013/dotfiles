#!/bin/sh

# Update repository
git stash
git pull --rebase
git submodule update
git stash pop

# Link config files in home folder
ln -sf ~/dotfiles/sh/.alias ~/.alias
ln -sf ~/dotfiles/sh/.git-completion.sh ~/.git-completion.sh
ln -sf ~/dotfiles/sh/.mybashrc ~/.mybashrc
ln -sf ~/dotfiles/sh/.no_mux_hosts ~/.no_mux_hosts
ln -sf ~/dotfiles/sh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/dotfiles/vim/.vim ~/.vim

# Link plugins for vim
ln -sf ~/dotfiles/vim/vim-pathogen/autoload/pathogen.vim ~/dotfiles/vim/.vim/autoload
ln -sf ~/dotfiles/vim/vim-fugitive ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/themes/solarized/vim-colors-solarized ~/dotfiles/vim/.vim/bundle
