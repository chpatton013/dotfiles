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

if [ -f ~/.themes/solarized/xresources ]; then
   xrdb -merge ~/.themes/solarized/xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
   for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
   done
   unset f
fi

case $1 in
   i3) exec i3;;
   lxde) exec startlxde;;
   *);;
esac
