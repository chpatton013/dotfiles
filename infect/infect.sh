#!/usr/bin/env bash

set -xeuo pipefail

script_dir="$( (builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) )"
root_dir="$( (builtin cd "$script_dir" && git rev-parse --show-toplevel) )"
home="$HOME"

source "$script_dir/utilities.sh"

################################################################################
# Configure account
################################################################################

change_shell "$(which zsh)" "$(user_name)"
make_directory "$home/projects" "$home/.config" "$home/.tmux"

################################################################################
# Update repository
################################################################################

git submodule update --init --recursive
git submodule foreach git pull origin master

################################################################################
# Link config files in home folder
################################################################################

# Shell
link "$root_dir/sh/alias.sh" "$home/.alias"
link "$root_dir/sh/function.sh" "$home/.function"
link "$root_dir/sh/variables.sh" "$home/.variables"
link "$root_dir/sh/commonrc.sh" "$home/.commonrc"
link "$root_dir/sh/bashrc.bash" "$home/.bashrc"
link "$root_dir/sh/zshrc.zsh" "$home/.zshrc"
link "$root_dir/dircolors/solarized/dircolors.256dark" "$home/.dircolors"

# Tmux
link "$root_dir/tmux/tmux.conf" "$home/.tmux.conf"
link "$root_dir/tmux/plugins" "$home/.tmux/plugins"

# Git
link "$root_dir/sh/git-completion.sh" "$home/.git-completion.sh"
link "$root_dir/git/gitconfig" "$home/.gitconfig"
link "$root_dir/git/gitignore" "$home/.gitignore"

# Vim
link "$root_dir/vim" "$home/.vim"
link "$root_dir/config/nvim" "$home/.config/nvim"
link "$root_dir/vim/vimrc" "$home/.vimrc"
link "$root_dir/vim/vimrc" "$home/.config/nvim/init.vim"
link "$root_dir/vim/ycm_extra_conf.py" "$home/.ycm_extra_conf.py"

# X
link "$root_dir/sh/background.sh" "$home/.background"
link "$root_dir/sh/xinitrc.sh" "$home/.xinitrc"
link "$root_dir/config/X/xscreensaver" "$home/.xscreensaver"
link "$root_dir/sh/xsession.sh" "$home/.xsession"
link "$root_dir/config/i3" "$home/.i3"
link "$root_dir/config/X" "$home/.config/X"

# Other
link "$root_dir/themes" "$home/.themes"
link "$root_dir/ctags" "$home/.ctags"
link "$root_dir/clang-format.conf" "$home/.clang-format"

################################################################################
# Build dependencies
################################################################################

( # YouCompleteMe
   builtin cd "$root_dir/vim/bundle/YouCompleteMe"
   ./install.py \
      --clang-completer \
      --racer-completer \
      --tern-completer
)
