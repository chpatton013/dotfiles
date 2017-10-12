# TODO

## Infect

### Pull dependencies on setup

Dependencies should not be committed or submoduled. They should be fetched
explicitly at infect time.

* colors/dircolors/solarized
* themes/solarized/iterm2-colors-solarized
* themes/solarized/gnome-terminal-colors-solarized
* themes/solarized/konsole-colors-solarized
* themes/solarized/tmux-colors-solarized

### Switch to Ansible

Ansible is much better at this than my shell scripts will ever be.

## Tmux

### Use Powerline

## Vim

### Replace Airline with Powerline

### Find a formatter for VimL

This is proving difficult to search for. All I find are formatters that work in
Vim.

### Use `fd` as file scanner

CommandT is not nearly configurable enough to support this. There is an [open
pull request](https://github.com/wincent/command-t/pull/258) that may introduce
the support needed, though.
