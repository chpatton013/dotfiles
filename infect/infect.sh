#!/usr/bin/env bash

set -xeuo pipefail

script_dir="$( (builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) )"
root_dir="$( (builtin cd "$script_dir" && git rev-parse --show-toplevel) )"

source "$script_dir/utilities.sh"

################################################################################
# Configure account
################################################################################

change_shell "$(which zsh)" "$(user_name)"
make_directory "$HOME/projects" "$HOME/.config" "$HOME/.tmux"

################################################################################
# Update repository
################################################################################

git submodule update --init --recursive
git submodule foreach git pull origin master

################################################################################
# Link config files in home folder
################################################################################

# Shell
link "$root_dir/sh/alias.sh" "$HOME/.alias"
link "$root_dir/sh/function.sh" "$HOME/.function"
link "$root_dir/sh/variables.sh" "$HOME/.variables"
link "$root_dir/sh/commonrc.sh" "$HOME/.commonrc"
link "$root_dir/sh/bashrc.bash" "$HOME/.bashrc"
link "$root_dir/sh/zshrc.zsh" "$HOME/.zshrc"
link "$root_dir/dircolors/solarized/dircolors.256dark" "$HOME/.dircolors"

# Tmux
link "$root_dir/tmux/tmux.conf" "$HOME/.tmux.conf"
link "$root_dir/tmux/plugins" "$HOME/.tmux/plugins"

# Git
link "$root_dir/sh/git-completion.sh" "$HOME/.git-completion.sh"
link "$root_dir/git/gitconfig" "$HOME/.gitconfig"
link "$root_dir/git/gitignore" "$HOME/.gitignore"

# Vim
link "$root_dir/vim" "$HOME/.vim"
link "$root_dir/config/nvim" "$HOME/.config/nvim"
link "$root_dir/vim/vimrc" "$HOME/.vimrc"
link "$root_dir/vim/vimrc" "$HOME/.config/nvim/init.vim"
link "$root_dir/vim/ycm_extra_conf.py" "$HOME/.ycm_extra_conf.py"

# X
link "$root_dir/sh/xinitrc.sh" "$HOME/.xinitrc"
link "$root_dir/config/X/xscreensaver" "$HOME/.xscreensaver"
link "$root_dir/sh/xsession.sh" "$HOME/.xsession"
link "$root_dir/config/i3" "$HOME/.i3"
link "$root_dir/config/X" "$HOME/.config/X"

# Other
link "$root_dir/themes" "$HOME/.themes"
link "$root_dir/ctags" "$HOME/.ctags"
link "$root_dir/clang-format.conf" "$HOME/.clang-format"
link "$root_dir/editorconfig" "$HOME/.editorconfig"

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
