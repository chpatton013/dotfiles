# If not running interactively, don't do anything.
case $- in
*i*) ;;
*) return ;;
esac

###############################################################################
# Modules
###############################################################################

autoload -U compinit complete complist computil # Enable completion support.
autoload -U promptinit                          # Prompt customization support.
autoload -U colors                              # Enable color support.
autoload -U regex                               # Enable regex support.
colors && compinit -u && promptinit

###############################################################################
# Extra config files
###############################################################################

source ~/.shellrc
source_files_in_directory ~/.config/zshrc.d

###############################################################################
# Key Bindings
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
bindkey -M viins 'kj' vi-cmd-mode
# Vim undo and redo.
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^r' redo
# Vim clear text on line ("quit").
bindkey -M vicmd "q" push-line

# Space and completion in one.
bindkey -M viins ' ' magic-space

###############################################################################
# Options
###############################################################################

# Behavior
###############################################################################

setopt AUTO_CD           # Lone directory names become cd commands.
setopt AUTO_PUSHD        # cd = pushd.
setopt CORRECT           # Enable auto-correction for unrecognized commands.
setopt MULTIOS           # Allow piping to multiple outputs.
setopt NO_BEEP           # No audio bells.
setopt NO_FLOW_CONTROL   # It is annoying when the terminal stops producing output for no good reason.
setopt NO_HUP            # Do not hang up on me.
setopt PUSHD_MINUS       # Reverses 'cd +1' and 'cd -1'.
setopt PUSHD_SILENT      # Do not print directory name when running pushd.
setopt PUSHD_TO_HOME     # Blank pushd goes to home.
setopt RC_EXPAND_PARAM   # foo${a b c}bar = fooabar foobbar foocbar instead of fooa b cbar.
setopt VI                # Vim commands on the command line (instead of emacs).

# History
###############################################################################

setopt APPEND_HISTORY    # Append to history file instead of overwriting.
setopt EXTENDED_HISTORY  # Save time and duration of execution.
setopt HIST_IGNORE_DUPS  # Ignore immediate duplicate commands.
setopt HIST_IGNORE_SPACE # Do not save lines that start with a space.
setopt HIST_NO_STORE     # Resolve '!' to their effective commands.
setopt HIST_VERIFY       # Auto-completion with '!' verifies on next line.
setopt SHARE_HISTORY     # Share history between shells.

# Completion
###############################################################################

setopt COMPLETE_IN_WORD  # Try to complete from cursor.
setopt GLOB_COMPLETE     # Expand globs.
setopt EXTENDED_GLOB     # Moar globs!
setopt NO_CASE_GLOB      # Case insensitive globbing.
setopt NUMERIC_GLOB_SORT # Glob sorting is primarily numeric.

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
# Prompt
###############################################################################

CURRENT_BG='NONE'

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
function prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments.
function prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

function prompt_status() {
  prompt_segment yellow white "%?"
}

function prompt_user() {
  prompt_segment red white "%n"
}

function prompt_host() {
  prompt_segment cyan white "%M"
}

function prompt_date() {
  prompt_segment magenta white "$(date +"%Y/%m/%d")"
}

function prompt_time() {
  prompt_segment green white "$(date +"%H:%M:%S")"
}

function prompt_directory() {
  prompt_segment blue white '%~'
}

function prompt_privilege() {
  prompt_segment black white '%#'
}

## Main prompt
function build_prompt() {
  prompt_status
  prompt_user
  prompt_host
  prompt_date
  prompt_time
  prompt_end
  echo

  CURRENT_BG='NONE'
  prompt_directory
  prompt_end
  echo

  CURRENT_BG='NONE'
  prompt_privilege
  prompt_end
}

export PS1="%{%f%b%k%}$(build_prompt) "
