###############################################################################
# Extra config files
###############################################################################

function source_files_in_directory() {
  local directory ifs_restore
  directory="$1"
  ifs_restore="$IFS"
  readonly directory ifs_restore

  if [ -n "$directory" ] && [ -d "$directory" ]; then
    IFS=$'\n'
    for f in $(find -L "$directory" -type f); do
      source "$f"
    done
    IFS="$ifs_restore"
  fi
}

source_files_in_directory ~/.config/shellrc.d
source_files_in_directory ~/.bootstrap.d

[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -d ~/.config/solarized-dircolors ] &&
  eval $(dircolors ~/.config/solarized-dircolors/dircolors.ansi-universal)

###############################################################################
# Miscellaneous
###############################################################################

# Setup ssh agent automatically. This will require a key decryption prompt in
# the first shell opened each boot.
eval $(ssh-agent-canonicalize)
