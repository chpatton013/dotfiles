export CLICOLOR=TRUE

if [ -f ~/.config/X/xmodmap ]; then
   xmodmap ~/.config/X/xmodmap
fi

if [ -f ~/.config/X/Xresources.xrdb ]; then
   xrdb -merge ~/.config/X/Xresources.xrdb
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
