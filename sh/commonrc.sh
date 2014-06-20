#!/usr/bin/env sh

###############################################################################
# Login Actions.
###############################################################################

# If not running interactively, don't do anything.
case $- in
   *i*) ;;
   *) return;;
esac

# Move to development directory.
[ -d ~/Code ] && cd ~/Code

###############################################################################


###############################################################################
# External Files.
###############################################################################

[ -f ~/.alias ] && . ~/.alias
[ -f ~/.function ] && . ~/.function
[ -f ~/.variables ] && . ~/.variables

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

if [ "$DISPLAY" ]; then
   if [ `echo $DESKTOP_SESSION | grep "gnome"` ] &&
    [ -d ~/.themes/solarized/gnome-terminal-colors-solarized ]; then
      ~/.themes/solarized/gnome-terminal-colors-solarized/set_dark.sh
   elif [ `echo $DESKTOP_SESSION | grep -E "konsole|kde"` ] &&
    [ -d ~/.themes/solarized/konsole-colors-solarized ]; then
      ~/.themes/solarized/konsole-colors-solarized/set_dark.sh
   fi
fi

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

# personal bin directories
OLD_PATH=$PATH
PATH='.'
[ -d ~/bin ] && PATH+=:~/bin
[ -d ~/sbin ] && PATH+=:~/sbin
# homebrew bin directories
[ -d /usr/local/bin ] && PATH+=:/usr/local/bin
[ -d /usr/local/sbin ] && PATH+=:/usr/local/sbin
# usr bin directories
[ -d /usr/bin ] && PATH+=:/usr/bin
[ -d /usr/sbin ] && PATH+=:/usr/sbin
# mysql bin directories
[ -d /usr/local/mysql/bin ] && PATH+=:/usr/local/mysql/bin
[ -d /usr/local/mysql/sbin ] && PATH+=:/usr/local/mysql/sbin
# X11 bin directory
[ -d /usr/X11/bin ] && PATH+=:/usr/X11/bin
# CUDA bin directories
[ -d /usr/local/cuda/bin ] && PATH+=:/usr/local/cuda/bin
[ -d /usr/local/cuda-5.0/bin ] && PATH+=:/usr/local/cuda-5.0/bin
# kerberos bin directories
[ -d /usr/kerberos/bin ] && PATH+=:/usr/kerberos/bin
[ -d /usr/kerberos/sbin ] && PATH+=:/usr/kerberos/sbin
# system bin directories
[ -d /bin ] && PATH+=:/bin
[ -d /sbin ] && PATH+=:/sbin
export PATH="$PATH:$OLD_PATH"

###############################################################################


###############################################################################
# LD Library Path Construction.
###############################################################################

LD_LIBRARY_PATH=./lib
[ -d /lib ] && LD_LIBRARY_PATH+=:/lib
[ -d /usr/lib ] && LD_LIBRARY_PATH+=:/usr/lib
[ -d /usr/local/lib ] && LD_LIBRARY_PATH+=:/usr/local/lib
[ -d /usr/local/cuda/lib ] && LD_LIBRARY_PATH+=:/usr/local/cuda/lib
[ -d /usr/local/cuda/lib64 ] && LD_LIBRARY_PATH+=:/usr/local/cuda/lib64
[ -d /usr/local/cuda-5.0/lib ] && LD_LIBRARY_PATH+=:/usr/local/cuda-5.0/lib
[ -d /usr/local/cuda-5.0/lib64 ] && LD_LIBRARY_PATH+=:/usr/local/cuda-5.0/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

###############################################################################


###############################################################################
# Classpath Construction.
###############################################################################

export CLASSPATH="$CLASSPATH:/usr/local/lib/antlr-3.5.2-complete.jar"

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
PS1_rangle="${fg_white}>${reset_color}"
PS1_name="${fg_blue}${SH_name}${reset_color}"
PS1_host="${fg_magenta}${SH_host}${reset_color}"
PS1_time="${fg_magenta}${SH_time}${reset_color}"
PS1_date="${fg_blue}${SH_date}${reset_color}"
PS1_pwd="${fg_magenta}${SH_pwd}${reset_color}"
PS1_priv="${fg_white}${SH_priv}${reset_color}"

export PS1="$PS1_lbrace $PS1_name $PS1_at $PS1_host $PS1_vbar $PS1_date $PS1_at $PS1_time $PS1_rbrace
$PS1_lbrace $PS1_pwd $PS1_priv "

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
export LC_ALL=
export CHARSET=UTF-8

###############################################################################
