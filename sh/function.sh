function random_string() {
   local length="$1"
   base64 /dev/urandom | tr -d '/+' | fold -w "$length" | head -n 1
}

# `ls` displays trailing identifiers ('/' or '*'), color, and non-printables.
function ls() {
   /bin/ls -Fb $@
}

function cd() {
   builtin cd $@
   ls
}

function tmux_start_session() {
   local name="$1"
   if [ -z "$name" ]; then
      tmux
   else
      if tmux has-session -t "$name"; then
         tmux attach -t "$name"
      else
         tmux new -s "$name"
      fi
   fi
}

function ifind() {
   local pattern="$@"
   find . -iname "*$pattern*"
}
