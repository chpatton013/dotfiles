function tmux_start_session() {
   if [ -z ${1} ]; then
      echo "usage: ${0} <session>" >&2
      return 1
   fi

   if tmux has-session -t ${1}; then
      tmux attach -t ${1}
   else
      tmux new -s ${1}
   fi
}

function ifind() {
   local pattern="$@"
   find . -iname "*$pattern*"
}
