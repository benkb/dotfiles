# Thougths about where/how to manage/store fish configs
# - fish autoload of configs and scripts via ~/.config/fish/conf.d
# - autoload has negative impact when in non-interactive mode (scripting)
# - control the inclusion manually here in ~/.config/fish/config.fish

# start in insert mode

fish_vi_key_bindings insert

set -gx GPG_TTY (/usr/bin/tty)

### Interactive Shell Only
# if this called during the init of a script its time to go
# was not a good idea when using fish from ssh


# sourcing for environment variables and aliases

######## NONINTERACTIVE SHELL


if [ -f ~/.profile ] 
    . ~/.profile
else
    echo "Warn: ~/.profile not found" >&2
end


set sourcing_files "$HOME/kit/inc/sourcing_files.fish"

[ -f "$sourcing_files" ] && source $sourcing_files "$HOME/kit/conf"

status is-interactive || return 0 


######## INTERACTIVE SHELL

[ -f "$sourcing_files" ] && source $sourcing_files "$HOME/kit/aliases"

set gen_aliases "$HOME/.config/shellinc/gen_aliases.fish"

[ -f "$gen_aliases" ] && source $gen_aliases "$HOME/kit/" 'utils'


