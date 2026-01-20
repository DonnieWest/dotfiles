source ~/.profile

autoload -Uz compinit promptinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;
promptinit

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

alias history='fc -l 1'
alias docker='podman'
alias docker-compose='podman-compose'

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
zstyle ':completion::complete:*' cache-path $ZSH/cache/
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
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

# Start the gpg-agent if not already running
if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
  gpg-connect-agent /bye >/dev/null 2>&1
fi

# Set GPG TTY
export GPG_TTY=$(tty)

# Refresh gpg-agent tty in case user switches into an X session
gpg-connect-agent updatestartuptty /bye >/dev/null

## Misc

# Increase limit of files able to be handled by TernJS
ulimit -n 2048

# Activate FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ssh='TERM=xterm-256color ssh'
# Use custom dircolors

# clone a plugin, identify its init file, source it, and add it to your fpath
function plugin-load() {
  local repo plugin_name plugin_dir initfile initfiles
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  for repo in $@; do
    plugin_name=${repo:t}
    plugin_dir=$ZPLUGINDIR/$plugin_name
    initfile=$plugin_dir/$plugin_name.plugin.zsh
    if [[ ! -d $plugin_dir ]]; then
      echo "Cloning $repo"
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugin_dir
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugin_dir/*.plugin.{z,}sh(N) $plugin_dir/*.{z,}sh{-theme,}(N))
      [[ ${#initfiles[@]} -gt 0 ]] || { echo >&2 "Plugin has no init file '$repo'." && continue }
      ln -sf "${initfiles[1]}" "$initfile"
    fi
    fpath+=$plugin_dir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

function plugin-update () {
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

function plugin-compile() {
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  autoload -U zrecompile
  local f
  for f in $ZPLUGINDIR/**/*.zsh{,-theme}(N); do
    zrecompile -pq "$f"
  done
}

# make list of the Zsh plugins you use
plugins=(
  # romkatv/zsh-defer
  woefe/git-prompt.zsh

  zsh-users/zsh-history-substring-search
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zdharma-continuum/fast-syntax-highlighting
  mafredri/zsh-async

  jsahlen/tmux-vim-integration.plugin.zsh
  laggardkernel/git-ignore

  gradle/gradle-completion
  greymd/docker-zsh-completion

  lukechilds/zsh-better-npm-completion
  chrisands/zsh-yarn-completion
)

plugin-load $plugins

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
RPS1='%{$fg[white]%}%2~$(gitprompt) %{$fg_bold[blue]%}%{$reset_color%}'

# Setup Env variables
export N_PREFIX=$HOME/.config/n
export GRADLE_HOME="$HOME/.gradle"
export ANDROID_HOME="$HOME/.android-sdk-linux"
export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
export POWERLINE_CONFIG_COMMAND="$HOME/.local/bin/powerline-config"
export STEAM_RUNTIME=0
export GRAALVM_HOME="$HOME/.config/graalvm-ce"


export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

export EDITOR="nvim"

export JAVA_HOME="/usr/lib/jvm/default"
export STUDIO_JDK="/usr/lib/jvm/default"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=red"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
export JDTLS_JVM_ARGS="-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.36/lombok-1.18.36.jar"

# Setup PATH

export PATH="$PATH:/usr/bin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/local/games:/usr/games:$GRADLE_HOME/bin:$HOME/.cabal/bin:/usr/bin/core_perl"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

export PATH="$PATH:$GRAALVM_HOME/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.config/n/bin:$PATH"
export PATH="$HOME/.config/npm/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

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

source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh
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

pass() {
  if hash bw 2>/dev/null; then
    bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzy | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | wl-copy
  fi
}

