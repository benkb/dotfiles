# ~/.profile: 
# ------------
#
# env variables for (ba)sh and fish, available in the CLI and Scripting
#
# - set environment variables (except bash specific ones)
# - executed by the command interpreters for login shells. Must be compatible with /bin/sh (bash,dash,ksh)
#
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# set PATH so it includes user's private bin directories


# USER Variables
#
# personal libraries ~/.local/bkblib/vimlib/vitmux/vitmxux_2023221132.sh
export PROFILE__BKBLIB_HOME=''
[ -d "$HOME/.bkblib" ] && export PROFILE__SHELLIB_HOME="$HOME/.bkblib"

export PROFILE__SHELLCONF_HOME=''
[ -d "$HOME/kit/shellconf" ] && export PROFILE__SHELLCONF_HOME="$HOME/kit/shellconf"

export PROFILE__UTILS_HOME=''
[ -d "$HOME/kit/utils" ] && export PROFILE__UTILS_HOME="$HOME/kit/utils"

export PROFILE__ALIASES_HOME=''
[ -d "$HOME/kit/aliases" ] && export PROFILE__ALIASES_HOME="$HOME/kit/aliases"


########## PATH

export PATH='/bin:/sbin:/usr/bin:/usr/local/bin'

## System Variables
### JAVA_HOME
test -d "$HOME/build/openjdk/jdk-22.jdk/Contents/Home" && export JAVA_HOME="$HOME/build/openjdk/jdk-22.jdk/Contents/Home"

### LLVM_HOME
export LLVM_VERSION=12
test -d "/usr/local/opt/$LLVM_VERSION" && export LLVM_HOME="/usr/local/opt/$LLVM_VERSION"

## PATH
test -d '/usr/sbin'         && export PATH="/usr/sbin:$PATH"
test -d '/opt/bin'          && export PATH="/opt/bin:$PATH"
test -d '/opt/sbin'         && export PATH="/opt/sbin:$PATH"
test -d '/usr/local/sbin'   && export PATH="/usr/local/sbin:$PATH"
test -d '/usr/local/bin'    && export PATH="/usr/local/bin:$PATH"
test -d '/opt/local/bin'    && export PATH="/opt/local/bin:$PATH"
test -d '/opt/local/sbin'   && export PATH="/opt/local/sbin:$PATH"
test -d "$HOME/.bin"        && export PATH="$HOME/.bin:$PATH"
test -d "$HOME/.local/bin"  && export PATH="$HOME/.local/bin:$PATH"
test -d "$HOME/build/bin"   && export PATH="$HOME/build/bin:$PATH"
test -d "$HOME/dev/bin"     && export PATH="$HOME/dev/bin:$PATH"
test -d "$HOME/.opam/default/bin" && export PATH="$HOME/.opam/default/bin:$PATH"
test -d "$HOME/.cargo/bin" && export PATH="$HOME/.cargo/bin:$PATH"
test -d "/Applications/Racket v8.12/bin" &&  export PATH="/Applications/Racket v8.12/bin:$PATH"
test -d "$HOME/go/bin" && export PATH="$HOME/go/bin:$PATH"
test -d "$HOME/Library/Application Support/Coursier/bin" && export PATH="$HOME/Library/Application Support/Coursier/bin:$PATH"

### LANG 
test -d "$JAVA_HOME" &&  export PATH="$JAVA_HOME/bin:$PATH"
test -d "$LLVM_HOME" &&  export PATH="$LLVM_HOME/bin:$PATH"

### ALIASES: useful in cli and scripts

test -f "$HOME/.bin/abspath" &&  alias abspath="sh $HOME/.bin/abspath"
test -f "$HOME/.bin/ack" &&  alias ack="perl $HOME/.bin/ack"
test -f "$HOME/.bin/rename" &&  alias rename="perl $HOME/.bin/rename"

