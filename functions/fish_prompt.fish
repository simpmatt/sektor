function fish_prompt
    set -l status_copy $status

    set -l root (
        set -l root (dirname $PWD)

        if test "$PWD" != "$HOME" -a "$root" != /
            echo $root | sed -E "s|$HOME||;s|(^/)?([^/.])[^/]*|\2|g;s|/| |g"
        end
        )

    set -l base (
        if test "$PWD" != / -a "$PWD" != "$HOME"
            basename $PWD
        end
        )

    set -l branch_name

    if set branch_name (git_branch_name)
        set -l repo_status_color 0ff 222
        set -l base_color 0ff 222
        set -l branch_ref_color 0ff 111
        set -l repo_status
        set -l branch_ref ➦
        set -l dirty_and_staged

        if git symbolic-ref HEAD ^ /dev/null > /dev/null
            set branch_ref 
        end

        if git_is_empty
            set branch_ref_color f00 111
        end

        if git_is_dirty
            set branch_ref_color 111 f00
            set repo_status_color 0ff 222

            if git_is_staged
                set branch_ref_color f00 111
                set -e dirty_and_staged
            end
        else
            if git_is_staged
                set branch_ref_color 111 0ff
                set repo_status_color 0ff 222
            end
        end

        if git_is_stashed
            set repo_status ╍
        end

        segment "  $branch_name $repo_status " $repo_status_color
        segment "" 111 111

        if not set -q dirty_and_staged
            segment " $branch_ref " 0ff 111
            segment "" 111 111
        end

        segment " $branch_ref " $branch_ref_color
        segment "" 111 111

        if test ! -z "$base"
            segment " $base " $base_color
            segment "" 111 111
        end
    else
        if test ! -z "$base"
            set -l color 0ff 222

            if test ! -z "$root"
                set base "$base "
                set color 0ff 111
            end

            segment " $base " $color
            segment "" 111 111
        end
    end

    if test ! -z "$root"
        segment " $root " 0ff 222
        segment "" 111 111
    end

    set -l segment_colors 0ff 222

    switch "$PWD"
        case "$HOME"\*
        case \*
            set segment_colors 111 0ff
    end

    if test "$status_copy" -ne 0
        set segment_colors 111 f00
    end

    segment " ╍╍ " $segment_colors

    set segment (set_color $segment_colors[2])$segment(set_color normal)

    segment_close
end
