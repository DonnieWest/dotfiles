complete -c svc -f
complete -c svc -n 'not __fish_seen_subcommand_from list start stop restart status enable disable' \
    -a 'list start stop restart status enable disable'
complete -c svc -n '__fish_seen_subcommand_from start stop restart status enable disable' \
    -a '(brew services list 2>/dev/null | string split \n | string match -rv "^Name" | string split " " -f1)'
