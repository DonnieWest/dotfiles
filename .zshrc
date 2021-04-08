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
setopt hist_expire_dups_first
setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history # share command history data

alias history='fc -l 1'

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

## Aliases

alias less='less -R'
alias grep='grep --color=auto'
alias ..='cd ../'
alias parallel='parallel --no-notice' # remove the citing notice
alias cp='cp -i'                    # prompt for overwrite
alias mv='mv -i'                    # prompt for overwrite
alias df='df -h'                    # human readable
alias du='du -h'                    # human readable
alias ls='ls -hF --color=tty'       # colour, readable sizes, indicator
alias ll='ls -hlF --color=tty'      # long format to show sizes
alias la='ls -AlF'                  # all but . and ..

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

source ~/.zsh_plugins.sh

ZSH_GIT_PROMPT_FORCE_BLANK=1
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
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export STEAM_RUNTIME=0

export EDITOR="nvim"

export JAVA_HOME="/usr/lib/jvm/default"
export STUDIO_JDK="/usr/lib/jvm/default"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=red"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Setup PATH

export PATH="$PATH:/usr/bin:/usr/sbin:/sbin:/usr/local/bin:/bin:/usr/local/games:/usr/games:$GRADLE_HOME/bin:$HOME/.cabal/bin:/usr/bin/core_perl"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"

export PATH="$PATH:$HOME/.config/graalvm/bin"
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
    bw get item "$(bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzf-tmux | awk '{print $(NF -0)}' | sed 's/\"//g')" | jq '.login.password' | sed 's/\"//g' | wl-copy
  fi
}

cheat() {
  curl cht.sh/$1
}

update_npm() {
  echo "Checking NPM global packages"
  output=$(ncu -g)
  lastLine=$(echo -n $output | tail -2 | head | tr -d "\n")
  echo $output
  if [ "$lastLine" != "All global packages are up-to-date :)" ]; then
    echo "Do you wish to update these packages?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) $(echo $lastLine); break;;
            No ) exit;;
        esac
    done
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

# Custom aliases
alias package-json-dependency-lint=pjdl

# source <(npx --shell-auto-fallback zsh)
command_not_found_handler() {
  # Do not run within a pipe
  if test ! -t 1; then
    >&2 echo "command not found: $1"
    return 127
  fi
  if which npx > /dev/null; then
    echo "$1 not found. Trying with npx..." >&2
  else
    return 127
  fi
  if ! [[ $1 =~ @ ]]; then
    npx --no-install "$@"
  else
    npx "$@"
  fi
  return $?
}

alias ls='exa'
alias filpidcat='pidcat -i EGL_emulation -i HostConnection -i GnssHAL_GnssInterface -i android.os.Debug -i netmgr -i Phenix -i chatty -i WorkerManager -i ResolverController -i AppOps -i wifi_forwarder -i KeyguardClockSwitch -i memtrack -i GCoreFlp -i audio_hw_generic -i BeaconBle -i InputReader -i gralloc_ranchu'

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
  avdmanager list avd | grep "Name:" | awk '{ print $2 }' | fzf -m | while read emulator; do
    emulator "@${emulator%.*}" 1>/dev/null 2>/dev/null &!
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
alias git=hub

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

