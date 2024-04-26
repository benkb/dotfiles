# ~/.bashrc: 
# - executed by bash for (interactive) non-login shells.
# - see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples
# - configurations for interactive Bash usage , aliases, favorite editor, config the bash prompt

# If not running interactively, don't do anything

# ~/.profile is loaded initially, but this is a simple way to update
# edits in ~/.profile: simpy opening a new shell

######## NONINTERACTIVE SHELL

if [ -f ~/.profile ] ; then
    . ~/.profile
else
    echo "Warn: ~/.profile not loaded" >&2
fi

if [ -d "${PROFILE__SHELLCONF_HOME:-}" ] ; then
    for confdir in "$PROFILE__SHELLCONF_HOME"/*; do
        [ -d "$confdir" ] || continue
        for shfile in "$confdir"/*.*sh ; do
            case "$shfile" in
                *.sh|*.bash) 
                    #echo source "$shfile"
                    [ -f "$shfile" ] && source "$shfile" ;;
                *) : ;;
            esac
        done
    done
fi

# if this is a non-interactive (login) shell, then this is it
[ -z "$PS1" ] && return

######## INTERACTIVE SHELL

for dir in "${PROFILE__ALIASES_HOME:-}" ; do
   [ -d "$dir" ] || continue
   for shfile in $dir/*.*sh ; do
      case "$shfile" in
         *.sh|*.bash) 
             #[ -f "$shfile" ] && echo source "$shfile" 
             [ -f "$shfile" ] && source "$shfile" ;;
         *) : ;;
      esac
   done
done

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


