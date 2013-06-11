#!/usr/bin/env sh

if [ -d ~/.wallpaper/ ]; then
   DISPLAY=:0.0 feh --bg-fill "$(find ~/.wallpaper/ | shuf -n1)"
fi
