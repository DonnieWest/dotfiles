function b-pass
    command -q rbw; or return 1

    set -l selected (rbw list | fzf --prompt='Search password: ' --bind 'change:reload:rbw search {q} || true')
    if test -n "$selected"
        rbw get "$selected" | copy_clipboard
        echo 'Password copied to clipboard'
    end
end

function update_npm
    echo 'Checking NPM global packages'
    set -l output (ncu -g)
    printf '%s\n' $output

    set -l last_line (string join \n $output | tail -2 | head -1 | string trim)
    if test "$last_line" != 'All global packages are up-to-date :)'
        read --nchars 1 --prompt-str 'Do you wish to update these packages? [Y/n] ' input
        echo
        switch $input
            case Y y
                echo 'Updating...'
                eval $last_line
            case N n
                echo 'Aborting...'
                return 1
            case '*'
                echo 'Invalid choice. Please press Y or N.'
                return 1
        end
    end
end

function acli-jira-default-jql
    echo 'assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC'
end

function acli-jira-format-issues
    jq -r '
        def items:
          if type == "array" then .[]
          elif type == "object" and has("issues") then .issues[]
          elif type == "object" and has("workItems") then .workItems[]
          elif type == "object" and has("results") then .results[]
          elif type == "object" and has("values") then .values[]
          else .
          end;
        def field($name):
          if type != "object" then null
          elif has($name) then .[$name]
          elif (.fields | type) == "object" and (.fields | has($name)) then .fields[$name]
          else null
          end;
        def text:
          if type == "object" then (.displayName // .name // .value // .key // .accountId // "")
          else (. // "")
          end;
        items | select(type == "object") |
          [(field("key") | text), (field("status") | text), (field("assignee") | text), (field("summary") | text)] |
          @tsv
    '
end

function acli-jira-issues
    set -l jql (string join ' ' $argv)
    test -n "$jql"; or set jql (acli-jira-default-jql)
    acli jira workitem search --jql "$jql" --fields 'key,status,assignee,summary' --paginate --json |
        acli-jira-format-issues
end

function acli-jira-list
    set -l jql (string join ' ' $argv)
    test -n "$jql"; or set jql (acli-jira-default-jql)
    acli-jira-issues "$jql" | column -t -s \t
end

function acli-jira-search
    set -l jql (string join ' ' $argv)
    test -n "$jql"; or set jql (acli-jira-default-jql)
    acli jira workitem search --jql "$jql" --fields 'key,status,assignee,summary' --paginate
end

function acli-jira-mine
    acli-jira-list (acli-jira-default-jql)
end

function acli-jira-pick
    set -l jql (string join ' ' $argv)
    test -n "$jql"; or set jql (acli-jira-default-jql)
    acli-jira-issues "$jql" | fzf --delimiter=\t --with-nth='1,2,3,4' --prompt='Jira issue: '
end

function acli-jira-pick-key
    set -l selected (acli-jira-pick $argv); or return
    string split \t $selected | head -1
end

function acli-jira-pick-keys
    set -l jql (string join ' ' $argv)
    test -n "$jql"; or set jql (acli-jira-default-jql)
    acli-jira-issues "$jql" |
        fzf --multi --delimiter=\t --with-nth='1,2,3,4' --prompt='Jira issues: ' |
        awk -F '\t' '{print $1}' |
        paste -sd, -
end

function acli-jira-view
    set -l issue $argv[1]
    test -n "$issue"; or set issue (acli-jira-pick-key)
    test -n "$issue"; and acli jira workitem view "$issue" --fields 'key,summary,status,assignee,reporter,description'
end

function acli-jira-open
    set -l issue $argv[1]
    test -n "$issue"; or set issue (acli-jira-pick-key)
    test -n "$issue"; and acli jira workitem view "$issue" --web
end

function acli-jira-transition
    set -l keys (acli-jira-pick-keys); or return
    test -n "$keys"; or return

    set -l status (printf 'To Do\nIn Progress\nIn Review\nDone\n' |
        fzf --print-query --prompt='Target status: ' | tail -1 | string trim)
    test -n "$status"; and acli jira workitem transition --key "$keys" --status "$status" --yes
end

function acli-jira-assign-me
    set -l keys (acli-jira-pick-keys); or return
    test -n "$keys"; and acli jira workitem assign --key "$keys" --assignee '@me' --yes
end

function acli-jira-comment
    set -l issue $argv[1]
    if test -n "$issue"
        set -e argv[1]
    else
        set issue (acli-jira-pick-key)
    end
    test -n "$issue"; or return

    set -l body (string join ' ' $argv)
    if test -z "$body"
        acli jira workitem comment create --key "$issue" --editor
    else
        acli jira workitem comment create --key "$issue" --body "$body"
    end
end

function acli-jira-copy-key
    set -l issue $argv[1]
    test -n "$issue"; or set issue (acli-jira-pick-key)
    test -n "$issue"; and printf %s "$issue" | copy_clipboard
end

function acli-jira-branch
    set -l selected (acli-jira-pick $argv); or return
    test -n "$selected"; or return

    set -l fields (string split \t $selected)
    set -l key $fields[1]
    set -l summary $fields[4]
    set -l slug (string lower -- "$summary" |
        string replace -ra '[^a-z0-9]+' - |
        string trim -c - |
        string sub -l 60)
    set -l branch "$key-$slug"
    printf %s "$branch" | copy_clipboard
    echo "$branch"
end
