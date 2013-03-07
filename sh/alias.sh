# Expand control characters.
alias less="less -R"
# Enabled X Forwarding and compression in X sessions.
alias ssh="ssh -XYC"
# Pass enviornment variables onto sudo.
alias sudo="sudo -E"

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
alias l="ls -FGb --color $*"
alias ll="l -hl $*"
alias la="l -a $*"
alias lal="ll -a $*"
alias lla="lal $*"

# Command-line shortcuts.
alias ...="cd .. $*"
alias :q="exit"
alias c="clear"
alias g="grep $*"
alias m="make -j 4 $*"
alias md="mkdir"

# School ssh addresses.
alias multi="ssh chpatton@multicore.csc.calpoly.edu $*"
alias unix1="ssh chpatton@unix1.csc.calpoly.edu $*"
alias unix2="ssh chpatton@unix2.csc.calpoly.edu $*"
alias unix3="ssh chpatton@unix3.csc.calpoly.edu $*"
alias unix4="ssh chpatton@unix4.csc.calpoly.edu $*"

# Work ssh addresses.
alias cmr="ssh cpatton@cominor.com $*"
alias lb="live_ssh ifixit.com $*"
alias db="live_ssh db.ifixit.com $*"
alias slave="live_ssh slave.ifixit.com $*"
