#!/usr/bin/env sh

# Make du human readable.
alias du='du -h'
# Expand control characters.
alias less='less -R'
# Enabled X Forwarding and compression in X sessions.
alias ssh='ssh -XYC'
# Log X sessions.
alias startx='startx &> ~/.xlog'
# Pass enviornment variables onto sudo.
alias sudo='sudo -E'

# Add color to several commands.
if [ `uname -s` != 'Darwin' ]; then
   alias ls='ls --color'
   alias grep='grep --color'
   alias fgrep='fgrep --color'
   alias egrep='egrep --color'
fi

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
alias l='ls -FGb'
alias ll='l -hl'
alias la='l -a'
alias lal='ll -a'
alias lla='lal'

# Command-line shortcuts.
alias ...='cd ..'
alias :q='exit'
alias c='clear'
alias g='git'
alias gpl='git_sync_pull'
alias gps='git_sync_push'
alias m='make -j 4'
alias md='mkdir'
alias tm='tmux_start_session'
alias tl='tmux list-sessions'
alias v='vim'
alias vi='vim'

# School ssh addresses.
alias multi='ssh chpatton@multicore.csc.calpoly.edu'
alias unix1='ssh chpatton@unix1.csc.calpoly.edu'
alias unix2='ssh chpatton@unix2.csc.calpoly.edu'
alias unix3='ssh chpatton@unix3.csc.calpoly.edu'
alias unix4='ssh chpatton@unix4.csc.calpoly.edu'

# Work ssh addresses.
alias cmr='ssh cpatton@cominor.com'
alias troll='ssh ifixit@Picture-Frame-Mini.local'
alias lb='live_ssh ifixit.com'
alias db='live_ssh db.ifixit.com'
alias slave='live_ssh slave.ifixit.com'
