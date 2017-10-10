#!/usr/bin/env bash
set -xeuo pipefail

script_dir="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(builtin cd "$script_dir" && git rev-parse --show-toplevel)"

################################################################################
# Configure account
################################################################################

sudo chsh --shell "$(which zsh)" "$(id --user --name)"
mkdir --parents ~/bin ~/projects ~/.tmux

################################################################################
# Update repository
################################################################################

git submodule deinit --force .
git submodule update --init --recursive

################################################################################
# Link config files in home folder
################################################################################

(builtin cd stow && find -mindepth 1 -maxdepth 1) |
  xargs -I {} rm --recursive --force "$HOME/{}"
stow --verbose=1 --dir="$root_dir" --target="$HOME" --restow stow

################################################################################
# Download dependencies
################################################################################

# Executables
################################################################################

mkdir --parents ~/bin

# ssh-agent-canonicalize
wget --output-document=~/bin/ssh-agent-canonicalize \
  https://raw.githubusercontent.com/chpatton013/ssh-agent-canonicalize/master/ssh-agent-canonicalize
chmod +x ~/bin/ssh-agent-canonicalize

# Libraries
################################################################################

mkdir --parents ~/.config/{bashrc.d,zshrc.d,shellrc.d}

# worktree
wget --output-document=~/.config/shellrc.d/worktree.sh \
  https://raw.githubusercontent.com/chpatton013/worktree/master/worktree.sh

# Git PS1 prompt
wget --output-document=~/.config/shellrc.d/git-prompt.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Git shell completion
wget --output-document=~/.config/shellrc.d/git-completion.bash \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
wget --output-document=~/.config/shellrc.d/git-completion.zsh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

# Vim plugins
################################################################################

mkdir --parents ./vim/autoload

# VimPlug download
wget --output-document=./vim/autoload/plug.vim \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim plugins
vim +PlugInstall +qall
