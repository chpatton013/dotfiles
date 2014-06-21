#!/usr/bin/env zsh

###############################################################################
# ZSH Modules.
###############################################################################

autoload -U compinit complete complist computil    # Enable completion support.
autoload -U promptinit                             # Prompt customization support.
autoload -U colors                                 # Enable color support.
autoload -U regex                                  # Enable regex support.
colors && compinit -u && promptinit

###############################################################################


###############################################################################
# External Files.
###############################################################################

if [ -f ~/.commonrc ]; then
   fg_black="%{$fg[black]%}"
   fg_red="%{$fg[red]%}"
   fg_green="%{$fg[green]%}"
   fg_yellow="%{$fg[yellow]%}"
   fg_blue="%{$fg[blue]%}"
   fg_magenta="%{$fg[magenta]%}"
   fg_cyan="%{$fg[cyan]%}"
   fg_white="%{$fg[white]%}"
   reset_color="%{$reset_color%}"

   SH_name="%n"
   SH_host="%M"
   SH_pwd="%~"
   SH_date="%D"
   SH_time="%*"
   SH_priv="%#"

   source ~/.commonrc
fi

###############################################################################


###############################################################################
# Key Bindings.
###############################################################################

# Incremental search.
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward
# Search on text already typed in.
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# Rebind arrow keys.
bindkey '\e[A' up-line-or-history
bindkey '\eOA' up-line-or-history
bindkey '\e[B' down-line-or-history
bindkey '\eOB' down-line-or-history
bindkey '\e[C' forward-char
bindkey '\eOC' forward-char
bindkey '\e[D' backward-char
bindkey '\eOD' backward-char
# Rebind home and end.
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
# Rebind the insert and delete.
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char

# Vim smash escape.
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'kj' vi-cmd-mode
# Vim undo and redo.
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^r' redo
# Vim clear text on line ("quit").
bindkey -M vicmd "q" push-line

# Space and completion in one.
bindkey -M viins ' ' magic-space

###############################################################################


###############################################################################
# Configuration Options.
###############################################################################

setopt AUTO_CD          # Lone directory names become cd commands.
setopt AUTO_PUSHD       # cd = pushd.
setopt CORRECT          # This is why I use zsh.
setopt IGNORE_EOF       # We don't want to have any accidents, now do we?
setopt MULTIOS          # Allow piping to multiple outputs.
setopt NO_BEEP          # No audio bells.
setopt NO_FLOW_CONTROL  # It's annoying when the terminal stops producing output for no good reason.
setopt NO_HUP           # Do not hang up on me.
setopt PUSHD_MINUS      # Reverses 'cd +1' and 'cd -1'.
setopt PUSHD_SILENT     # So annoying.
setopt PUSHD_TO_HOME    # Blank pushd goes to home.
setopt RC_EXPAND_PARAM  # foo${a b c}bar = fooabar foobbar foocbar instead of fooa b cbar.
setopt VI               # Vim commands on the command line (instead of emacs).

###############################################################################


###############################################################################
# History Settings.
###############################################################################

setopt APPEND_HISTORY         # Do not overwrite.
setopt EXTENDED_HISTORY       # Save time and duration of execution.
setopt HIST_IGNORE_DUPS       # Ignore immediate duplicates.
setopt HIST_IGNORE_SPACE      # Do not save lines that start with a space.
setopt HIST_NO_STORE          # Do not save commands with '!' (only the resulting auto-completed command).
setopt HIST_REDUCE_BLANKS     # This     seems  like    a good    idea.
setopt HIST_VERIFY            # Auto-completion with '!' verifies on next line.
setopt SHARE_HISTORY          # Share history between shells.

###############################################################################


###############################################################################
# Completion Settings.
###############################################################################

setopt COMPLETE_IN_WORD    # Try to complete from cursor.
setopt GLOB_COMPLETE       # Expand globs.
setopt EXTENDED_GLOB       # Moar globs!
setopt NO_CASE_GLOB        # Case insensitive globbing.
setopt NUMERIC_GLOB_SORT   # Glob sorting is primarily numeric.

# Formatting output.
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'
zstyle ':completion:*' verbose yes
# Descriptions for options not described by completion functions.
zstyle ':completion:*' auto-description 'specify: %d'
# Menu instead of prompting for output. Auto-select first item.
zstyle ':completion:*:default' menu 'select=0'
# Use colors in completion menu.
zstyle ':completion:*:default' list-colors "=(#b) #([0-9]#)*=36=31"
# Display different types of matches separately.
zstyle ':completion:*' group-name ''
# Separate man page sections.
zstyle ':completion:*:manuals' separate-sections true
# Case insensitive completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Don't complete directory we are already in (../here).
zstyle ':completion:*' ignore-parents parent pwd
# More errors allowed for large words and fewer for small words.
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'
# Perform expansions, match all completions and corrections, and omit ignored.
zstyle ':completion:*' completer _expand _complete _approximate _ignored
# Faster completion.
zstyle ':completion::complete:*' use-cache 1

###############################################################################
