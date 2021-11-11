#!/usr/bin/env bash

# pulseaudio-ctl up ; pkill -RTMIN+1 i3blocks
# pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5% ; pkill -RTMIN+1 i3blocks

# amixer -c 0 set PCM 5%+ ; pkill -RTMIN+1 i3blocks
ponymix increase 5 ; pkill -SIGUSR1 i3status-rs
