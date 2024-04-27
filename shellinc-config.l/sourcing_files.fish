
for d in $argv
    [ -d "$d" ] || continue
    for f in $d/*.*sh
        [ -f "$f" ] || continue
        switch $f
            case '_*'
                continue
            case '*.sh' '*.fish'
                #[ -f "$f" ] && echo source $f
                [ -f "$f" ] && source $f
        end
    end
end
