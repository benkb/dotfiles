
for d in $@ ; do
    [ -d "$d" ] || continue
    for f in $d/*.*sh; do
        [ -f "$f" ] || continue
        case "${f##*/}" in
            _*) continue ;;
            *.sh|*.bash)
                #[ -f "$f" ] && echo source $f
                [ -f "$f" ] && source "$f"
            ;;
            *) : ;;
        esac
    done
done
