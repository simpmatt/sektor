function fish_right_prompt
    set -l status_copy $status

    if test "$CMD_DURATION" -gt 5
        set -l duration (echo $CMD_DURATION | hmtime)

        if test ! -z "$duration"
            set -l indicator

            if test $status_copy -ne 0
                set indicator " $status_copy "
            end

            segment_right "$indicator" 000 f00 "$duration "
        end
    else if test $status_copy -ne 0
        segment_right " $status_copy" f00 000 "" " "
    else
        segment_right (date +%H:%M)" " 333 000
    end

    segment_close
end
