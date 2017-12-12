# Add color to several commands.
alias ls="ls --color"
alias grep="grep --color"
alias fgrep="fgrep --color"
alias egrep="egrep --color"

function inotifyrun() {
  echo Watching $(pwd): $@

  "$@"
  echo

  while inotifywait --quiet \
    --recursive \
    --event close_write \
    --event create \
    --event delete \
    --event moved_to \
    --event moved_from \
    --event unmount \
    --timefmt "%H:%M:%S" \
    --format "%T: %e: %w%f" \
    --exclude ".*/\.git/.*|(.*\.sw.?$)" \
    .; do
    "$@"
    echo
  done
}
