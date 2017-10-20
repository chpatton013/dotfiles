#!/usr/bin/env bash
set -xeuo pipefail

script_dir="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root_dir="$(builtin cd "$script_dir" && git rev-parse --show-toplevel)"

################################################################################
# Configure account
################################################################################

sudo chsh -s "$(which zsh)" "$(id -un)"
mkdir -p ~/bin ~/projects ~/.bootstrap.d

################################################################################
# Link config files in home folder
################################################################################

(builtin cd stow && find -mindepth 1 -maxdepth 1) |
  xargs -I {} rm -rf "$HOME/{}"
stow --verbose=1 --dir="$root_dir" --target="$HOME" --restow stow

################################################################################
# Download dependencies
################################################################################

# Executables
################################################################################

mkdir -p ~/bin

# ssh-agent-canonicalize
wget --output-document ~/bin/ssh-agent-canonicalize \
  https://raw.githubusercontent.com/chpatton013/ssh-agent-canonicalize/master/ssh-agent-canonicalize
chmod +x ~/bin/ssh-agent-canonicalize

# Libraries
################################################################################

mkdir -p ~/.config/{bashrc.d,zshrc.d}

# worktree
wget --output-document ~/.config/shellrc.d/worktree.sh \
  https://raw.githubusercontent.com/chpatton013/worktree/master/worktree.sh

# Git PS1 prompt
wget --output-document ~/.config/shellrc.d/git-prompt.sh \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Git shell completion
wget --output-document ~/.config/bashrc.d/git-completion.bash \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

# Solarized color themes
if [ ! -d ~/.config/solarized ]; then
  git clone git@github.com:altercation/solarized.git ~/.config/solarized
fi
(
  builtin cd ~/.config/solarized
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

# Solarized dircolors
if [ ! -d ~/.config/solarized-dircolors ]; then
  git clone git@github.com:seebi/dircolors-solarized.git \
    ~/.config/solarized-dircolors
fi
(
  builtin cd ~/.config/solarized-dircolors
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

# Powerline for Tmux
if [ ! -d ~/.config/tmux-powerline ]; then
  git clone git@github.com:erikw/tmux-powerline.git ~/.config/tmux-powerline
fi
(
  builtin cd ~/.config/tmux-powerline
  git fetch
  git clean --force -d
  git reset --hard origin/master
)
ln -sf "$root_dir/tmux/theme.sh" ~/.config/tmux-powerline/themes/custom.sh

# Tmux plugins
################################################################################

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone git@github.com:tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi
(
  builtin cd ~/.tmux/plugins/tpm
  git fetch
  git clean --force -d
  git reset --hard origin/master
)

~/.tmux/plugins/tpm/bin/clean_plugins
~/.tmux/plugins/tpm/bin/install_plugins
~/.tmux/plugins/tpm/bin/update_plugins all

ln -s "$root_dir/tmux/plugins/tmux-mem-cpu-load/tmux-mem-cpu-load" ~/bin

# Vim plugins
################################################################################

mkdir -p ./vim/autoload

# VimPlug download
wget --output-document ./vim/autoload/plug.vim \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim plugins
vim +PlugInstall +qall
