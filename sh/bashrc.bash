###############################################################################
# External Files.
###############################################################################

if [ -f ~/.commonrc ]; then
   # Color support
   if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      PS1_lbrace=$'\[\e[0;34m\][\[\e[0m\]'
      PS1_rbrace=$'\[\e[0;34m\]]\[\e[0m\]'
      PS1_at=$'\[\e[0;34m\]@\[\e[0m\]'
      PS1_vbar=$'\[\e[0;34m\]|\[\e[0m\]'
      PS1_queue=$'\[\e[0;34m\]>\[\e[0m\]'
      PS1_name=$'\[\e[0;32m\]\u\[\e[0m\]'
      PS1_host=$'\[\e[0;32m\]\H\[\e[0m\]'
      PS1_pwd=$'\[\e[0;32m\]\w\[\e[0m\]'
      PS1_date=$'\[\e[0;32m\]`date +"%m-%y-%d"`\[\e[0m\]'
      PS1_time=$'\[\e[0;32m\]\D{}\[\e[0m\]'
      PS1_priv=$'\[\e[0;32m\]\$\[\e[0m\]'
   else
      PS1_lbrace=$'['
      PS1_rbrace=$']'
      PS1_at=$'@'
      PS1_vbar=$'|'
      PS1_queue=$'>'
      PS1_name=$'\u'
      PS1_host=$'\H'
      PS1_pwd=$'\w'
      PS1_date=$'`date +"%m-%y-%d"`'
      PS1_time=$'\D{}'
      PS1_priv=$'\$'
   fi

   source ~/.commonrc

   unset PS1_lbrace
   unset PS1_rbrace
   unset PS1_at
   unset PS1_vbar
   unset PS1_queue
   unset PS1_name
   unset PS1_host
   unset PS1_pwd
   unset PS1_date
   unset PS1_time
   unset PS1_priv
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
stty stop undef

# allow tab-completion while using sudo
complete -cf sudo

###############################################################################


###############################################################################
# History Settings.
###############################################################################

shopt -s histappend
HISTCONTROL=ignoreboth

###############################################################################
