#/bin/sh
#
# To large, to ugly
set -u

LINKDIR="${1:-}"

die () { echo "$@"; exit 1; }


SCRIPTNAME="${0##*/}"
SCRIPTDIR="$(cd "$(dirname "$0")" ; pwd -P ;)"

if [ -n "$LINKDIR" ] ; then
    if [ -d "$LINKDIR" ]; then
        PWDNAME="${PWD##*/}"
        rm -f "$LINKDIR/$PWDNAME"
        ln -s "$PWD" "$LINKDIR/$PWDNAME"
    else
        die "Err: no valid LINKDIR '$LINKDIR'"
    fi
fi

link_to_target(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target="${2:-}"
    [ -n "$target" ] || die "Err: no target_item"

    local target_dir="$(dirname "$target")"

    if [ -e "$target_dir" ] ; then
        if [ -f "$target_dir" ]; then
            die "Err: '$target_dir' is a file"
        fi
    else
        rm -f "$target_dir"
        mkdir -p "$target_dir"
    fi

    if [ -e "$target" ] ; then
        [ -L "$target" ] || die "Err: target not a link: '$target'" 
    fi
    rm -f "$target"

    ln -s "$source" "$target"
}


link_to_linkdir(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target_item="${2:-}"
    [ -n "$target_item" ] || die "Err: no target_item"

    if [ -n "$LINKDIR" ] ; then
        rm -f "$LINKDIR/.$target_item"
        ln -s "$i" "$LINKDIR/.$target_item"
    fi
}

handle_dir(){
    local cwdir="${1:-}"
    [ -n "$cwdir" ] || die "Err: no cwdir"

    local home_item="${2:-}"
    [ -n "$home_item" ] || die "Err: no home_item" 

    local is_home=
    local homepath=
    if [ "$home_item" = "$HOME" ] ; then
        is_home=1
        homepath="$HOME/."
    else
        homepath="$home_item/"
    fi

   [ -d "$cwdir" ] || die "Err: no valid cwdir '$cwdir'"
   [ -e "$homepath" ] || die "Err: no valid homepath '$homepath'"

    for i in "$cwdir"/* ; do
        [ -f "$i" ] || [ -d "$i" ] || continue 

        local bi="${i##*/}"

        case "$bi" in $SCRIPTNAME|README*) continue ;; *) : ;; esac

        local target_name="${bi%.*}"

        if [ -f "$i" ] ; then
            link_to_target "$i" "${homepath}${bi}"
            [ -n "$is_home" ] && link_to_linkdir "$i" "${bi}"
        elif [ -d "$i" ] ; then
            # magic: fish-config -> config/fish; HOME.d -> /home/baba
            local target_folder="$(perl -e '($a)=@ARGV; print(join("/", reverse( map { (/^[A-Z]+$/)?$ENV{$_}:$_ } split("-", $a))))' "$target_name")" 

            local target_topdir=
            local target_dirpath=
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

            [ -n "$is_home" ] && link_to_linkdir "$i" "${target_topdir}"

            case "$bi" in
                *.d)   
                    mkdir -p "$target_dirpath" || die "Err: could not create '$target_dirpath'"
                    handle_dir "$i" "$target_dirpath" ;;
                *.l) link_to_target "$i" "$target_dirpath" ;;
                *) die "Err; don't know what to do with '$bi', is it [l]ink or [d]irectory?" ;;
            esac
        else
            echo "Warn: omit $i"
        fi
    done
}

handle_dir "$PWD" "$HOME"
