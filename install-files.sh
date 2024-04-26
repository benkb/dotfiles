#!/bin/sh
#
set -u

LINKDIR="${1:-}"

die () { echo "$@"; exit 1; }

if [ -n "$LINKDIR" ] ; then
    [ -d "$LINKDIR" ] || die "Err: no valid LINKDIR '$LINKDIR'"
fi

SCRIPTNAME="${0##*/}"
SCRIPTDIR="$(cd "${0%/*}" ; pwd -P ;)"

SCRIPTDIR_NAME="${SCRIPTDIR##*/}"

HOMEPATH=
DOTFILES=
case "$SCRIPTDIR_NAME" in
    *-*-*) die "Err: please only one '-' in dir" ;;
    dot-files) 
        DOTFILES=1 
        HOMEPATH="$HOME/." ;;
    *-files) 
        HOMEPATH="$HOME/${SCRIPTDIR_NAME%%-*}/" 
        mkdir -p "$HOMEPATH" || die "Err: could not create HOMEPATH '$HOMEPATH'"
        ;;
    *-*) die "Err: please ending on '*-files'" ;;
    *) die "Err: please at least one '-' in dir" ;;
esac



link_to_target(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target="${2:-}"
    [ -n "$target" ] || die "Err: no target_item"

    local target_dir="$(dirname "$target")"

    if [ -d "$target_dir" ]; then
        :
    elif [ -L "$target_dir" ]; then
        die "Err: '$target_dir' is a link"
    elif [ -f "$target_dir" ]; then
        die "Err: '$target_dir' is a file"
    elif [ -e "$target_dir" ]; then
        die "Err: '$target_dir' exists already"
    else
        mkdir -p "$target_dir" 
    fi

    if [ -L "$target" ]; then
        rm -f "$target"
    elif [ -d "$target" ]; then
        if [ -L "$target" ] ; then
            rm -f "$target"
        else
            die "Err: the target '$target' is a directory, cannot remove"
        fi
    elif [ -f "$target" ]; then
        die "Err: cannot remove file '$target'"
    else
        [ -e "$target" ] && die "Err: cannot remove item '$target'"
    fi

    ln -s "$source" "$target"
}


link_to_linkdir(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target_item="${2:-}"
    [ -n "$target_item" ] || die "Err: no target_item"

    if [ -n "$LINKDIR" ] ; then
        if [ -n "$DOTFILES" ] ; then
            rm -f "$LINKDIR/.$target_item"
            ln -s "$i" "$LINKDIR/.$target_item"
        else
            rm -f "$LINKDIR/$target_item"
            ln -s "$i" "$LINKDIR/$target_item"
        fi
    fi
}

handle_dir(){
   local homepath="${1:-}"
   [ -n "$homepath" ] || die "Err: no homepath"
   [ -d "$homepath" ] || die "Err: no valid homepath '$homepath'"
   local dir="${2:-}"
   [ -n "$dir" ] || die "Err: no dir"
   [ -d "$dir" ] || die "Err: no valid dir '$dir'"

    for i in "$dir"/* ; do
        [ -f "$i" ] || [ -d "$i" ] || continue 

        local bi="${i##*/}"

        case "$bi" in $SCRIPTNAME|README*) continue ;; *) : ;; esac

        local target_name="${bi%.*}"

        if [ -f "$i" ] ; then
            link_to_target "$i" "${homepath}${bi}"
            link_to_linkdir "$i" "${homepath}${bi}"
        elif [ -d "$i" ] ; then
            # magic: fish-config -> config/fish; dot-HOME -> /home/baba/dot
            local target_folder="$(perl -e '($a)=@ARGV; print(join("/", reverse( map { (/^[A-Z]+$/)?$ENV{$_}:$_ } split("-", $a))))' "$target_name")" 

            local target_dirpath=
            local target_topdir=
            case "$target_folder" in
                /*)
                    target_topdir="${target_name}"
                    target_dirpath="$target_folder" 
                    ;;
                *) 
                    target_topdir="${target_folder%%/*}"
                    target_dirpath="${homepath}$target_folder" 
                    ;;
            esac

            link_to_linkdir "$i" "${target_topdir}"

            case "$bi" in
                dotfiles)   handle_dir "$HOME/." "$i" ;;
                *.d)   
                    mkdir -p "$target_dirpath" || die "Err: could not create '$target_dirpath'"
                    handle_dir "$target_dirpath/" "$i" ;;
                *.l) link_to_target "$i" "$target_dirpath" ;;
                *) die "Err; don't know what to do with '$bi', is it [l]ink or [d]irectory?" ;;
            esac
        else
            echo "Warn: omit $i"
        fi
    done
}

handle_dir "$HOMEPATH" "$PWD"
