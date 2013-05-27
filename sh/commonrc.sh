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
if [ -d ~/Code ]; then
   cd ~/Code
fi

###############################################################################


###############################################################################
# External Files.
###############################################################################

if [ -f ~/.alias ]; then
   . ~/.alias
fi

if [ -f ~/.variables ]; then
   . ~/.variables
fi

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

if [ $DISPLAY ]; then
   if [ -f ~/.config/X/Xresources.xrdb ]; then
      xrdb -merge ~/.config/X/Xresources.xrdb
   fi
   if [ -f ~/.themes/solarized/xresources ]; then
      xrdb -merge ~/.themes/solarized/xresources
   fi

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

HISTFILE=~/.history
SAVEHIST=1000
HISTSIZE=1000
HISTFILESIZE=2000

###############################################################################


###############################################################################
# Path Construction.
###############################################################################

OLD_PATH=$PATH
PATH=.
# personal bin directories
if [ -d ~/bin ]; then PATH+=:~/bin
fi
if [ -d ~/sbin ]; then PATH+=:~/sbin
fi
# homebrew bin directories
if [ -d /usr/local/bin ]; then PATH+=:/usr/local/bin
fi
if [ -d /usr/local/sbin ]; then PATH+=:/usr/local/sbin
fi
# usr bin directories
if [ -d /usr/bin ]; then PATH+=:/usr/bin
fi
if [ -d /usr/sbin ]; then PATH+=:/usr/sbin
fi
# mysql bin directories
if [ -d /usr/local/mysql/bin ]; then PATH+=:/usr/local/mysql/bin
fi
if [ -d /usr/local/mysql/sbin ]; then PATH+=:/usr/local/mysql/sbin
fi
# X11 bin directory
if [ -d /usr/X11/bin ]; then PATH+=:/usr/X11/bin
fi
# CUDA bin directories
if [ -d /usr/local/cuda/bin ]; then PATH+=:/usr/local/cuda/bin
fi
if [ -d /usr/local/cuda-5.0/bin ]; then PATH+=:/usr/local/cuda-5.0/bin
fi
# kerberos bin directories
if [ -d /usr/kerberos/bin ]; then PATH+=:/usr/kerberos/bin
fi
if [ -d /usr/kerberos/sbin ]; then PATH+=:/usr/kerberos/sbin
fi
# system bin directories
if [ -d /bin ]; then PATH+=:/bin
fi
if [ -d /sbin ]; then PATH+=:/sbin
fi
PATH=$OLD_PATH:$PATH
export PATH=$PATH

###############################################################################


###############################################################################
# LD Library Path Construction.
###############################################################################

LD_LIBRARY_PATH=.
if [ -d /lib ]; then LD_LIBRARY_PATH+=:/lib
fi
if [ -d /usr/lib ]; then LD_LIBRARY_PATH+=:/usr/lib
fi
if [ -d /usr/local/lib ]; then LD_LIBRARY_PATH+=:/usr/local/lib
fi
if [ -d /usr/local/cuda/lib ]; then LD_LIBRARY_PATH+=:/usr/local/cuda/lib
fi
if [ -d /usr/local/cuda/lib64 ]; then LD_LIBRARY_PATH+=:/usr/local/cuda/lib64
fi
if [ -d /usr/local/cuda-5.0/lib ]; then LD_LIBRARY_PATH+=:/usr/local/cuda-5.0/lib
fi
if [ -d /usr/local/cuda-5.0/lib64 ]; then LD_LIBRARY_PATH+=:/usr/local/cuda-5.0/lib64
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH

###############################################################################


###############################################################################
# Prompt Definition
###############################################################################

# Defined externally:
# PS1_lbrace, PS1_rbrace, PS1_at, PS1_vbar, PS1_queue, PS1_name, PS1_host,
# PS1_pwd, PS1_date, PS1_time, PS1_priv

export PS1="$PS1_lbrace $PS1_name $PS1_at $PS1_host $PS1_vbar $PS1_date $PS1_at $PS1_time $PS1_rbrace
$PS1_lbrace $PS1_pwd $PS1_rbrace
$PS1_lbrace $PS1_priv $PS1_queue "

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

