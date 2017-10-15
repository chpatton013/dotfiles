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
  ~/.cargo
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
