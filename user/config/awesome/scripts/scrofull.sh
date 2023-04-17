#!/bin/bash
scrot --quality=100 --thumb='160x90' --file=$HOME'/table/Media/Pictures/screenshots/scrot_%Y-%m-%d %H%M%S.png' --exec='notify-send "A Fullscreenshot has been taken." -t 1800 --icon="$m" ; rm "$m"'

# Takes a full screenshot and send notification.
# The '$m' refers to a thumbnail file, which is deleted instantly after of use.
# --quality doesn't seem to do much, but added it just in case.
