# Source profile (sway startup logic)
if test (tty) = "/dev/tty1"
    exec sway
end

## Options
set -g fish_greeting ''

## Environment Variables

set -gx CLICOLOR 1
set -gx EDITOR nvim

# Development paths
set -gx N_PREFIX $HOME/.config/n
set -gx GRADLE_HOME $HOME/.gradle
set -gx ANDROID_HOME $HOME/.android-sdk-linux
set -gx ANDROID_EMULATOR_USE_SYSTEM_LIBS 1
set -gx POWERLINE_CONFIG_COMMAND $HOME/.local/bin/powerline-config
set -gx STEAM_RUNTIME 0
set -gx GRAALVM_HOME $HOME/.config/graalvm-ce
set -gx JAVA_HOME /usr/lib/jvm/default
set -gx STUDIO_JDK /usr/lib/jvm/default
set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/podman/podman.sock
set -gx JDTLS_JVM_ARGS "-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.36/lombok-1.18.36.jar"
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

# Python
set -gx PYENV_ROOT $HOME/.pyenv

## PATH Setup
fish_add_path /usr/local/games
fish_add_path /usr/games
fish_add_path $GRADLE_HOME/bin
fish_add_path $HOME/.cabal/bin
fish_add_path /usr/bin/core_perl
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/tools/bin
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $GRAALVM_HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/n/bin
fish_add_path $HOME/.config/npm/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.bin
fish_add_path $HOME/.npm-global/bin
fish_add_path $HOME/.pub-cache/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.dotnet/tools
fish_add_path $HOME/go/bin
fish_add_path $HOME/.luarocks/bin
fish_add_path $HOME/.deno/bin
fish_add_path $HOME/.babashka/bbin/bin
fish_add_path $HOME/.tmux/plugins/tmuxifier/bin
fish_add_path $PYENV_ROOT/bin

## GPG Agent
set -e SSH_AGENT_PID
if test "$gnupg_SSH_AUTH_SOCK_by" != "$fish_pid"
    set -gx SSH_AUTH_SOCK /run/user/$UID/gnupg/S.gpg-agent.ssh
end

# Start the gpg-agent if not already running
if not pgrep -x -u $USER gpg-agent >/dev/null 2>&1
    gpg-connect-agent /bye >/dev/null 2>&1
end

# Set GPG TTY
set -gx GPG_TTY (tty)

# Refresh gpg-agent tty
gpg-connect-agent updatestartuptty /bye >/dev/null

## Misc Settings

# Increase file limit for TernJS
ulimit -n 2048

## Aliases

alias history='history --max=500000'
alias docker='podman'
alias docker-compose='podman-compose'
alias less='less -R'
alias grep='grep --color=auto'
alias ..='cd ../'
alias parallel='parallel --no-notice'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'
alias du='du -h'
alias ls='eza --git'
alias ll='eza --git -l'
alias la='eza --git -la'
alias tree='eza --tree'
alias ssh='TERM=xterm-256color ssh'
alias filpidcat='pidcat -i EGL_emulation -i HostConnection -i GnssHAL_GnssInterface -i android.os.Debug -i netmgr -i Phenix -i chatty -i WorkerManager -i ResolverController -i AppOps -i wifi_forwarder -i KeyguardClockSwitch -i memtrack -i GCoreFlp -i audio_hw_generic -i BeaconBle -i InputReader -i gralloc_ranchu'
alias sedremovespace="sed -E '/^[[:space:]]*\$/d;s/^[[:space:]]+//;s/[[:space:]]+\$//'"
alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syyu --noconfirm'

## Functions

function sn
    set version (n lsr --all | fzf)
    if test -n "$version"
        echo "Switching to Node $version"
        n $version
    end
end

function pass
    if command -v bw >/dev/null
        bw get item (bw list items | jq '.[] | "\(.name) | username: \(.login.username) | id: \(.id)" ' | fzy | awk '{print $(NF -0)}' | sed 's/"//g') | jq '.login.password' | sed 's/"//g' | wl-copy
    end
end

function cheat
    curl cht.sh/$argv[1]
end

function bunx
    bun x $argv
end

function killport
    set port $argv[1]
    set pid (lsof -ti:$port)
    if test -n "$pid"
        kill $pid
        echo "killed process $pid"
    else
        echo "no process is listening on port $port"
    end
end

function refresh_node
    npm install -g (ls (npm root -g))
end

function tmuxattach
    tmux attach-session -t (tmux ls | fzf | sed 's/:.*//')
end

function findAlias
    fish -d $argv[1]
end

