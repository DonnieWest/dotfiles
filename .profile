# If running from tty1 start sway
if [ "$(uname)" = "Darwin" ]; then
  export BROWSER=open
else
  export BROWSER=firefox-developer-edition
fi

export SDKMAN_DIR="$HOME/.sdkman"
export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
export PATH="$JAVA_HOME/bin:$PATH"

if [ "$(uname)" = "Linux" ] && [ "$(tty)" = "/dev/tty1" ]; then
  "$HOME/.bin/apply-host-config"
  export GTK2_RC_FILES="${XDG_CACHE_HOME:-$HOME/.cache}/igneo676-host-config/gtkrc-2.0"
  export PATH="$HOME/.bin:$PATH"
  export WLR_RENDERER=vulkan
	exec sway
fi


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
