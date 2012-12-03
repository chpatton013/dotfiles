###############################################################################
# Login Actions.
###############################################################################

# Autoload screen if we aren't in it.
#if [[ $STY = '' ]]; then
#   screen -xR
#fi

cd ~/Code

###############################################################################


###############################################################################
# External Files.
###############################################################################

if [ -f ~/.alias ]; then
   source ~/.alias
fi

if [ -f ~/.git-completion.sh ]; then
   source ~/.git-completion.sh
   export GIT_PS1_SHOWDIRTYSTATE="true"
   export GIT_PS1_SHOWSTASHSTATE=" true"
   export GIT_PS1_SHOWUNTRACKEDFILES=" true"
   export GIT_PS1_SHOWUPSTREAM="true"
fi

if [ -d ~/.dircolors ]; then
   eval `dircolors ~/.dircolors`
fi

if [ `echo $DESKTOP_SESSION | grep "gnome"` ] &&
   [ -d ~/.themes/solarized/gnome-terminal-colors-solarized ]; then
   ~/.themes/solarized/gnome-terminal-colors-solarized/set_dark.sh

elif [ `echo $DESKTOP_SESSION | grep -E "konsole|kde"` ] &&
     [ -d ~/.themes/solarized/konsole-colors-solarized ]; then
   ~/.themes/solarized/konsole-colors-solarized/set_dark.sh
fi

###############################################################################


###############################################################################
# History Settings.
###############################################################################

HISTFILE=~/.history

SAVEHIST=1000
HISTSIZE=1000

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
# usr bin directories
if [ -d /usr/bin ]; then PATH+=:/usr/bin
fi
if [ -d /usr/sbin ]; then PATH+=:/usr/sbin
fi
# homebrew bin directories
if [ -d /usr/local/bin ]; then PATH+=:/usr/local/bin
fi
if [ -d /usr/local/sbin ]; then PATH+=:/usr/local/sbin
fi
# mysql bin directories
if [ -d /usr/local/mysql/bin ]; then PATH+=:/usr/local/mysql/bin
fi
if [ -d /usr/local/mysql/sbin ]; then PATH+=:/usr/local/mysql/sbin
fi
# X11 bin directories
if [ -d /usr/X11/bin ]; then PATH+=:/usr/X11/bin
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

###############################################################################


###############################################################################
# LD Library Path Construction.
###############################################################################

LD_LIBRARY_PATH=.
if [ -d /usr/lib ]; then LD_LIBRARY_PATH+=:/usr/lib
fi
if [ -d /usr/local/lib ]; then LD_LIBRARY_PATH+=:/usr/local/lib
fi

###############################################################################


###############################################################################
# Variable Exports.
###############################################################################

export EDITOR=vim
export PAGER=less

# Language
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

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export PATH=$PATH
export PS1=$PS1

###############################################################################