function unmount_drives
    set drive (udiskie-info -a | fzf)
    if test -n "$drive"
        echo "Unmounting $drive"
        udisksctl unmount -b $drive; and udisksctl power-off -b $drive
    end
end

function connectToDevice
    adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 -m | awk '{ print $1 }' | while read device
        scrcpy -s $device -p (python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()') &
    end
end

function launchEmulator
    emulator -list-avds | fzf -m | while read emulator
        QT_QPA_PLATFORM=xcb emulator -gpu host "@"(string trim -r -c .avd $emulator) >/dev/null 2>/dev/null &
    end
end

function recordAndroidDevice
    adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 -m | awk '{ print $1 }' | while read device
        adb -s $device shell screenrecord /sdcard/$device.mp4
        adb -s $device pull /sdcard/$device.mp4 ./
    end
end

function launchAPK
    ./gradlew assembleDebug
    adb devices -l | tail -n +2 | sed '/^\s*$/d' | awk '{ print $1, $5 }' | sed -e 's/model://g' | awk '{ print $1 }' | fzf -1 -m | while read device
        adb -s $device install-multiple -r -d (find ./ -name "*.apk" | tr "\n" " " | tr "//" "/")

        set apk (find ./*/build/** -name "app-debug.apk")

        set mainId (apkanalyzer manifest print $apk | xmlstarlet sel -t -c "///activity[intent-filter/action[@android:name='android.intent.action.MAIN']]" | xmlstarlet sel -t -c "string(//*[local-name()='activity']/@android:name)")

        set appId (apkanalyzer manifest application-id $apk)

        if test "$appId/$mainId" != "/"
            adb -s $device shell am start -n $appId/$mainId -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
        end
    end
end

function launchReleaseAPK
    ./gradlew assembleRelease
    adb devices -l | tail -n +2 | sed '/^\s*$/d' | awk '{ print $1, $5 }' | sed -e 's/model://g' | awk '{ print $1 }' | fzf -1 -m | while read device
        adb -s $device install-multiple -r -d (find ./ -name "*.apk" | tr "\n" " " | tr "//" "/")
        set appId (grep -r --include=\*.{gradle,kts} 'applicationId "' ./ | awk '{ print $3 }' | sed -e "s/\"//g")

        if test -z "$appId"
            set appId (grep -r --include=\*.{gradle,kts} 'applicationId' ./ | awk '{ print $4 }' | sed -e "s/\"//g")
        end

        if test -n "$appId"
            adb -s $device shell monkey -p "$appId" 1 2>/dev/null >/dev/null
        end
    end
end

function watchCalendar
    while true
        clear
        gcalcli calw --no-military --noweekend --details description
        sleep 600s
    end
end

function watchGithub
    while true
        clear
        gh pr status
        gh issue status
        sleep 600s
    end
end

function logsForDevice
    set device (adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 | awk '{ print $1 }')
    and pidcat -s $device --current
end

function pushwebsite
    pushover --title "Website" --url "$argv[1]" --message "$argv[1]"
end

function pr-checkout
    set jq_template '"#\(.number) - \(.title)\t Author: \(.user.login)\nCreated: \(.created_at)\nUpdated: \(.updated_at)\n\n\(.body)"'

    set pr_number (gh api 'repos/:owner/:repo/pulls' | jq ".[] | $jq_template" | sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' | fzf --with-nth=1 --delimiter='\t' --preview='echo -e {2}' --preview-window=top:wrap | sed 's/^#\([0-9]\+\).*/\1/')

    if test -n "$pr_number"
        gh pr checkout "$pr_number"
    end
end

function delete-branches
    git branch | grep --invert-match '\*' | cut -c 3- | fzf --multi --preview="git log {}" | xargs --no-run-if-empty git branch --delete --force
end

function open-ebook
    epy (find $HOME/Calibre\ Library -name '*.epub' -o -name '*.azw3' -o -name '*.mobi' -o -name '*.epub3' -o -name '*.azw' | fzf)
end

function pomo
    set min $argv[1]
    set msg $argv[2..-1]

    if test -z "$min"
        echo "Example: pomo 15 Take a break"
        return 1
    end

    if test -z "$msg"
        echo "Example: pomo 15 Take a break"
        return 1
    end

    set sec (math "$min * 60")
    set now (date +%s)
    set timeout (math "$now + $sec")

    while test (date +%s) -lt $timeout
        clear
        echo (date -d "@$timeout" +%I:%M) $msg >/tmp/pomo
        echo (date '+%I:%M') - (date -d "@$timeout" +%I:%M) $msg
        sleep 10s
    end

    notify-send -u critical -i /usr/share/icons/Arc/status/128/messagebox_critical.png -a pomo "$msg"
    echo "Done $msg"
    rm -f /tmp/pomo
end

function get-youtube-subtitles
    set DIRECTORY (mktemp -d)

    pushd $DIRECTORY

    yt-dlp --quiet --write-sub --sub-format vtt --skip-download $argv[1]

    if test -z (command ls -A ./)
        yt-dlp --quiet --write-auto-sub --sub-format vtt --skip-download $argv[1]
    end

    cat * | grep : -v | awk '!seen[$0]++' | grep -v "^WEBVTT\|^Kind: cap\|^Language" | tr '\n' ' '

    popd
end

function fix-punctuation
    recasepunc predict ~/.bin/checkpoint $argv | sed "s/ ' //g" | sed 's/ ?/?/g'
end

function defaultpassword
    curl -sS 'https://raw.githubusercontent.com/many-passwords/many-passwords/main/passwords.csv' | rg "$argv[1]|Vendor,Model" | column -t -s ','
end

function httpstatus
    curl -i "https://httpstat.us/$argv[1]"
end

function httpstatuslist
    curl -s 'https://httpstat.us/' | htmlq -t 'dl' | sedremovespace | awk 'NR%2{printf "%s ",$0;next}{print}'
end

function tinyurl
    set u (curl -sS "https://tinyurl.com/create.php?source=index&alias=&url=$argv[1]" | grep '://tinyurl.com/' | grep 'target' | grep -E 'https://tinyurl.com/\w+' -o | head -1)
    echo -n "$u" | wl-copy
end

function unshorten
    curl -sSL -I "$argv[1]" | grep 'Location: ' | awk -F ': ' '{print $2}'
end

function synonym
    curl -sS https://www.thesaurus.com/browse/$argv[1] | htmlq -t 'script' | grep INITIAL_STATE | sed -E 's/.*INITIAL_STATE = //;s/;$//' | sed -E 's/:undefined,/:null,/g' | jq -r '.searchData.tunaApiData.posTabs[] | .definition as $definition | .pos as $pos | .synonyms | sort_by (.term) | .[] | select((.similarity | tonumber)>49) | "\($pos) \($definition):: \(.term)"' | awk -F"::" '{if ($1==prev) printf ",%s", $2; else printf "\n\n%s\n %s", $1, $2; prev=$1} END {print "\n"}'
end

function timezone
    set data (curl -sSL "https://time.is/"(string replace -a ' ' '_' $argv[1]) -H 'Accept-Language: en-US,en' -A 'c')
    echo $data | htmlq -t '#clock0_bg'
    echo $data | htmlq -t '#dd'
    echo $data | htmlq -t '.keypoints'
end

function cpu
    curl -sS 'https://www.cpubenchmark.net/cpu_list.php' | grep 'cpu_lookup' | sed -e 's/<\/td><\/tr>/\n/g' -e 's/<tr.*multi=\w">//g' -e 's/<\/a><\/td><td>/; /g' -e 's/<\/td><td>/; /g' -e 's/<tr//g' -e 's/><td>//g' | awk -F '>' '{print $2}' | sed -e 's/<a href=.*//g' | grep -i "$argv[1]"
end

function snykadvisor
    set n "$argv[1]"
    set s "$argv[2]"
    if test -z "$s"
        set s "npm"
    end

    set d (curl -sS "https://snyk.io/advisor/search?source=$s&q=$n" | htmlq '.package')
    set len (echo $d | htmlq '.package' | grep -c 'class="package"')

    for i in (seq 1 $len)
        printf '%b. \033[1m%b \033[34m%b\033[0m\033[0m\n' \
            "$i" \
            (echo $d | htmlq -t ".package:nth-child($i) .package-title" | sedremovespace) \
            (echo $d | htmlq -t ".package:nth-child($i) .number" | sedremovespace | sed -E 's/ \/ 100//')
        printf '\033[1;30m[%b] %b\033[0m\n' \
            (echo $d | htmlq -t ".package:nth-child($i) .package-history" | sedremovespace | sed 'N;s/\n/ /') \
            (echo $d | htmlq -t ".package:nth-child($i) .package-details p" | sedremovespace)
        printf '%b\n\n' (echo $d | htmlq -t ".package:nth-child($i) a" -a href)
    end
end

function transition-jira-issues
    set SPRINT (jira mysprint)

    set STATUS (echo $SPRINT | rg "WR" | awk -F \| '{print $6}' | sort -u | fzf | xargs)

    set TRANSITION ""
    set VERSION ""

    echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue
        set ISSUEVERSION (jira view $issue | rg fixVersions)

        if test -z "$ISSUEVERSION"
            if test -z "$VERSION"
                set VERSION (jira releases WR | rg Android | fzf | sed s/.*://g | xargs)
            end

            jira edit --noedit -ofixVersions="$VERSION" $issue
        end

        if test -z "$TRANSITION"
            set TRANSITION (jira transitions $issue | fzf | sed s/.*://g | xargs)
        end

        jira transition --noedit "$TRANSITION" $issue
    end
end

function add-jira-fix-versions
    set SPRINT (jira mysprint)

    set VERSION (jira releases WR | rg Android | fzf | sed s/.*://g | xargs)

    echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue
        jira edit --noedit -ofixVersions="$VERSION" $issue
    end
end

function add-missing-jira-fix-versions
    set SPRINT (jira mysprint)

    set STATUS (echo $SPRINT | rg "WR" | awk -F \| '{print $6}' | sort -u | fzf)

    set VERSION ""

    echo $SPRINT | rg "WR" | rg $STATUS | awk -F \| '{print $2}' | fzf --multi | while read -r issue
        set ISSUEVERSION (jira view $issue | rg fixVersions)

        if test -z "$ISSUEVERSION"
            if test -z "$VERSION"
                set VERSION (jira releases WR | rg Android | fzf | sed s/.*://g | xargs)
            end

            jira edit --noedit -ofixVersions="$VERSION" $issue
        end
    end
end

function studio
    set gradle_root (find . -maxdepth 3 -name 'build.gradle' -o -name 'build.gradle.kts' | head -1 | xargs dirname)
    if test -n "$gradle_root"
        /opt/android-studio/bin/studio.sh "$gradle_root" &
    end
end

function list-android-devices
    echo "Connected devices:"
    adb devices -l
    echo "\nAvailable emulators:"
    emulator -list-avds
end

function android-reverse
    adb reverse tcp:8081 tcp:8081
    echo "✓ Metro bundler port forwarded (8081)"
end

function rn-shake
    adb shell input keyevent 82
end

function rn-reload
    adb shell input text "RR"
end

function rn-logs
    adb logcat -c; and adb logcat '*:S' ReactNative:V ReactNativeJS:V
end

function rn-bundle-size
    npx react-native bundle \
        --platform android \
        --dev false \
        --entry-file index.js \
        --bundle-output /tmp/bundle.js \
        --assets-dest /tmp/assets

    echo "\nBundle size:"
    du -h /tmp/bundle.js

    echo "\nDetailed breakdown (requires source-map-explorer):"
    npx source-map-explorer /tmp/bundle.js 2>/dev/null; or echo "Install with: npm i -g source-map-explorer"
end

function watchman-status
    watchman watch-list
end

function watchman-reset
    watchman shutdown-server
    watchman watch-del-all
    echo "Watchman reset complete"
end

## Maestro - Mobile UI testing

function maestro-test
    set device (adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
    if test -n "$device"
        set flow (find . -name "*.yaml" -o -name "*.yml" | grep -iE "(maestro|flow|test)" | fzf --prompt="Select test flow: ")
        if test -n "$flow"
            echo "Running maestro test on $device..."
            maestro test --device $device "$flow"
        end
    end
end

function maestro-studio
    set device (adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
    if test -n "$device"
        echo "Launching maestro studio on $device..."
        maestro studio --device $device
    end
end

function maestro-record
    set device (adb devices | tail -n +2 | sed '/^\s*$/d' | fzf -1 --prompt="Select device: " | awk '{ print $1 }')
    if test -n "$device"
        echo "Recording flow on $device... (Ctrl+C to stop)"
        maestro record --device $device
    end
end

## Interactive session setup
if status is-interactive
    # FZF
    if test -f ~/.config/fish/fzf.fish
        source ~/.config/fish/fzf.fish
    end

    # Pyenv
    if command -v pyenv >/dev/null
        pyenv init - | source
    end

    # Zoxide
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end

    # ChRuby
    if test -f /usr/share/chruby/chruby.fish
        source /usr/share/chruby/chruby.fish
        source /usr/share/chruby/auto.fish
        set -g RUBIES /opt/ruby* $HOME/.rubies/*
    end

    # Command-not-found handler
    if test -f /usr/share/doc/pkgfile/command-not-found.fish
        source /usr/share/doc/pkgfile/command-not-found.fish
    end
end
