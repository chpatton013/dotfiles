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

# Remove plugin links for vim
rm -f ~/dotfiles/vim/.vim/autoload/pathogen.vim
rm -f ~/dotfiles/vim/.vim/bundle/neocomplcache
rm -f ~/dotfiles/vim/.vim/bundle/syntastic
rm -f ~/dotfiles/vim/.vim/bundle/vim-abolish
rm -f ~/dotfiles/vim/.vim/bundle/vim-colors-solarized
rm -f ~/dotfiles/vim/.vim/bundle/vim-commentary
rm -f ~/dotfiles/vim/.vim/bundle/vim-easymotion
rm -f ~/dotfiles/vim/.vim/bundle/vim-fugitive
rm -f ~/dotfiles/vim/.vim/bundle/vim-repeat
rm -f ~/dotfiles/vim/.vim/bundle/vim-surround

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

# Link plugins for vim
ln -sf ~/dotfiles/vim/vim-pathogen/autoload/pathogen.vim ~/dotfiles/vim/.vim/autoload
ln -sf ~/dotfiles/vim/neocomplcache ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/vim/syntastic ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/themes/solarized/vim-abolish ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/themes/solarized/vim-colors-solarized ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/themes/solarized/vim-commentary ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/vim/vim-easymotion ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/vim/vim-fugitive ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/vim/vim-repeat ~/dotfiles/vim/.vim/bundle
ln -sf ~/dotfiles/vim/vim-surround ~/dotfiles/vim/.vim/bundle

# Link additional executable files
mkdir -p ~/bin
ln -sf ~/dotfiles/premake4 ~/bin/premake
