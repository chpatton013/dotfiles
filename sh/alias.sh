#!/usr/bin/env sh

# Expand control characters.
alias less='less -R'
# Enable trusted and untrsuted X Forwarding and compression in X sessions.
alias ssh='ssh -XYC'
# Log X sessions.
alias startx='startx &> ~/.xlog'

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
alias v='vim'
alias vo="v -o"
alias vO="v -O"
alias :q='exit'
alias :e='v'

# Work command aliases.
alias f='feature'
alias whitelist='sudo systemctl reload httpd && sudo systemctl reload varnish'

alias cmr='ssh cpatton@cominor.com'
alias lssh='live_ssh'
alias devdb='lssh db.cominor.com'
alias lb='lssh ifixit.com'
alias db='lssh db.ifixit.com'
alias slave='lssh slave.ifixit.com'
