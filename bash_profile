#/bin/sh
# setxkbmap -option ctrl:nocaps
# xset r rate 200 60
# xmodmap -e "keycode 49 = Multi_key"

if [ -e "$HOME/.bash_profile_local" ]; then
    source "$HOME/.bash_profile_local"
fi

[[ -f ~/.bashrc ]] && source ~/.bashrc
