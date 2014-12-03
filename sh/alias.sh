#!/usr/bin/env sh

# Expand control characters.
alias less='less -R'
# Enabled X Forwarding and compression in X sessions.
alias ssh='ssh -XYC'
# Log X sessions.
alias startx='startx &> ~/.xlog'
# Pass enviornment variables onto sudo.
alias sudo='sudo -E'

# Add color to several commands.
if [ $(uname -s) != 'Darwin' ]; then
   alias ls='ls --color'
   alias grep='grep --color'
   alias fgrep='fgrep --color'
   alias egrep='egrep --color'
fi

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
alias l='ls -Fb'
alias ll='l -hl'
alias la='l -a'
alias lal='ll -a'
alias lla='lal'

# Command-line shortcuts.
alias ...='cd ..'
alias g='git'
alias m='make -j 4'
alias tm='tmux_start_session'
alias tl='tmux list-sessions'
alias :q='exit'
alias v='nvim'
alias :e='v'
alias vo="v -o"
alias vO="v -O"

# Work ssh addresses.
alias cmr='ssh cpatton@cominor.com'
alias lb='live_ssh ifixit.com'
alias db='live_ssh db.ifixit.com'
alias slave='live_ssh slave.ifixit.com'

# Work command aliases.
alias f='feature'
alias h='hotfix'
alias whitelist='sudo /sbin/service httpd reload && sudo service varnish reload'
