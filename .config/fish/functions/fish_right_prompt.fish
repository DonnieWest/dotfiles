function fish_right_prompt
    # Show last 2 directory components (matching zsh %2~)
    set_color white
    echo -n (prompt_pwd --full-length-dirs 2)

    # Parse the same porcelain-v2 fields as git-prompt.zsh.
    if command -sq git
        set -l git_status (command git -c core.quotepath=false status --show-stash --branch --porcelain=v2 2>/dev/null)
        if test $pipestatus[1] -eq 0
            set -l oid
            set -l branch
            set -l upstream
            set -l ahead 0
            set -l behind 0
            set -l unmerged 0
            set -l staged 0
            set -l unstaged 0
            set -l untracked 0
            set -l stashed 0

            for line in $git_status
                if string match -rq '^# branch\.oid ' -- $line
                    set oid (string replace -r '^# branch\.oid ' '' -- $line)
                else if string match -rq '^# branch\.head ' -- $line
                    set branch (string replace -r '^# branch\.head ' '' -- $line)
                else if string match -rq '^# branch\.upstream ' -- $line
                    set upstream (string replace -r '^# branch\.upstream ' '' -- $line)
                else if string match -rq '^# branch\.ab ' -- $line
                    set -l tracking (string split ' ' -- $line)
                    set ahead (string trim -l -c + -- $tracking[3])
                    set behind (string trim -l -c - -- $tracking[4])
                else if string match -rq '^# stash ' -- $line
                    set stashed (string replace -r '^# stash ' '' -- $line)
                else if string match -rq '^\? ' -- $line
                    set untracked (math $untracked + 1)
                else if string match -rq '^u ' -- $line
                    set unmerged (math $unmerged + 1)
                else if string match -rq '^[12] ' -- $line
                    set -l fields (string split -m2 ' ' -- $line)
                    set -l xy $fields[2]
                    test (string sub -s1 -l1 -- $xy) = .; or set staged (math $staged + 1)
                    test (string sub -s2 -l1 -- $xy) = .; or set unstaged (math $unstaged + 1)
                end
            end

            echo -n "  "
            set_color cyan
            if test "$branch" = '(detached)'
                echo -n ":"(string sub -l7 -- $oid)
            else
                echo -n "$branch"
            end

            if test -n "$upstream"
                set_color -o yellow
                echo -n "⟳ "
            end
            if test $behind -gt 0
                set_color cyan
                echo -n "↓$behind"
            end
            if test $ahead -gt 0
                set_color cyan
                echo -n "↑$ahead"
            end

            set_color normal
            echo -n " "
            if test $unmerged -gt 0
                set_color red
                echo -n "✖$unmerged"
            end
            if test $staged -gt 0
                set_color green
                echo -n "●$staged"
            end
            if test $unstaged -gt 0
                set_color red
                echo -n "✚$unstaged"
            end
            if test $untracked -gt 0
                set_color normal
                echo -n "…$untracked"
            end
            if test $stashed -gt 0
                set_color blue
                echo -n "⚑$stashed"
            end
            if test $unmerged -eq 0 -a $staged -eq 0 -a $unstaged -eq 0 -a $untracked -eq 0
                set_color -o green
                echo -n "✔"
            end
        end
    end

    set_color normal
    echo -n " "
end
