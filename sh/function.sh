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

function git_sync_push() {
   local=$(git rev-parse --show-toplevel 2&> /dev/null)

   if [ -z ${local} ]; then
      echo "'`pwd`' not a valid git repository"
      return 1
   fi

   remoteFile="${local}/.remote"
   if [ ! -f $remoteFile ]; then
      echo "'$remoteFile' does not exist"
      return 2
   fi

   remote=$(cat $remoteFile)

   rsync -rlpt --executability --delete --delete-after "$local/{,.}*" "$remote"
}

function git_sync_pull() {
   local=$(git rev-parse --show-toplevel 2&> /dev/null)

   if [ -z ${local} ]; then
      echo "'`pwd`' not a valid git repository"
      return 1
   fi

   remoteFile="${local}/.remote"
   if [ ! -f $remoteFile ]; then
      echo "'$remoteFile' does not exist"
      return 2
   fi

   remote=$(cat $remoteFile)

   rsync -rlpt --executability --delete --delete-after "$remote/{,.}*" "$local"
}
