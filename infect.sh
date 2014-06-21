#!/bin/sh

# Update repository.
git stash
git pull --rebase && git submodule update --init;
git stash pop

# Remove config file links in home folder.
rm -rf ~/.alias ~/.background ~/.bashrc ~/.commonrc ~/.dircolors ~/.function \
 ~/.git-completion.sh ~/.gitconfig ~/.gitignore ~/.themes ~/.tmux.conf \
 ~/.variables ~/.vim ~/.wallpaper ~/.vimrc ~/.xinitrc ~/.xscreensaver \
 ~/.xsession ~/.zshrc ~/.i3 ~/.config/X

# Make sure required directories exist.
mkdir -p ~/projects ~/include ~/.config

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
