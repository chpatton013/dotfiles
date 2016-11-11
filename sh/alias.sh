# Expand control characters.
alias less="less --RAW-CONTROL-CHARS"
# Enable trusted and untrsuted X Forwarding and compression in X sessions.
alias ssh="ssh -XYC"
# Log X sessions.
alias startx="startx &> ~/.xlog"

# Add color to several commands.
if [ "$(uname -s)" = "Darwin" ]; then
   alias gdb="lldb"
else
   alias ls="ls --color"
   alias grep="grep --color"
   alias fgrep="fgrep --color"
   alias egrep="egrep --color"
fi

alias l="ls"
if [ "$(uname -s)" = "Darwin" ]; then
   alias ll="ls -hl"
   alias la="ls -a"
   alias lal="ll -a"
else
   alias ll="ls --human-readable -l"
   alias la="ls --all"
   alias lal="ll --all"
fi
alias lla="lal"

# Command-line shortcuts.
alias ...="builtin cd .."
alias g="git"
alias gg="g gr"
alias m="make --jobs=8"
alias tm="tmux_start_session"
alias tl="tmux list-sessions"
alias v="vim"
alias vo="v -o"
alias vO="v -O"
alias vp="v -p"
alias :q="exit"
alias :e="v"
alias sk="eval \$(sshkey)"
