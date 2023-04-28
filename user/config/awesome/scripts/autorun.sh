#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run krunner -d
run nm-applet
run mictray
run volumeicon
run kdeconnect-indicator
run picom
run parcellite

pkill kglobalaccel5

# It sort of tries to queue the icons,
# top the bottom as left to right.
# Honestly, don't bother.
