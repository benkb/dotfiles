set dirinput $argv[1]

set dirfilter $argv[2]

[ -n "$dirinput" ] || return 1
[ -d "$dirinput" ] || return 1

function get_interp
    set ext $argv[1]
    switch $ext
        case 'sh' 'bash' 'dash'
            echo $ext
        case rb
            echo 'ruby'
        case pl
            echo 'perl'
        case py
            echo python
        case '*'
            echo "Warn: extension '$ext' not implemented, skip alias" >&2
            return 1
    end
end

function gen_aliases
    set utilsdir $argv[1]

    [ -n "$utilsdir" ] || return 1

    for scriptfile in $utilsdir/*
        [ -f "$scriptfile" ] || continue

        set bname (path basename $scriptfile)
        set name (string split -r -m1 . $bname)[1]
        set ext (string split -r -m1 . $bname)[2]

        set interp (get_interp $ext)
        if string length --quiet  $interp
            switch "$name" 
                case '_*' 'lib*'
                    continue
                case '*'
                    # echo "alias $name = $interp $scriptfile"
                    alias $name="$interp $scriptfile"
            end
        end
    end
end


if [ -n "$dirfilter" ] 
    for utilsdir in $dirinput/* 
        [ -d "$utilsdir" ] || continue

        set bdir (path basename $utilsdir)

        switch "$bdir" 
            case $dirfilter
                gen_aliases "$utilsdir"
        end
    end
else
    gen_aliases "$utilsdir"
end