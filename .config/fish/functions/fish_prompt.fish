function fish_prompt
    # Green % if last command succeeded, red % if failed (matching zsh)
    if test $status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n ' % '
    set_color normal
end
