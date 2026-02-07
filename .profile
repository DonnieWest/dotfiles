# If running from tty1 start sway
if [ "$(tty)" = "/dev/tty1" ]; then
  export WLR_RENDERER=vulkan
	exec sway
fi
