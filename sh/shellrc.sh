###############################################################################
# Login Actions.
###############################################################################

# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

###############################################################################
# External Files.
###############################################################################

[ -f ~/.cargo/env ] && . ~/.cargo/env

export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWSTASHSTATE=" true"
export GIT_PS1_SHOWUNTRACKEDFILES=" true"
export GIT_PS1_SHOWUPSTREAM="true"

if [ -d ~/.dircolors ]; then
  dircolors ~/.dircolors
fi

export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_SDK_HOME=/usr/local/opt/android-sdk

###############################################################################
# History Settings.
###############################################################################

export HISTFILE=~/.history
export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE=2000

###############################################################################
# Path Construction.
###############################################################################

paths=(
  /usr/local
  /usr
  /usr/local/mysql
  /usr/X11
  /usr/local/cuda
  /usr/local/cuda-5.0
  /usr/kerberos
  /
  "$HOME"
  "$HOME/go"
)
for p in ${paths[@]}; do
  bin="${p%/}/bin"
  sbin="${p%/}/sbin"
  [ -d "$bin" ] && PATH+=:"$bin"
  [ -d "$sbin" ] && PATH+=:"$sbin"
done
PATH="$HOME/.rbenv/shims:$PATH"
export PATH="$PATH"

###############################################################################
# LD Library Path Construction.
###############################################################################

library_paths=(
  /
  /usr
  /usr/local
  /usr/local/cuda
  /usr/local/cuda-5.0
)
for l in ${library_paths[@]}; do
  lib="$l/lib"
  lib64="$l/lib64"
  [ -d "$lib" ] && LD_LIBRARY_PATH+=:"$lib"
  [ -d "$lib64" ] && LD_LIBRARY_PATH+=:"$lib64"
done
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

###############################################################################
# Language
###############################################################################

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="C"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL=""
export CHARSET="UTF-8"

###############################################################################
# Extra config files
###############################################################################

function source_files_in_directory() {
  local directory ifs_restore
  directory="$1"
  ifs_restore="$IFS"
  readonly directory ifs_restore

  if [ -d "$directory" ]; then
    IFS=$'\n'
    for f in $(find -L "$directory" -type f); do
      source "$f"
    done
    IFS="$ifs_restore"
  fi
}

source_files_in_directory ~/.config/shellrc.d
source_files_in_directory ~/.bootstrap

# Setup ssh agent automatically. This will require a key decryption prompt in
# the first shell opened each boot.
eval $(ssh-agent-canonicalize)
