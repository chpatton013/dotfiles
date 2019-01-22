# Program customization
###############################################################################

export BROWSER='chromium-browser'
export CLICOLOR=TRUE
export EDITOR=vim
export FZF_DEFAULT_COMMAND='(
  git ls-tree -r --name-only HEAD ||
  fd --type f --hidden --exclude .git
)'
export PAGER=less
export PYTHONDONTWRITEBYTECODE=1
export TERM='xterm-256color'
export TERMINAL='xterm'

# Language
###############################################################################

export CHARSET="UTF-8"
export LANG="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_ALL=""
export LC_COLLATE="C" # Sort uppercase before lowercase
export LC_CTYPE="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# History Settings
###############################################################################

export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE=2000
