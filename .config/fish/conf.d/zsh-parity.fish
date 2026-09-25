# Keep autosuggestions and editing behavior aligned with the interactive Zsh setup.
set -g fish_color_autosuggestion red
set -q __fish_config_os; or set -g __fish_config_os (uname)

function fish_user_key_bindings
    bind \e\[3\~ delete-char
    bind \ew kill-selection
    bind \el 'commandline -r ls; commandline -f execute'
    bind \e\[A history-prefix-search-backward
    bind \e\[B history-prefix-search-forward
    bind \e\[5\~ up-line
    bind \e\[6\~ down-line
    bind \e\[H beginning-of-line
    bind \e\[1\~ beginning-of-line
    bind \eOH beginning-of-line
    bind \e\[F end-of-line
    bind \e\[4\~ end-of-line
    bind \eOF end-of-line
    bind \cf forward-word
    bind \cb backward-word
    bind \e\[1\;5C forward-word
    bind \e\[1\;5D backward-word
end

# Fish cannot source POSIX export syntax directly, so import this trusted host file.
if test $__fish_config_os = Darwin; and test $hostname = KXQGH3YDCX; and test -r $HOME/.config/work/environment
    while read -l line
        if string match -rq '^export [A-Za-z_][A-Za-z0-9_]*=' -- $line
            set -l pair (string replace -r '^export ' '' -- $line | string split -m1 =)
            set -l value (string replace -r "^'(.*)'\$" '$1' -- $pair[2])
            set -gx $pair[1] $value
        end
    end <$HOME/.config/work/environment
end
