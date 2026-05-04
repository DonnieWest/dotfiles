# If running from tty1 start sway
if [ "$(uname)" = "Darwin" ]; then
  export BROWSER=open
else
  export BROWSER=firefox-developer-edition
fi

if [ "$(uname)" = "Linux" ] && [ "$(tty)" = "/dev/tty1" ]; then
  export WLR_RENDERER=vulkan
	exec sway
fi
