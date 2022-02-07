#/bin/sh
xset r rate 200 60
numlockx off;numlockx on

setxkbmap -layout us -variant altgr-intl
# setxkbmap -layout fr -variant latin9

# ² as compose key
# xmodmap -e "keycode 49 = Multi_key"

# ScrollLock as compose key
xmodmap -e "keycode 78 = Multi_key"

if [ -e "$HOME/.xinitrc_local" ]; then
    # Typically, adapt video output to local configuration
    # xrandr --newmode 4k 712.75  3840 4160 4576 5312  2160 2163 2168 2237 -hsync +vsync
    # xrandr --addmode Virtual1 4k
    # xrandr --output Virtual1 --mode 4k
    # xinput set-prop "pointer:HID 1532:0069" 190 0.2 0 0 0 0.2 0 0 0 1
    # xinput set-prop "pointer:Razer Razer Mamba Hyperflux" 190 0.2 0 0 0 0.2 0 0 0 1
    "$HOME/.xinitrc_local"
fi

dbus-launch --exit-with-session i3
