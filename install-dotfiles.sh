#/bin/sh
#
# To large, to ugly
set -u

LINKDIR="${1:-}"

die () { echo "$@" >&2; exit 1; }
info () { echo "$@" >&2;  }


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

create_parent_dir(){
    local dir="${1:-}"
    [ -n "$dir" ] || die "Err: no target_item"

    local parent_dir="$(dirname "$dir")"

    if [ -e "$parent_dir" ] ; then
        [ -d "$parent_dir" ] || die "Err: target parent somehow exists in '$parent_dir'"
    else
        rm -f "$parent_dir"
        mkdir -p "$parent_dir"
    fi

}

link_to_target(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target="${2:-}"
    [ -n "$target" ] || die "Err: no target_item"

    if [ -e "$target" ] ; then
        if  [ -L "$target" ] ; then
            rm -f "$target"
        else
            die "Err: taget alredy exists '$target'"
        fi
    else
        rm -f "$target"
    fi

    ln -s "$source" "$target"
}


link_to_linkdir(){
    local source="${1:-}"
    [ -n "$source" ] || die "Err: no source"
    local target_item="${2:-}"
    [ -n "$target_item" ] || die "Err: no target_item"

    if [ -n "$LINKDIR" ] ; then
        rm -f "$LINKDIR/$target_item"
        ln -s "$source" "$LINKDIR/$target_item"
    fi
}

handle_dir(){
    local cwdir="${1:-}"
    [ -n "$cwdir" ] || die "Err: no cwdir"

   [ -d "$cwdir" ] || die "Err: no valid cwdir '$cwdir'"

    for i in "$cwdir"/* ; do
      [ -f "$i" ] || [ -d "$i" ] || continue 

        local bi="${i##*/}"
        local target_name="${bi%.*}"

        if [ -f "$i" ] ; then
            case "$bi" in 
                $SCRIPTNAME|README*|readme*|Readme|License*|LICENSE*|install*) continue ;; 
                *) 
                    link_to_target "$i" "${HOME}/.${bi}" 
                    link_to_linkdir "$i" ".${bi}" 
                    ;; 
            esac
        elif [ -d "$i" ] ; then
            # magic: fish-config -> config/fish; HOME.d -> /home/baba
            local target_folder="$(perl -e '($a)=@ARGV; print(join("/", reverse( map { (/^[A-Z]+$/)?$ENV{$_}:$_ } split("-", $a))))' "$target_name")" 

            local target_path=
            local linkdir_folder=
            case "$target_folder" in
                /*) die "Err: this absolut path makes no sense '$target_folder'"
                    #target_path="$target_folder" 
                    #linkdir_folder="${target_folder%%/*}"
                    ;;
                */*) 
                    target_path="$HOME/.$target_folder"
                    linkdir_folder="${target_folder%%/*}"
                    ;;
                *)
                    linkdir_folder="${target_folder}"
            esac


            local target_endpath=
            if [ -n "$target_path" ] ; then
                create_parent_dir "$target_path"
                target_endpath="$target_path"
            else
                target_endpath="$HOME/.$target_folder"
            fi


            case "$bi" in
                -*|*-) die "Err: invalid dirname '$bi'" ;;
                *.d)   
                    mkdir -p "$target_endpath" || die "Err: could not create '$target_path'"
                    for ii in "$i"/*; do
                        local bii="${ii##*/}"
                        link_to_target "$ii" "${target_endpath}/${bii}"
                    done

                    link_to_linkdir "$i" ".${linkdir_folder}"
                    ;;
               *.l) 
                   link_to_target "$i" "$target_endpath"
                    link_to_linkdir "$i" ".${linkdir_folder}"
                    ;;
                *) 
                    link_to_linkdir "$i" "${target_name}"
                    for ii in "$i"/* ; do
                        local bii="${ii##*/}"
                        link_to_target "$ii" "${HOME}/.${bii}" 
                         link_to_linkdir "$ii" ".${bii}" 
                    done
                    ;;
            esac
        else
            echo "Warn: omit $i"
        fi
    done
}

handle_dir "$PWD"
