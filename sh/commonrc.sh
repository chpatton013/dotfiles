###############################################################################
# Login Actions.
###############################################################################

# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

###############################################################################

###############################################################################
# External Files.
###############################################################################

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.function ] && . ~/.function
[ -f ~/.variables ] && . ~/.variables
[ -f ~/.cargo/env ] && . ~/.cargo/env

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
  export GIT_PS1_SHOWDIRTYSTATE="true"
  export GIT_PS1_SHOWSTASHSTATE=" true"
  export GIT_PS1_SHOWUNTRACKEDFILES=" true"
  export GIT_PS1_SHOWUPSTREAM="true"
fi

if [ -d ~/.dircolors ]; then
  dircolors ~/.dircolors
fi

export ANDROID_HOME=/usr/local/opt/android-sdk
export ANDROID_SDK_HOME=/usr/local/opt/android-sdk

###############################################################################

###############################################################################
# History Settings.
###############################################################################

export HISTFILE=~/.history
export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE=2000

###############################################################################

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

###############################################################################
# Prompt Definition
###############################################################################

# Defined externally:
# fg_black, fg_red, fg_green, fg_yellow, fg_blue, fg_magenta, fg_cyan, fg_white,
# reset_color, SH_name, SH_host, SH_pwd, SH_date, SH_time, SH_priv

PS1_lbrace="${fg_white}[${reset_color}"
PS1_rbrace="${fg_white}]${reset_color}"
PS1_vbar="${fg_white}|${reset_color}"
PS1_at="${fg_white}@${reset_color}"
PS1_langle="${fg_white}<${reset_color}"
PS1_rangle="${fg_white}>${reset_color}"
PS1_name="${fg_blue}${SH_name}${reset_color}"
PS1_host="${fg_green}${SH_host}${reset_color}"
PS1_time="${fg_green}${SH_time}${reset_color}"
PS1_date="${fg_blue}${SH_date}${reset_color}"
PS1_pwd="${fg_blue}${SH_pwd}${reset_color}"
PS1_priv="${fg_green}${SH_priv}${reset_color}"

export PS1="$PS1_name$PS1_at$PS1_host$PS1_vbar$PS1_date$PS1_at$PS1_time$PS1_vbar$PS1_pwd
$PS1_priv$PS1_rangle "

###############################################################################

###############################################################################
# Language
###############################################################################

export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE=C
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
export LC_ALL
export CHARSET=UTF-8

###############################################################################

if [ -f ~/.bootstrap.sh ]; then
  source ~/.bootstrap.sh
fi
if [ -d ~/.bootstrap ]; then
  for b in ~/.bootstrap/*; do
    source "$b"
  done
fi

# Setup ssh agent automatically. This will require a key decryption prompt in
# the first shell opened each boot.
eval $(ssh-agent-canonicalize)