b-pass() {
  if hash rbw 2>/dev/null; then
    local selected
    selected=$(rbw list | fzf --prompt="Search password: " --bind "change:reload:rbw search {q} || true")
    if [ -n "$selected" ]; then
      rbw get "$selected" | wl-copy
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
alias filpidcat='pidcat -i EGL_emulation -i HostConnection -i GnssHAL_GnssInterface -i android.os.Debug -i netmgr -i Phenix -i chatty -i WorkerManager -i ResolverController -i AppOps -i wifi_forwarder -i KeyguardClockSwitch -i memtrack -i GCoreFlp -i audio_hw_generic -i BeaconBle -i InputReader -i gralloc_ranchu'

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

connectToDevice() {
  adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 -m | awk '{ print $1 }' | while read device; do
    scrcpy -s $device -p $(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()') &!
  done
}

launchEmulator() {
  emulator -list-avds | fzf -m | while read emulator; do
    QT_QPA_PLATFORM=xcb emulator -gpu host "@${emulator%.*}" 1>/dev/null 2>/dev/null &!
  done
}

recordAndroidDevice() {
  adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 -m | awk '{ print $1 }' | while read device; do
    adb -s $device shell screenrecord /sdcard/$device.mp4
    adb -s $device pull /sdcard/$device.mp4 ./
  done
}

launchAPK() {
  ./gradlew assembleDebug
  adb devices -l | tail -n +2 | sed '/^\s*$/d' | awk '{ print $1, $5 }' | sed -e 's/model://g' | awk '{ print $1 }'  | fzf -1 -m | while read device; do
    adb -s $device install-multiple -r -d $(find ./ -name "*.apk" | tr "\n" " " | tr "//" "/")

    apk=$(find ./*/build/** -name "app-debug.apk")

    mainId=$(apkanalyzer manifest print $apk | xmlstarlet sel -t -c "///activity[intent-filter/action[@android:name='android.intent.action.MAIN']]" | xmlstarlet sel -t -c "string(//*[local-name()='activity']/@android:name)")

    appId=$(apkanalyzer manifest application-id $apk)

    if [ "$appId/$mainId" != "/" ]
    then
      adb -s $device shell am start -n $appId/$mainId -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
    fi
  done
}

launchReleaseAPK() {
  ./gradlew assembleRelease
  adb devices -l | tail -n +2 | sed '/^\s*$/d' | awk '{ print $1, $5 }' | sed -e 's/model://g' | awk '{ print $1 }'  | fzf -1 -m | while read device; do
    adb -s $device install-multiple -r -d $(find ./ -name "*.apk" | tr "\n" " " | tr "//" "/")
    appId=$(grep -r --include=\*.{gradle,kts} 'applicationId "' ./ | awk '{ print $3 }' | sed -e "s/\"//g")

    if [ "x$appId" == "x" ]
    then
      appId=$(grep -r --include=\*.{gradle,kts} 'applicationId' ./ | awk '{ print $4 }' | sed -e "s/\"//g")
    fi

    if [ "x$appId" != "x" ]
    then
      adb -s $device shell monkey -p "$appId" 1 2>/dev/null >/dev/null
    fi
  done
}

watchCalendar() {
  while true; do clear ; gcalcli calw --no-military --noweekend --details description ; sleep 600s; done
}

watchGithub() {
  while true; do clear; gh pr status; gh issue status; sleep 600s; done
}

logsForDevice() {
  device=$(adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 | awk '{ print $1 }') && pidcat -s $device --current
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
  git branch |
    grep --invert-match '\*' |
    cut -c 3- |
    fzf --multi --preview="git log {}" |
    xargs --no-run-if-empty git branch --delete --force
}

open-ebook() {
  epy "$(find $HOME/Calibre\ Library -name '*.epub' -o -name '*.azw3' -o -name '*.mobi' -o -name '*.epub3' -o -name '*.azw' | fzf)"
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

        echo "$(date -d "@$timeout" +%I:%M) $msg" > /tmp/pomo

        echo "$(date '+%I:%M') - $(date -d "@$timeout" +%I:%M) ${msg:?}" && sleep 10s
    done

    notify-send -u critical -i /usr/share/icons/Arc/status/128/messagebox_critical.png -a pomo "${msg:?}"

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
    echo -n "$u" | wl-copy
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

alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syyu --noconfirm'

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Android Studio quick launcher - auto-detects Gradle projects
studio() {
  local gradle_root=$(find . -maxdepth 3 -name 'build.gradle' -o -name 'build.gradle.kts' | head -1 | xargs dirname)
  [[ -n "$gradle_root" ]] && /opt/android-studio/bin/studio.sh "$gradle_root" &
}

# React Native - Device management
list-android-devices() {
  echo "Connected devices:"
  adb devices -l
  echo "\nAvailable emulators:"
  emulator -list-avds
}

android-reverse() {
  # Set up reverse proxy for Metro bundler
  adb reverse tcp:8081 tcp:8081
  echo "✓ Metro bundler port forwarded (8081)"
}

rn-shake() {
  # Open React Native dev menu
  adb shell input keyevent 82
}

rn-reload() {
  # Reload React Native app
  adb shell input text "RR"
}

# React Native - Logging
rn-logs() {
  adb logcat -c && adb logcat *:S ReactNative:V ReactNativeJS:V
}

# React Native - Bundle size analysis
rn-bundle-size() {
  npx react-native bundle \
    --platform android \
    --dev false \
    --entry-file index.js \
    --bundle-output /tmp/bundle.js \
    --assets-dest /tmp/assets

  echo "\nBundle size:"
  du -h /tmp/bundle.js

  echo "\nDetailed breakdown (requires source-map-explorer):"
  npx source-map-explorer /tmp/bundle.js 2>/dev/null || echo "Install with: npm i -g source-map-explorer"
}

# Watchman management (React Native uses this heavily)
watchman-status() {
  watchman watch-list
}

watchman-reset() {
  watchman shutdown-server
  watchman watch-del-all
  echo "Watchman reset complete"
}

# Maestro - Mobile UI testing
maestro-test() {
  local device=$(adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
  if [ -n "$device" ]; then
    local flow=$(find . -name "*.yaml" -o -name "*.yml" | grep -iE "(maestro|flow|test)" | fzf --prompt="Select test flow: ")
    if [ -n "$flow" ]; then
      echo "Running maestro test on $device..."
      maestro test --device $device "$flow"
    fi
  fi
}

maestro-studio() {
  local device=$(adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
  if [ -n "$device" ]; then
    echo "Launching maestro studio on $device..."
    maestro studio --device $device
  fi
}

maestro-record() {
  local device=$(adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
  if [ -n "$device" ]; then
    echo "Recording flow on $device... (Ctrl+C to stop)"
    maestro record --device $device
  fi
}

# Command-not-found handler - suggests packages for missing commands
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh

# Zoxide - smarter directory navigation with frecency
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
