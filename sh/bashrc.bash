###############################################################################
# External Files.
###############################################################################

if [ -f ~/.commonrc ]; then
  fg_black=$'\[\e[0;30m\]'
  fg_red=$'\[\e[0;31m\]'
  fg_green=$'\[\e[0;32m\]'
  fg_yellow=$'\[\e[0;33m\]'
  fg_blue=$'\[\e[0;34m\]'
  fg_magenta=$'\[\e[0;35m\]'
  fg_cyan=$'\[\e[0;36m\]'
  fg_white=$'\[\e[0;37m\]'
  reset_color=$'\[\e[0m\]'

  SH_name=$'\u'
  SH_host=$'\H'
  SH_pwd=$'\w'
  SH_date=$'`date +"%m-%y-%d"`'
  SH_time=$'\D{}'
  SH_priv=$'\$'

  source ~/.commonrc
fi

###############################################################################

###############################################################################
# Configuration Options.
###############################################################################

# Update LINES and COLUMNS after each command.
shopt -s checkwinsize

# "**" recursively expands directories.
shopt -s globstar

# allow <C-s> to pass through the terminal instead of stopping it
[[ $- == *i* ]] && stty stop undef

# allow tab-completion while using sudo
complete -cf sudo

###############################################################################

###############################################################################
# History Settings.
###############################################################################

shopt -s histappend
HISTCONTROL=ignoreboth

###############################################################################
