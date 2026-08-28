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
  export WLR_RENDERER=vulkan
	exec sway
fi
