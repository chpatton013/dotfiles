###############################################################################
# Pathlist construction
###############################################################################

# Utility functions
###############################################################################

function trim_pathlist() {
  sed -e 's/^:*//;s/:*$//'
}

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
      if [ "$part" != "$prepend" ]; then
        canonical_pathlist+="$delimiter$part"
      fi
    done

    echo -n "$canonical_pathlist" | trim_pathlist
  )
}

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
      canonical_pathlist+="$part$delimiter"
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
# Variables
###############################################################################

# Language
###############################################################################

export CHARSET="UTF-8"
export LANG="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_ALL=""
export LC_COLLATE="C" # Sort uppercase before lowercase
export LC_CTYPE="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"

# History Settings
###############################################################################

export HISTFILE=~/.history
export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE=2000

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
