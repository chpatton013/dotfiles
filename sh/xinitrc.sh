#!/usr/bin/env sh

if [ -f ~/.variables ]; then
   . ~/.variables
fi

if [ -f ~/.config/X/xmodmap ]; then
   xmodmap ~/.config/X/xmodmap
fi

if [ -f ~/.config/X/Xresources.xrdb ]; then
   xrdb -merge ~/.config/X/Xresources.xrdb
fi

if [ -f ~/.Xresources ]; then
   xrdb -merge ~/.Xresources
fi

if [ -f ~/.themes/solarized/xresources ]; then
   xrdb -merge ~/.themes/solarized/xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
   for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
   done
   unset f
fi

if [ -d ~/.wallpaper/ ] && [ -f ~/.background ]; then
   sh ~/.background &
fi

if which xscreensaver &> /dev/null; then
   xscreensaver -no-splash &
fi

if which xsetroot &> /dev/null; then
   xsetroot -cursor_name left_ptr &
fi

case $1 in
   i3)      exec i3;;
   lxde)    exec startlxde;;
   gnome)   exec gnome-session;;
   kde)     exec startkde;;
   *)       exec i3;;
esac
