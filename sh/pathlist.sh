# Utility functions
###############################################################################

# Prepent a path to a pathlist. Remove any later occurences of path in pathlist.
function prepend_pathlist() {
  local pathlist prepend delimiter
  pathlist="$1"
  prepend="$2"
  delimiter=":"
  readonly pathlist prepend delimiter

  python -c "$(cat <<EOF
import sys

pathlist = sys.argv[1]
delimiter = sys.argv[2]
prepend = sys.argv[3:]

unique = set()
unique_pathlist = []
for el in prepend + pathlist.split(delimiter):
  if el and el not in unique:
    unique.add(el)
    unique_pathlist.append(el)
sys.stdout.write(delimiter.join(unique_pathlist))
EOF
)" "$pathlist" "$delimiter" "$prepend"
}

# Append a path to a pathlist, unless the path appears sooner in the pathlist.
function append_pathlist() {
  local pathlist append delimiter
  pathlist="$1"
  append="$2"
  delimiter=":"
  readonly pathlist append delimiter

  python -c "$(cat <<EOF
import sys

pathlist = sys.argv[1]
delimiter = sys.argv[2]
append = sys.argv[3:]

unique = set()
unique_pathlist = []
for el in pathlist.split(delimiter) + append:
  if el and el not in unique:
    unique.add(el)
    unique_pathlist.append(el)
sys.stdout.write(delimiter.join(unique_pathlist))
EOF
)" "$pathlist" "$delimiter" "$append"
}

# PATH
###############################################################################

paths=(
  /usr/local
  /usr/local/opt/go
  /usr
  /usr/X11
  /usr/kerberos
  /
  ~
  ~/.cargo
  ~/.npm
  ~/go
)
for p in "${paths[@]}"; do
  bin="${p%/}/bin"
  sbin="${p%/}/sbin"
  [ -d "$bin" ] && PATH="$(append_pathlist "$PATH" "$bin")"
  [ -d "$sbin" ] && PATH="$(append_pathlist "$PATH" "$sbin")"
done

if [ -d ~/.gem/ruby ]; then
  for bin in $(find ~/.gem/ruby -maxdepth 2 -type d -name bin); do
    [ -d "$bin" ] && PATH="$(prepend_pathlist "$PATH" "$bin")"
  done
fi
[ -d ~/.rbenv/bin ] && PATH="$(prepend_pathlist "$PATH" ~/.rbenv/bin)"
[ -d ~/.rbenv/shims ] && PATH="$(prepend_pathlist "$PATH" ~/.rbenv/shims)"
[ -d ~/.bootstrap.bin ] && PATH="$(prepend_pathlist "$PATH" ~/.bootstrap.bin)"

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
