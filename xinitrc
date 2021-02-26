#/bin/sh
setxkbmap -option ctrl:nocaps
xset r rate 200 60
xmodmap -e "keycode 49 = Multi_key"
numlockx off;numlockx on

if [ -e "$HOME/.xinitrc_local" ]; then
    # Typically, adapt video output to local configuration
    # xrandr --newmode 4k 712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
    # xrandr --addmode Virtual1 4k
    # xrandr --output Virtual1 --mode 4k
    source "$HOME/.xinitrc_local"
fi

exec i3
