# Expand control characters.
alias less="less --RAW-CONTROL-CHARS"
# Enable trusted and untrsuted X Forwarding and compression in X sessions.
alias ssh="ssh -o ForwardX11=yes -o ForwardX11Trusted=yes -o ForwardAgent=true"
# Log X sessions.
alias startx="startx &>~/.xlog"

alias l="ls"
alias ll="ls -hl"
alias la="ls -a"
alias lal="ll -a"
alias lla="lal"

# Command-line shortcuts.
alias ...="builtin cd .."
alias g="git"
alias gg="g gr"
alias m="make --jobs=8"
alias tm="tmux_start_session"
alias tl="tmux list-sessions"
alias v="nvim"
alias vo="v -o"
alias vO="v -O"
alias vp="v -p"
alias :q="exit"
alias :e="v"
alias sac="eval \$(ssh-agent-canonicalize)"
