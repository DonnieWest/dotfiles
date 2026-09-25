# If running from tty1 start sway
PROFILE_OS=${ZSH_OS:-${OSTYPE%%-*}}
[ -n "$PROFILE_OS" ] || PROFILE_OS=$(uname)

case "$PROFILE_OS" in
  Darwin|darwin*) PROFILE_OS=Darwin ;;
  Linux|linux*) PROFILE_OS=Linux ;;
esac

if [ "$PROFILE_OS" = "Darwin" ]; then
  export BROWSER=open
else
  export BROWSER=firefox-developer-edition
fi

export SDKMAN_DIR="$HOME/.sdkman"
if [ -d "$SDKMAN_DIR/candidates/java/current" ]; then
  export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
elif [ "$PROFILE_OS" = "Darwin" ] && [ -d /opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home ]; then
  export JAVA_HOME=/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home
fi
[ -n "${JAVA_HOME:-}" ] && export PATH="$JAVA_HOME/bin:$PATH"

if [ "$PROFILE_OS" = "Linux" ] && [ "$(tty)" = "/dev/tty1" ]; then
  "$HOME/.bin/apply-host-config"
  export GTK2_RC_FILES="${XDG_CACHE_HOME:-$HOME/.cache}/igneo676-host-config/gtkrc-2.0"
  export PATH="$HOME/.bin:$PATH"
  export WLR_RENDERER=vulkan
	exec sway
fi

unset PROFILE_OS


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
