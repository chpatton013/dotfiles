###############################################################################
# Pathlist construction
###############################################################################

# Utility functions
###############################################################################

# Remove leading, trailing, and repeated `:`s.
function trim_pathlist() {
  sed -e 's/^:*//;s/:*$//;s/:+/:/'
}

# Prepent a path to a pathlist. Remove any later occurences of path in pathlist.
function prepend_pathlist() {
  local pathlist prepend delimiter
  pathlist="$1"
  prepend="$2"
  delimiter=":"
  readonly pathlist prepend delimiter

  (
    IFS=$'\n'
    local pathlist_parts=($(echo "$pathlist" | tr "$delimiter" "\n"))
    local canonical_pathlist="$prepend"
    for part in ${pathlist_parts[@]}; do
      if [ -n "$part" ] && [ "$part" != "$prepend" ]; then
        canonical_pathlist+="$delimiter$part"
      fi
    done

    echo -n "$canonical_pathlist" | trim_pathlist
  )
}

# Append a path to a pathlist, unless the path appears sooner in the pathlist.
function append_pathlist() {
  local pathlist append delimiter
  pathlist="$1"
  append="$2"
  delimiter=":"
  readonly pathlist append delimiter

  (
    IFS=$'\n'
    local pathlist_parts=($(echo "$pathlist" | tr "$delimiter" "\n"))
    local canonical_pathlist=""
    local part_found=""
    for part in ${pathlist_parts[@]}; do
      if [ -n "$part" ]; then
        canonical_pathlist+="$part$delimiter"
      fi
      if [ "$part" = "$append" ]; then
        part_found="true"
      fi
    done

    if [ -z "$part_found" ]; then
      canonical_pathlist+="$append"
    fi

    echo -n "$canonical_pathlist" | trim_pathlist
  )
}

# PATH
###############################################################################

paths=(
  /usr/local
  /usr
  /usr/X11
  /usr/kerberos
  /
  ~
  ~/go
)
for p in "${paths[@]}"; do
  bin="${p%/}/bin"
  sbin="${p%/}/sbin"
  [ -d "$bin" ] && PATH="$(append_pathlist "$PATH" "$bin")"
  [ -d "$sbin" ] && PATH="$(append_pathlist "$PATH" "$sbin")"
done
PATH="$(prepend_pathlist "$PATH" ~/.rbenv/shims)"
export PATH="$PATH"

# LD_LIBRARY_PATH
###############################################################################

library_paths=(
  /usr/local
  /usr
  /
  ~
)
for l in "${library_paths[@]}"; do
  lib="${l%/}/lib"
  lib64="${l%/}/lib64"
  [ -d "$lib" ] &&
    LD_LIBRARY_PATH="$(append_pathlist "$LD_LIBRARY_PATH" "$lib")"
  [ -d "$lib64" ] &&
    LD_LIBRARY_PATH="$(append_pathlist "$LD_LIBRARY_PATH" "$lib64")"
done
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

###############################################################################
# Extra config files
###############################################################################

[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -d ~/.dircolors ] && dircolors ~/.config/solarized-dircolors

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
source_files_in_directory ~/.bootstrap

###############################################################################
# Miscellaneous
###############################################################################

# Setup ssh agent automatically. This will require a key decryption prompt in
# the first shell opened each boot.
eval $(ssh-agent-canonicalize)
