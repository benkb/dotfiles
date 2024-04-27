# ~/.bashrc: 
# - executed by bash for (interactive) non-login shells.
# - see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
# - configurations for interactive Bash usage , aliases, favorite editor, config the bash prompt


# ~/.profile is loaded initially, but this is a simple way to update
# edits in ~/.profile: simpy opening a new shell


######## NONINTERACTIVE SHELL

if [ -f ~/.profile ] ; then
    . ~/.profile
else
    echo "Warn: ~/.profile not loaded" >&2
fi

sourcing_files="$HOME/kit/inc/sourcing_files.bash"

[ -f "$sourcing_files" ] && source "$sourcing_files" "$HOME/kit/conf"


# if this is a non-interactive (login) shell, then this is it
[ -z "$PS1" ] && return

######## INTERACTIVE SHELL
#
[ -f "$sourcing_files" ] && source "$sourcing_files" "$HOME/kit/aliases"

sourcing_aliases="$HOME/kit/inc/sourcing_aliases.bash"

[ -f "$sourcing_aliases" ] && source "$sourcing_aliases" "$HOME/kit" 'utils'

## GLOBAL SETTINGS
# Setting for the new UTF-8 terminal support in Lion
#
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# From here on out, I put in things that are meaningful to interactive shells, like aliases,
# `shopt` invocations, HISTORY control, terminal characteristics, PROMPT, etc.

# in this setup ~/.bashrc is called by .bash_profile
# If not running interactively, don't do anything

set -o vi

# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


