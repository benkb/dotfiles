
dirinput="${1:-}"
dirfilter="${2:-}"

[ -n "$dirinput" ] || {
    echo "Err: no dirinput" >&2
    return 1
}

[ -d "$dirinput" ] || {
    echo "Err: invalid dir '$dirinput'" >&2
    return 1
}

get_interp(){
    local ext="${1:-}"
    case "$ext" in
        'sh'|'bash'|'dash')  echo "$ext";;
        'rb')  echo "ruby";;
        'pl')  echo "perl";;
        'py')  echo "python";;
        '*')
            echo "Warn: extension '$ext' not implemented, skip alias" >&2
            return 1
            ;;
    esac
}

gen_aliases(){
    local utilsdir="${1:-}"

    [ -n "$utilsdir" ] || {
        echo "Err: no utilsdir " >&2
        return 1
    }
    [ -d "$utilsdir" ] || {
        echo "Err: invalid utilsdir  '$utilsdir' " >&2
        return 1
    }

    for scriptfile in $utilsdir/*; do
        [ -f "$scriptfile" ] || continue

        bname="$(basename "$scriptfile")"
        name="${bname%.*}"
        ext="${bname##*.}"

        interp="$(get_interp "$ext")" || continue 
            
        if [ -n "$interp" ] ; then
            case "$name" in
                _*|lib*) continue;;
                *)
                     echo "alias $name = $interp $scriptfile"
                    alias "$name"="$interp $scriptfile"
                    ;;
            esac
        fi
    done
}

if [ -n "$dirfilter" ] ; then
    for utilsdir in "$dirinput"/* ; do
        [ -d "$utilsdir" ] || continue
        case "${utilsdir##*/}" in
            "$dirfilter"|*-"$dirfilter") gen_aliases "$utilsdir" ;;
            *) : ;;
        esac
    done
else
    gen_aliases "$dirinput"
fi
