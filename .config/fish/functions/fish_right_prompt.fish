function fish_right_prompt
    # Show last 2 directory components (matching zsh %2~)
    set_color white
    echo -n (prompt_pwd --full-length-dirs 2)

    # Git prompt (matching zsh git-prompt.zsh style)
    if command -sq git; and git rev-parse --git-dir >/dev/null 2>&1
        set -l git_dir (git rev-parse --git-dir 2>/dev/null)

        # Get branch name
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -z "$branch"
            set branch (git describe --contains --all HEAD 2>/dev/null; or echo "detached")
        end

        # Branch name in cyan
        set_color cyan
        echo -n "  $branch"

        # Get ahead/behind counts
        set -l upstream (git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if test -n "$upstream"
            git rev-list --left-right --count HEAD...$upstream 2>/dev/null | read -l ahead behind
            if test -n "$ahead" -a "$ahead" -gt 0
                set_color cyan
                echo -n "↑"
            end
            if test -n "$behind" -a "$behind" -gt 0
                set_color cyan
                echo -n "↓"
            end
        end

        # Get git status
        set -l porcelain_status (git status --porcelain 2>/dev/null | string sub -l2)

        # Add separator before status indicators
        if test -n "$porcelain_status"
            echo -n " "
        end

        # Count and show unmerged
        set -l unmerged_count (string match -r 'AA|DD|U' $porcelain_status | count)
        if test $unmerged_count -gt 0
            set_color red
            echo -n "✖$unmerged_count"
        end

        # Count and show staged changes
        set -l staged_count (string match -r '^[ACDMRT]' $porcelain_status | count)
        if test $staged_count -gt 0
            set_color green
            echo -n "●$staged_count"
        end

        # Count and show unstaged changes
        set -l unstaged_count (string match -r '^.[MD]' $porcelain_status | count)
        if test $unstaged_count -gt 0
            set_color red
            echo -n "✚$unstaged_count"
        end

        # Count and show stashes
        set -l stash_count (git rev-list --walk-reflogs --count refs/stash 2>/dev/null)
        if test -n "$stash_count" -a "$stash_count" -gt 0
            set_color blue
            echo -n "⚑$stash_count"
        end

        # Show clean indicator if no changes
        if test -z "$porcelain_status"
            echo -n " "
            set_color -o green
            echo -n "✔"
        end
    end

    set_color normal
    echo -n " "
end
