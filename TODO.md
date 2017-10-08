# TODO

## Bin

`sshkey` should be in its own repository, just like `worktree`.

## Bootstrap

A lot of that is outdated and should be cleaned up.

## Infect

### Pull dependencies on setup

Dependencies should not be committed or submoduled. They should be fetched
explicitly at infect time.

* git/git-completion.sh
* colors/dircolors/solarized
* themes/solarized/iterm2-colors-solarized
* themes/solarized/gnome-terminal-colors-solarized
* themes/solarized/konsole-colors-solarized
* themes/solarized/tmux-colors-solarized
* tmux/plugins/tmux-continuum
* tmux/plugins/tmux-resurrect
* tmux/plugins/tpm

### Switch to Ansible

Ansible is much better at this than my shell scripts will ever be.

## Sh

### Audit shell RC's

It's been way too long since I've actually looked at those. They need to have
some life breathed back into them.

### Oh-My-Zsh

Everyone keeps raving about it. It might be worth trying out.

## Tmux

### Automate resurrect plugin

Investigate to see if this can be automated. I only ever need it when something
catastrophic happens, and at that point it's too late to use.

## Vim

### Find a formatter for VimL

This is proving difficult to search for. All I find are formatters that work in
Vim.

### Use `fd` as file scanner

CommandT is not nearly configurable enough to support this. There is an [open
pull request](https://github.com/wincent/command-t/pull/258) that may introduce
the support needed, though.
