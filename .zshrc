source ~/.profile

case ${ZSH_OS:-$OSTYPE} in
  Darwin|darwin*) typeset -gr ZSH_OS=Darwin ;;
  Linux|linux*)   typeset -gr ZSH_OS=Linux ;;
  *)              typeset -gr ZSH_OS=${OSTYPE%%-*} ;;
esac
typeset -gr ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

typeset -g ZSH_COMPLETION_DIR=${ZDOTDIR:-$HOME/.config/zsh}/completions
[[ -d "$ZSH_COMPLETION_DIR/${ZSH_OS:l}" ]] && fpath=("$ZSH_COMPLETION_DIR/${ZSH_OS:l}" $fpath)
[[ -d "$ZSH_COMPLETION_DIR/${HOST%%.*}" ]] && fpath=("$ZSH_COMPLETION_DIR/${HOST%%.*}" $fpath)

setopt autocd
setopt extendedglob
setopt NO_NOMATCH

export CLICOLOR=1

## Prompt

autoload -U colors && colors

setopt prompt_subst

## Keybindings

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -e
bindkey '\e[3~' delete-char
bindkey '\ew' kill-region
bindkey -s '\el' "ls\n"
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey '\e[H'  beginning-of-line
bindkey '\e[OH' beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey '\e[F'  end-of-line
bindkey '\e[OF' end-of-line
bindkey ' ' magic-space
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[Z' reverse-menu-complete
bindkey '^?' backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char
bindkey ' ' magic-space

## History

if [ -z $HISTFILE ]; then
    HISTFILE=$HOME/.zsh_history
fi
HISTSIZE=500000
SAVEHIST=100000
HISTCONTROL=ignoreboth:erasedups

setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt append_history
setopt extended_history
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks

alias history='fc -l 1'
if [[ $ZSH_OS == Linux ]]; then
  alias docker='podman'
  alias docker-compose='podman-compose'
fi

## Completion

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end
setopt COMPLETE_ALIASES

WORDCHARS=''

zmodload -i zsh/complist

# Complete . and .. special directories
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*' users off

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completion"
zstyle ':completion:*' rehash true

# Complete targets first, then variables if none, then files if none
zstyle ':completion::complete:make::' tag-order targets variables
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

## Aliases

alias less='less -R'
alias grep='grep --color=auto'
alias ..='cd ../'
alias parallel='parallel --no-notice' # remove the citing notice
alias cp='cp -i'                    # prompt for overwrite
alias mv='mv -i'                    # prompt for overwrite
alias df='df -h'                    # human readable
alias du='du -h'                    # human readable
alias ll='eza --git -l'             # long format with git status
alias la='eza --git -la'            # all files with git status
alias tree='eza --tree'             # tree view

## Stack

DIRSTACKSIZE=8
setopt autopushd pushdminus pushdsilent pushdtohome pushd_ignore_dups
alias dh='dirs -v'

## GPG Agent

unset SSH_AGENT_PID
export GPG_TTY=$TTY

if command -v gpgconf >/dev/null 2>&1; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

if command -v gpg-connect-agent >/dev/null 2>&1; then
  gpg-connect-agent updatestartuptty /bye >/dev/null
fi

## Misc

# Increase limit of files able to be handled by TernJS
ulimit -n 2048

# Activate FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ssh='TERM=xterm-256color ssh'
# Use custom dircolors

# Clone a plugin, identify its init file, source it, and add it to fpath.
function plugin-load() {
  local repo plugin_dir clone_dir initfile
  local -a initfiles
  for repo in "$@"; do
    plugin_dir=$ZPLUGINDIR/${repo:t}
    initfile=$plugin_dir/${repo:t}.plugin.zsh
    if [[ ! -d $plugin_dir ]]; then
      print -ru2 -- "Cloning $repo..."
      clone_dir=$plugin_dir.tmp.$$
      command git clone -q --depth 1 https://github.com/$repo "$clone_dir" || {
        command rm -rf "$clone_dir"
        continue
      }
      command mv "$clone_dir" "$plugin_dir"
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugin_dir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( ${#initfiles} )) || { print -ru2 -- "No init file found for '$repo'."; continue; }
      command ln -sf "$initfiles[1]" "$initfile"
    fi
    fpath+=("$plugin_dir")
    source "$initfile"
  done
}

function plugin-update () {
  local d
  for d in "$ZPLUGINDIR"/*/.git(N/); do
    print -r -- "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --rebase --autostash --recurse-submodules --depth 1 origin HEAD
  done
}

function plugin-compile() {
  autoload -U zrecompile
  local f
  for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
    zrecompile -pq "$f"
  done
}

# Completion search paths must exist before compinit scans fpath.
plugin-load \
  zsh-users/zsh-completions \
  greymd/docker-zsh-completion

typeset -gr ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
[[ -d $ZSH_CACHE_DIR ]] || command mkdir -p "$ZSH_CACHE_DIR"
typeset -gr zcompdump=$ZSH_CACHE_DIR/zcompdump-${ZSH_VERSION}-${ZSH_OS:l}
autoload -Uz compinit
compinit -d "$zcompdump"
[[ $zcompdump.zwc -nt $zcompdump ]] || zcompile "$zcompdump"

# These settings are read while their plugins are sourced.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=red"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

ZSH_GIT_PROMPT_FORCE_BLANK=1
ZSH_GIT_PROMPT_SHOW_STASH=1
ZSH_GIT_PROMPT_SHOW_UPSTREAM="symbol"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[default]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_no_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_no_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_no_bold[cyan]%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[cyan]%}↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

PROMPT='%(?,%{$fg[green]%},%{$fg[red]%}) %% '
RPROMPT='%{$fg[white]%}%2~$(gitprompt) %{$fg_bold[blue]%}%{$reset_color%}'

# Plugins that register compdefs require an initialized completion system.
# Prompt and widget plugins follow so the first command is fully usable.
plugin-load \
  gradle/gradle-completion \
  lukechilds/zsh-better-npm-completion \
  chrisands/zsh-yarn-completion \
  woefe/git-prompt.zsh \
  zsh-users/zsh-history-substring-search \
  jsahlen/tmux-vim-integration.plugin.zsh \
  laggardkernel/git-ignore \
  zdharma-continuum/fast-syntax-highlighting \
  zsh-users/zsh-autosuggestions

# Setup Env variables
export N_PREFIX=$HOME/.config/n
export GRADLE_HOME="$HOME/.gradle"
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
export POWERLINE_CONFIG_COMMAND="$HOME/.local/bin/powerline-config"
export STEAM_RUNTIME=0


export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export EDITOR="nvim"

case "$ZSH_OS" in
  Darwin)
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export STUDIO_JDK="$JAVA_HOME"
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    ;;
  Linux)
    export ANDROID_HOME="$HOME/.android-sdk-linux"
    export STUDIO_JDK="$JAVA_HOME"
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    ;;
esac

export JDTLS_JVM_ARGS="-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.36/lombok-1.18.36.jar"

# Setup PATH

export PATH="$PATH:/usr/bin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/local/games:/usr/games:$GRADLE_HOME/bin:$HOME/.cabal/bin:/usr/bin/core_perl"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.config/n/bin:$PATH"
export PATH="$HOME/.config/npm/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/bin:$PATH"
[[ $ZSH_OS == Darwin ]] && export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# Shared commands may be overridden by OS- and then host-specific versions.
[[ -d "$HOME/.bin/${ZSH_OS:l}" ]] && path=("$HOME/.bin/${ZSH_OS:l}" $path)
[[ -d "$HOME/.bin/${HOST%%.*}" ]] && path=("$HOME/.bin/${HOST%%.*}" $path)

export PATH="$PATH:$HOME/.npm-global/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.luarocks/bin:$PATH"
export PATH="$HOME/.deno/bin:$PATH"
export PATH="$HOME/.babashka/bbin/bin:$PATH"
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

# Taken from https://gist.github.com/jhass/8839655bb038e829fba1 but also useful for system ruby on arch

[[ -f /usr/share/chruby/chruby.sh ]] && source /usr/share/chruby/chruby.sh
[[ -f /usr/share/chruby/auto.sh ]] && source /usr/share/chruby/auto.sh
RUBIES=(/opt/ruby* $HOME/.rubies/*)

sn() {
  local version
  version=$(n lsr --all  | fzf)
  if [ "x$version" != "x" ]
  then
    echo "Switching to Node $version"
    n $version
  fi
}

copy_clipboard() {
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
  else
    wl-copy
  fi
}

pass() {
  if hash bw 2>/dev/null; then
    bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzy | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | copy_clipboard
  fi
}

b-pass() {
  if hash rbw 2>/dev/null; then
    local selected
    selected=$(rbw list | fzf --prompt="Search password: " --bind "change:reload:rbw search {q} || true")
    if [ -n "$selected" ]; then
      rbw get "$selected" | copy_clipboard
      echo "Password copied to clipboard"
    fi
  fi
}

cheat() {
  curl cht.sh/$1
}

bunx() {
  bun x "$@"
}

update_npm() {
  echo "Checking NPM global packages"
  output=$(ncu -g)
  lastLine=$(echo -n $output | tail -2 | head | tr -d "\n")
  echo $output
  if [ "$lastLine" != "All global packages are up-to-date :)" ]; then
    read -rsqk "input?Do you wish to update these packages? [Y/n]" 
    case "$input" in
      [Yy]) echo "\nUpdating..."; $(echo $lastLine); return 0 ;;  # Proceed with action
      [Nn]) echo "\nAborting..."; return 1 ;;   # Abort action
      *) echo -n " Invalid choice. Please press Y or N: " ;;
    esac
  fi
}

killport() {
  if [[ $pid ]]; then
    kill $pid
    echo killed process $pid
  else
    echo no process is listening on port $port
  fi
}

refresh_node() {
  npm install -g $(ls $(npm root -g))
}


tmuxattach() {
  tmux attach-session -t $(tmux ls | fzf | sed 's/:.*//')
}

alias ls='eza --git'
alias sedremovespace="sed -E '/^[[:space:]]*$/d;s/^[[:space:]]+//;s/[[:space:]]+$//'"

findAlias() {
  PS4='+%x:%I>' zsh -i -x -c '' |& grep $1
}

# launch-emulator() {
#   emulator=$(ls ~/.android/avd | grep avd | sed 's/\.avd//g' | fzf)
#   if [ "x$emulator" != "x" ]
#   then
#     echo "Launching $emulator"
#     QT_QPA_PLATFORM=xcb emulator @$emulator &!
#   fi
# }

unmount_drives() {
  local drive
  drive=$(udiskie-info -a | fzf)
  if [ "x$drive" != "x" ]
  then
    echo "Unmounting $drive"
    udisksctl unmount -b $drive && udisksctl power-off -b $drive
  fi
}

watchCalendar() {
  while true; do clear ; gcalcli calw --no-military --noweekend --details description ; sleep 600s; done
}

watchGithub() {
  while true; do clear; gh pr status; gh issue status; sleep 600s; done
}

pushwebsite() {
  pushover --title "Website" --url "$1" --message "$1"
}

pr-checkout() {
  jq_template='"'\
'#\(.number) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}

delete-branches() {
  local branches
  branches=$(
    git branch |
      grep --invert-match '\*' |
      cut -c 3- |
      fzf --multi --preview="git log {}"
  )

  if [[ -n "$branches" ]]; then
    print -r -- "$branches" | xargs git branch --delete --force
  fi
}

open-ebook() {
  epy "$(find $HOME/Calibre\ Library -name '*.epub' -o -name '*.azw3' -o -name '*.mobi' -o -name '*.epub3' -o -name '*.azw' | fzf)"
}

format_epoch_time() {
    if [[ $ZSH_OS == Darwin ]]; then
        date -r "$1" +%I:%M
    else
        date -d "@$1" +%I:%M
    fi
}

notify_pomo() {
    if [[ $ZSH_OS == Darwin ]]; then
        osascript -e 'on run argv' -e 'display notification (item 1 of argv) with title "pomo"' -e 'end run' "$*"
    else
        notify-send -u critical -i /usr/share/icons/Arc/status/128/messagebox_critical.png -a pomo "$*"
    fi
}

pomo() {
    arg1=$1
    shift
    args="$*"

    min=${arg1:?Example: pomo 15 Take a break}
    sec=$((min * 60))
    msg="${args:?Example: pomo 15 Take a break}"

    now=$(date +%s)
    timeout=$((now + sec))

    trap "rm /tmp/pomo" EXIT

    while [ "$(date +%s)" -lt "$timeout" ]; do
        clear

        echo "$(format_epoch_time "$timeout") $msg" > /tmp/pomo

        echo "$(date '+%I:%M') - $(format_epoch_time "$timeout") ${msg:?}" && sleep 10s
    done

    notify_pomo "${msg:?}"

    echo "Done ${msg:?}"
}

get-youtube-subtitles() {
  DIRECTORY=$(mktemp -d)

  pushd $DIRECTORY

  yt-dlp --quiet --write-sub --sub-format vtt --skip-download $1

  if [ "$(command ls -A ./)" ]; then
  else
    yt-dlp --quiet --write-auto-sub --sub-format vtt --skip-download $1
  fi

  cat * | grep : -v | awk '!seen[$0]++' | grep -v "^WEBVTT\|^Kind: cap\|^Language" | tr '\n' ' '

  popd
}

fix-punctuation() {
  recasepunc predict ~/.bin/checkpoint "$@" | sed "s/ ' //g" | sed 's/ ?/?/g'
}

#/ defaultpassword <keyword>: search default password from a keyword
defaultpassword() { curl -sS 'https://raw.githubusercontent.com/many-passwords/many-passwords/main/passwords.csv' | rg "$1|Vendor,Model" | column -t -s ',' }

# httpstatus: show HTTP code explanation, $1 HTTP code
httpstatus () { curl -i "https://httpstat.us/$1" }

# httpstatuslist: show list of HTTP codes
httpstatuslist () { curl -s 'https://httpstat.us/' | htmlq -t 'dl' | sedremovespace | awk 'NR%2{printf "%s ",$0;next}{print}' }

tinyurl()  {
    local u=$(curl -sS "https://tinyurl.com/create.php?source=index&alias=&url=$1" | grep '://tinyurl.com/' | grep 'target' | grep -E 'https://tinyurl.com/\w+' -o | head -1)
    echo -n "$u" | copy_clipboard
}

#/ unshorten <url>: reveal shortened URL
unshorten() { curl -sSL -I "$1" | grep 'Location: ' | awk -F ': ' '{print $2}' }

#/ synonym <word>: search for synonym of a word
synonym() { curl -sS https://www.thesaurus.com/browse/$1| htmlq -t 'script' | grep INITIAL_STATE | sed -E 's/.*INITIAL_STATE = //;s/;$//' | sed -E 's/:undefined,/:null,/g' | jq -r '.searchData.tunaApiData.posTabs[] | .definition as $definition | .pos as $pos | .synonyms | sort_by (.term) | .[] | select((.similarity | tonumber)>49) | "\($pos) \($definition):: \(.term)"' | awk -F"::" '{if ($1==prev) printf ",%s", $2; else printf "\n\n%s\n %s", $1, $2; prev=$1} END {print "\n"}' }

#/ timezone <city>: show timezone of a city
timezone() {
    local data
    data="$(curl -sSL "https://time.is/${1// /_}" -H 'Accept-Language: en-US,en' -A 'c')"
    htmlq -t '#clock0_bg' <<< "$data"
    htmlq -t '#dd' <<< "$data"
    htmlq -t '.keypoints' <<< "$data"
}

#/ cpu <keyword>: find CPU info from PassMark: Name; Mark; Rank; Value; Price
cpu () { curl -sS 'https://www.cpubenchmark.net/cpu_list.php' | grep 'cpu_lookup' | sed -e 's/<\/td><\/tr>/\n/g' -e 's/<tr.*multi=\w">//g' -e 's/<\/a><\/td><td>/; /g' -e 's/<\/td><td>/; /g' -e 's/<tr//g' -e 's/><td>//g' | awk -F '>' '{print $2}' | sed -e 's/<a href=.*//g' | grep -i "$1"}

# snykadvisor <name> <source>: get package info from Snyk Advisor
snykadvisor () {
    # $1: package name
    # $2: npm, python or docker
    local n="${1:-}"
    local s="${2:-npm}"
    local d len
    d="$(curl -sS "https://snyk.io/advisor/search?source=${s}&q=${n}" | htmlq '.package')"
    len="$(htmlq '.package' <<< "$d" | grep -c 'class="package"')"
    for (( i = 1; i <= len; i++ )); do
        printf '%b. \033[1m%b \033[34m%b\033[0m\033[0m\n' \
            "$i" \
            "$(htmlq -t '.package:nth-child('"$i"') .package-title' <<< "$d" | sedremovespace)" \
            "$(htmlq -t '.package:nth-child('"$i"') .number' <<< "$d" | sedremovespace | sed -E 's/ \/ 100//')"
        printf '\033[1;30m[%b] %b\033[0m\n' \
            "$(htmlq -t '.package:nth-child('"$i"') .package-history' <<< "$d" | sedremovespace | sed 'N;s/\n/ /')" \
            "$(htmlq -t '.package:nth-child('"$i"') .package-details p' <<< "$d" | sedremovespace)"
        printf '%b\n\n' "$(htmlq -t '.package:nth-child('"$i"') a' -a href <<< "$d")"
    done
}

transition-jira-issues() {
  SPRINT=$(jira mysprint)

  STATUS=$(echo $SPRINT | rg "WR" | awk -F \|  '{print $6}' | sort -u | fzf | xargs)

  declare TRANSITION
  declare VERSION

  echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue; do
    ISSUEVERSION=$(jira view $issue | rg fixVersions)

    if [ -z "$ISSUEVERSION" ]; then
      if [ -z "$VERSION" ]; then
        VERSION=$(jira releases WR | rg Android | fzf | sed s/.*://g | xargs)
      fi

      jira edit --noedit -ofixVersions="$VERSION" $issue
    fi

    if [ -z "$TRANSITION" ]; then
      TRANSITION=$(jira transitions $issue | fzf | sed s/.*://g | xargs)
    fi

    jira transition --noedit "$TRANSITION" $issue
  done
}

add-jira-fix-versions() {
  SPRINT=$(jira mysprint)

  VERSION=$(jira releases WR | rg Android | fzf | sed s/.*://g | xargs)

  echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue; do
    jira edit --noedit -ofixVersions="$VERSION" $issue
  done
}

add-missing-jira-fix-versions() {
  SPRINT=$(jira mysprint)

  STATUS=$(echo $SPRINT | rg "WR" | awk -F \|  '{print $6}' | sort -u | fzf)

  declare VERSION

  echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue; do
    ISSUEVERSION=$(jira view $issue | rg fixVersions)

    if [ -z "$ISSUEVERSION" ]; then
      if [ -z "$VERSION" ]; then
        VERSION=$(jira releases WR | rg Android | fzf | sed s/.*://g | xargs)
      fi

      jira edit --noedit -ofixVersions="$VERSION" $issue
    fi
  done
}

# Atlassian CLI Jira helpers. These intentionally avoid project-specific fields.
acli-jira-default-jql() {
  echo 'assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC'
}

acli-jira-format-issues() {
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
    items | select(type == "object") | [field("key") | text, field("status") | text, field("assignee") | text, field("summary") | text] | @tsv
  '
}

acli-jira-issues() {
  local jql="${*:-$(acli-jira-default-jql)}"
  acli jira workitem search --jql "$jql" --fields 'key,status,assignee,summary' --paginate --json |
    acli-jira-format-issues
}

acli-jira-list() {
  local jql="${*:-$(acli-jira-default-jql)}"
  acli-jira-issues "$jql" |
    column -t -s $'\t'
}

acli-jira-search() {
  local jql="${*:-$(acli-jira-default-jql)}"
  acli jira workitem search --jql "$jql" --fields 'key,status,assignee,summary' --paginate
}

acli-jira-mine() {
  acli-jira-list "$(acli-jira-default-jql)"
}

acli-jira-pick() {
  local jql="${*:-$(acli-jira-default-jql)}"
  acli-jira-issues "$jql" | fzf --delimiter=$'\t' --with-nth='1,2,3,4' --prompt='Jira issue: '
}

acli-jira-pick-key() {
  local selected
  selected="$(acli-jira-pick "$@")" || return
  awk -F $'\t' '{print $1}' <<< "$selected"
}

acli-jira-pick-keys() {
  local jql="${*:-$(acli-jira-default-jql)}"
  acli-jira-issues "$jql" |
    fzf --multi --delimiter=$'\t' --with-nth='1,2,3,4' --prompt='Jira issues: ' |
    awk -F $'\t' '{print $1}' |
    paste -sd, -
}

acli-jira-view() {
  local issue="${1:-$(acli-jira-pick-key)}"
  [[ -n "$issue" ]] && acli jira workitem view "$issue" --fields 'key,summary,status,assignee,reporter,description'
}

acli-jira-open() {
  local issue="${1:-$(acli-jira-pick-key)}"
  [[ -n "$issue" ]] && acli jira workitem view "$issue" --web
}

acli-jira-transition() {
  local keys status
  keys="$(acli-jira-pick-keys)" || return
  [[ -z "$keys" ]] && return
  status="$(printf 'To Do\nIn Progress\nIn Review\nDone\n' | fzf --print-query --prompt='Target status: ' | tail -1 | xargs)"
  [[ -n "$status" ]] && acli jira workitem transition --key "$keys" --status "$status" --yes
}

acli-jira-assign-me() {
  local keys
  keys="$(acli-jira-pick-keys)" || return
  [[ -n "$keys" ]] && acli jira workitem assign --key "$keys" --assignee '@me' --yes
}

acli-jira-comment() {
  local issue body
  issue="${1:-$(acli-jira-pick-key)}"
  [[ -z "$issue" ]] && return
  body="${*:2}"
  if [[ -z "$body" ]]; then
    acli jira workitem comment create --key "$issue" --editor
    return
  fi
  acli jira workitem comment create --key "$issue" --body "$body"
}

acli-jira-copy-key() {
  local issue="${1:-$(acli-jira-pick-key)}"
  [[ -n "$issue" ]] && echo -n "$issue" | copy_clipboard
}

acli-jira-branch() {
  local selected key summary branch
  selected="$(acli-jira-pick "$@")" || return
  [[ -z "$selected" ]] && return
  key="$(awk -F $'\t' '{print $1}' <<< "$selected")"
  summary="$(awk -F $'\t' '{print $4}' <<< "$selected")"
  branch="${key}-$(tr '[:upper:]' '[:lower:]' <<< "$summary" | sed -E 's/[^a-z0-9]+/-/g;s/^-//;s/-$//;s/-+/-/g' | cut -c1-60)"
  echo -n "$branch" | copy_clipboard
  echo "$branch"
}

if [[ -f /etc/arch-release ]]; then
  alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
  alias ua-update-all='export TMPFILE="$(mktemp)"; \
      sudo true; \
      rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
        && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
        && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
        && ua-drop-caches \
        && yay -Syyu --noconfirm'
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && path=($PYENV_ROOT/bin $path)
if command -v pyenv >/dev/null 2>&1; then
  pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
fi

# Command-not-found handler - suggests packages for missing commands
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Zoxide - smarter directory navigation with frecency
if command -v zoxide >/dev/null 2>&1; then
  z() {
    unset -f z zi
    eval "$(zoxide init zsh)"
    z "$@"
  }
  zi() {
    unset -f z zi
    eval "$(zoxide init zsh)"
    zi "$@"
  }
fi

## Android Dev CLI
# All Android functionality has been moved to 'adc' (Android Dev CLI)
# Repository: ~/Code/adc
# Binary: ~/.bin/adc
# Usage: adc help

# Keep Android Studio launcher (not in adc)
studio() {
  local gradle_root=$(find . -maxdepth 3 -name 'build.gradle' -o -name 'build.gradle.kts' | head -1 | xargs dirname)
  if [[ -n "$gradle_root" ]]; then
    if [[ $ZSH_OS == Darwin ]]; then
      open -a "Android Studio" "$gradle_root"
    else
      /opt/android-studio/bin/studio.sh "$gradle_root" &
    fi
  fi
}
