###############################################################################
# External Files.
###############################################################################

if [ -f ~/.commonrc ]; then
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

# allow <C-s> to pass through the terminal instead of stopping it
stty stop undef

# allow tab-completion while using sudo
complete -cf sudo

###############################################################################

