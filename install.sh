#!/bin/bash

TERMINAL=kitty  # Or alacritty
WM=sway  # Or i3
BROWSER=brave  # Or Chromz

# Use strict mode
set -euo pipefail

echo_comment () {
    echo ' '
    printf "\e[1;38;5;196m%s\e[0m" "$*"
    echo ' '
    echo ' '
}

while true; do
    read -rp "Will there be a UI? (Y/n)" yn
    case $yn in
        [Yy]* ) SERVER=0; break;;
        [Nn]* ) SERVER=1; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo_comment "Installing core requirements"
sudo apt -y install moreutils &> /dev/null

echo_comment "Installing main tools"
MAIN_TOOLS=""
MAIN_TOOLS+="apparmor-utils "  # For aadisable...
MAIN_TOOLS+="bat "  # Better cat
MAIN_TOOLS+="cmake "  # We will use it anyway
MAIN_TOOLS+="curl "  # Always useful
MAIN_TOOLS+="direnv "  # Per folder environment variables
MAIN_TOOLS+="dnsutils "  # nslookup is useful
MAIN_TOOLS+="exa "  # better ls
MAIN_TOOLS+="exuberant-ctags "  # You're a dev or you're not
MAIN_TOOLS+="fonts-font-awesome "  # Better fonts are always nice to have
MAIN_TOOLS+="git "  # In case it's not already there
MAIN_TOOLS+="g++ "  # Will always need it somehow
MAIN_TOOLS+="htop "  # Like top, but better
MAIN_TOOLS+="imagemagick "  # View images...
MAIN_TOOLS+="jq "  # Beautiful json
MAIN_TOOLS+="keychain "  # Manage ssh because I must
MAIN_TOOLS+="libtool-bin "  # Will be used by neovim
MAIN_TOOLS+="make "  # Will always need it somehow
MAIN_TOOLS+="network-manager "  # Command line network utilities
MAIN_TOOLS+="pulseaudio "  # Sound management
MAIN_TOOLS+="python3-pip "  # Will need it at some point anyway
MAIN_TOOLS+="ruby "  # Git blur :'(
MAIN_TOOLS+="ranger "  # Cli file explorer
MAIN_TOOLS+="ripgrep "  # Better grep
MAIN_TOOLS+="shellcheck "  # Always bashing
MAIN_TOOLS+="tmux "  # Even when you think you don't, you'll need it
MAIN_TOOLS+="tree "  # Never thought I'd need it until I used it
MAIN_TOOLS+="unzip "  # Always useful
MAIN_TOOLS+="wget "  # Always useful

chronic sudo apt -y install $MAIN_TOOLS

if [[ "$SERVER" = "0" ]]; then
    echo_comment "Installing GUI tools"
    GUI_TOOLS=""

    if [[ "$WM" = "sway" ]]; then
        GUI_TOOLS+="gammastep "  # Change light temperature depending on time
        GUI_TOOLS+="grim "  # Screenshot tools
        GUI_TOOLS+="mako-notifier "  # Notification daemon for wayland
        GUI_TOOLS+="slurp "  # Screenshot tools
        GUI_TOOLS+="sway "  # Compositor / window manager
        GUI_TOOLS+="swayidle "  # Idle configuration
        GUI_TOOLS+="waybar "  # task bar
        GUI_TOOLS+="wdisplays "  # Copy paste, wayland style
        GUI_TOOLS+="wl-clipboard "  # Copy paste, wayland style
    elif [[ "$WM" = "i3" ]]; then
        GUI_TOOLS+="feh "  # Wallpapers
        GUI_TOOLS+="numlockx "  # Just so we can startx
        GUI_TOOLS+="unclutter-xfixes "  # Auto hide mouse
        GUI_TOOLS+="xclip "  # copy paste...
        GUI_TOOLS+="xinit "  # Just so we can startx
    fi
    if [[ "$TERMINAL" = "kitty" ]]; then
        GUI_TOOLS+="kitty "
    fi
    chronic sudo apt -y install $GUI_TOOLS
fi

I3_BUILD_DEPS="libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev make
libstartup-notification0-dev libxcb-randr0-dev
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libtool
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev xutils-dev
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev"
I3_RUN_DEPS="libasan5 libglib2.0-0 libxcb-xkb1 libxcb-xinerama0
libxcb-randr0 libxcb-shape0 libxcb-util1 libyajl2 libpangocairo-1.0-0
libstartup-notification0 libxcb-cursor0 libxcb-keysyms1 libxcb-icccm4
libxkbcommon-x11-0 libev4 "

POLYBAR_BUILD_DEPS="build-essential cmake cmake-data libasound2-dev
libcairo2-dev libcurl4-openssl-dev libjsoncpp-dev libmpdclient-dev
libnl-genl-3-dev libpulse-dev libxcb-composite0-dev libxcb-cursor-dev
libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev
libxcb-util0-dev libxcb-xkb-dev libxcb-xrm-dev libxcb1-dev pkg-config
python3-sphinx python3-xcbgen xcb-proto"
POLYBAR_RUN_DEPS="libasound2 libmpdclient2 libcairo2 libnl-genl-3-200
libpulse0 libxcb-composite0 libxcb-xkb1 libxcb-randr0 libxcb-cursor0
libxcb-ewmh2 libxcb-icccm4 libjsoncpp1 "

COMPTON_BUILD_DEPS="libx11-dev libxcomposite-dev libxdamage-dev libxfixes-dev
libxext-dev libxrandr-dev libxinerama-dev pkg-config make x11proto-dev
libpcre3-dev libconfig-dev libdrm-dev libgl-dev libdbus-1-dev asciidoc"
COMPTON_RUN_DEPS="libx11-6 libxcomposite1 libxdamage1 libxfixes3 libxext6
libxrandr2 libxinerama1 x11-utils libpcre3 libconfig9 libgl1 libdbus-1-3 "

ALACRITTY_BUILD_DEPS="cmake pkg-config libfreetype6-dev libexpat1-dev
libxcb1-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-xfixes0-dev"
ALACRITTY_RUN_DEPS="libexpat1 libxcursor1 libxcb-render-util0
libxcb-shape0 libfreetype6 libxcb-xfixes0 libxi6 libx11-6 libx11-xcb1 "

ROFI_BUILD_DEPS="autoconf automake pkg-config flex bison check meson
libcairo2-dev libpango1.0-dev libpangocairo-1.0-0 cmake librsvg2-dev
libjpeg-dev libxcb-util0-dev libxcb-xkb-dev libx11-xcb-dev libxkbcommon-x11-dev
libxcb-ewmh-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-xinerama0-dev
libstartup-notification0-dev libxcb-xrm-dev"
ROFI_RUN_DEPS="libglib2.0-0 libcairo2 libpango-1.0-0 libpangocairo-1.0-0 
librsvg2-2 libxcb-util1 libxcb-xkb1 libxkbcommon-x11-0 libxcb-ewmh2
libxcb-icccm4 libxcb-xinerama0 libstartup-notification0 "

SWAYLOCK_BUILD_DEPS="meson ninja-build libcairo2-dev libgdk-pixbuf-2.0-dev
libxkbcommon-dev libwayland-dev "
SWAYLOCK_RUN_DEPS="wayland-protocols xwayland "

NEOVIM_BUILD_DEPS="pkg-config gettext "

PSPG_BUILD_DEPS="libncurses-dev "

BREW_RUN_DEPS="build-essential curl file git "

SWAY_RUN_DEPS="libmpdclient2 libdbusmenu-gtk3-4 libfmt8 "

BUILD_DEPS="$PSPG_BUILD_DEPS $NEOVIM_BUILD_DEPS "
RUN_DEPS="tzdata $BREW_RUN_DEPS"

if [[ "$SERVER" = "0" ]]; then
    if [[ "$WM" = "i3" ]]; then
        BUILD_DEPS+="$I3_BUILD_DEPS $POLYBAR_BUILD_DEPS $COMPTON_BUILD_DEPS "
        BUILD_DEPS+="$ROFI_BUILD_DEPS "
        RUN_DEPS+="$I3_RUN_DEPS $POLYBAR_RUN_DEPS $COMPTON_RUN_DEPS "
        RUN_DEPS+="$ROFI_RUN_DEPS "
    fi
    if [[ "$WM" = "sway" ]]; then
        BUILD_DEPS+="$SWAYLOCK_BUILD_DEPS "
        RUN_DEPS+="$SWAYLOCK_RUN_DEPS $SWAY_RUN_DEPS "
    fi
    if [[ "$TERMINAL" = "alacritty" ]]; then
        BUILD_DEPS+="$ALACRITTY_BUILD_DEPS "
        RUN_DEPS+="$ALACRITTY_RUN_DEPS "
    fi
fi

echo_comment "Installing Build Dependencies"
chronic sudo DEBIAN_FRONTEND=noninteractive apt -y install $BUILD_DEPS

# We'll manually startx, since gdm & co ignore xinitrc
if [[ "$SERVER" = "0" ]] && [[ "$WM" = "i3" ]]; then
    if [[ ! "$(command -v lightdm)" ]]; then
        chronic sudo apt remove --purge lightdm
    fi
    if [[ ! "$(command -v gdm3)" ]]; then
        chronic sudo apt remove --purge gdm3
    fi
fi

# For some reason this is created as the root user
sudo rm -rf "$HOME"/.cache

dir="$HOME"/dotfiles
olddir="$HOME/.old_dotfiles"

if [ ! -e "$olddir" ]; then
    echo_comment "Backuping old dotfiles"
    files="agignore bashrc bash_profile colors gitconfig gitignore hgignore \
        hgrc inputrc psqlrc tmux.conf tmux.conf.local Xdefaults \
        xinitrc xonshrc"    # list of files/folders to symlink in homedir
    IFS=$' \n' read -ra files <<< "${files}"

    # Create dotfiles_old in homedir
    mkdir -p "$olddir"

    # Change to the dotfiles directory
    cd "$dir"

    # Move any existing dotfiles in homedir to _dotfiles_old directory,
    # then create symlinks from the homedir to any files in the
    # "$HOME"/dotfiles directory specified in $files
    for file in "${files[@]}"; do
        if [ -e "$HOME/.$file" ]; then
            mv "$HOME/.$file" "$olddir"/
        fi
        ln -s "$dir"/"$file" "$HOME/.$file"
    done
fi

# Create config folder
mkdir -p "$HOME"/.config

if [[ "$SERVER" = "0" ]]; then
    if [[ "$WM" = "i3" ]]; then
        mkdir -p "$HOME"/.config/i3
        mkdir -p "$HOME"/.config/i3status
        mkdir -p "$HOME"/.config/polybar

        if [ ! -e "$HOME"/.config/i3/config ]; then
            ln -s "$dir"/i3config "$HOME"/.config/i3/config
            ln -s "$dir"/i3status_config "$HOME"/.config/i3status/config
        fi

        if [ ! -e "$HOME"/.config/compton.conf ]; then
            ln -s "$dir"/compton.conf "$HOME"/.config/
        fi

        if [ ! -e "$HOME"/.config/polybar/config ]; then
            ln -s "$dir"/polybar "$HOME"/.config/polybar/config
        fi

        if [ ! -e "$HOME"/.config/rofi ]; then
            ln -s "$dir"/rofi "$HOME"/.config/rofi
        fi
    fi
    if [[ "$WM" = "sway" ]]; then
        mkdir -p "$HOME"/.config/sway
        if [[ ! -e "$HOME"/.config/sway/config ]]; then
            ln -s "$dir"/sway "$HOME"/.config/sway/config
        fi
        if [[ ! -e "$HOME"/.config/waybar ]]; then
            ln -s "$dir"/waybar "$HOME"/.config/waybar
        fi
        if [[ ! -e "$HOME"/.config/swaylock ]]; then
            mkdir -p "$HOME"/.config/swaylock
            ln -s "$dir"/swaylock "$HOME"/.config/swaylock/config
        fi
        if [[ ! -e "$HOME"/.config/mako ]]; then
            mkdir -p "$HOME"/.config/mako
            ln -s "$dir"/mako "$HOME"/.config/mako/config

            # Necessary so a custom configfile patch can be used :/
            # sudo aa-disable /etc/apparmor.d/fr.emersion.Mako
        fi
    fi
    if [[ "$TERMINAL" = "kitty" ]]; then
        mkdir -p "$HOME"/.config/kitty
        if [[ ! -e "$HOME"/.config/kitty/kitty.conf ]]; then
            ln -s "$dir"/kitty "$HOME"/.config/kitty/kitty.conf
        fi
    fi
fi

# Create temporary directory
mkdir -p "$HOME"/tmp

# Create projects directory
mkdir -p "$HOME"/Projets

# Create local binary folder
if [ ! -e "$HOME/bin" ]; then
    mkdir -p "$HOME"/bin
fi

if [ ! -e "$HOME"/.config/nvim ]; then
    mkdir -p "$HOME"/.config/
    ln -s "$HOME"/dotfiles/nvim "$HOME"/.config/nvim
fi

# Move existing .vim
if [[ -d "$HOME/.vim" ]] && [[ ! -e "$olddir/.vim" ]]; then
    mv "$HOME"/.vim "$olddir"/
fi

# Add argcomplete to bash_completion
if [ ! -e "$HOME/.bash_completion.d" ]; then
    mkdir -p "$HOME"/.bash_completion.d
    ln -s "$HOME"/dotfiles/bash_completion/python_argcomplete.sh \
        "$HOME"/.bash_completion.d/python-argcomplete.sh
fi

# Load fzf
if [ ! -e "$HOME/.fzf" ]; then
    echo_comment "Installing fzf"
    chronic git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
    chronic "$HOME"/.fzf/install --all
fi

# Fuzzy Git
if [[ ! -e "$HOME/tools" ]]; then
    echo_comment "Loading tools"
    mkdir -p "$HOME/tools"
    cd "$HOME/tools"
    chronic git clone https://github.com/bigH/git-fuzzy.git
fi

if [[ ! "$(command -v ptpython)" ]]; then
    echo_comment "Installing ptpython"
    chronic pip3 install --user ptpython
    mkdir -p "$HOME/.config/ptpython"
    ln -s "$HOME/dotfiles/ptpython" "$HOME/.config/ptpython/config.py"
fi

# Install Homebrew if needed
if [[ ! "$(command -v brew)" ]]; then
    curl -fsSL \
        https://raw.githubusercontent.com/Homebrew/install/master/install.sh \
        > /tmp/homebrew.sh
    chronic bash /tmp/homebrew.sh <<< "
"
    source "$HOME/.bashrc"
fi

if [[ "$SERVER" = "0" ]] && [[ "$WM" = "i3" ]]; then
    # Installing i3 gap
    if [[ ! "$(command -v i3)" ]]; then
        echo_comment "Installing i3 gap"
        cd /tmp
        chronic git clone https://github.com/Airblader/xcb-util-xrm
        cd xcb-util-xrm
        chronic git submodule update --init
        chronic ./autogen.sh --prefix=/usr --disable-dependency-tracking
        chronic make
        chronic sudo make install
        cd /tmp
        # chronic git clone https://www.github.com/Airblader/i3 i3-gaps

        # Consider switching back to Airblader's once rounded corner are merged :)
        chronic git clone https://www.github.com/resloved/i3 i3-gaps
        cd i3-gaps
        chronic autoreconf --force --install
        chronic mkdir build
        cd build
        chronic ../configure --prefix=/usr --sysconfdir=/etc
        chronic make
        chronic sudo make install
    fi

    # Installing Polybar
    if [[ ! "$(command -v polybar)" ]]; then
        echo_comment "Installing polybar"
        cd /tmp
        chronic git clone --recursive https://github.com/polybar/polybar
        cd polybar
        mkdir build
        cd build
        chronic cmake ..
        chronic make -j"$(nproc)"
        chronic sudo make install
    fi

    # Installing compton
    if [[ ! "$(command -v compton)" ]]; then
        echo_comment "Installing compton"
        cd /tmp
        chronic git clone https://github.com/tryone144/compton
        cd compton
        chronic make
        chronic sudo make install
    fi

    # Install rofi (i3 menu)
    if [[ ! "$(command -v rofi)" ]]; then
        echo_comment "Installing rofi"
        cd /tmp
        chronic git clone https://github.com/davatorium/rofi/
        cd rofi
        chronic git submodule update --init
        chronic meson setup build
        chronic ninja -C build
        chronic sudo ninja -C build install
    fi
fi

if [[ "$SERVER" = "0" ]] && [[ "$WM" = "sway" ]]; then
    if [[ $(command -v vmware-toolbox-cmd) ]]; then
        echo_comment "Disabling hardware acceleration for cursors in virtual machines"
        sudo bash -c 'echo WLR_NO_HARDWARE_CURSORS=1 >> /etc/environment'
    fi
    if [ ! -e "$HOME/bin/sway-launcher" ]; then
        echo_comment "Loading sway-launcher"
        chronic curl -fLo "$HOME/bin/sway-launcher" \
            https://github.com/Biont/sway-launcher-desktop/raw/master/sway-launcher-desktop.sh
        chmod +x ~/bin/sway-launcher
    fi
    if [[ ! -e "$HOME/bin/sway-fader" ]]; then
        echo_comment "Loading sway-fader"
        chronic pip3 install --user i3ipc
        chronic curl -fLo "$HOME/bin/sway-fader" \
            https://raw.githubusercontent.com/jake-stewart/swayfader/master/swayfader.py
    fi
    if [[ ! "$(command -v swaylock)" ]]; then
        echo_comment "Loading swaylock with effects"
        cd /tmp
        chronic git clone https://github.com/mortie/swaylock-effects
        cd swaylock-effects
        chronic meson build
        chronic ninja -C build
        chronic sudo ninja -C build install
        chronic sudo chmod a+s /usr/local/bin/swaylock
    fi
fi

# Build latest neovim
if [ "$(which nvim)" = '' ]; then
    echo_comment "Building Latest Neovim"
    cd "$HOME"/Projets
    chronic git clone https://github.com/neovim/neovim Neovim
    cd Neovim
    chronic make CMAKE_BUILD_TYPE=Release -j4
    chronic sudo make install
    chronic pip install --user neovim
    chronic pip3 install --user neovim
    chronic pip3 install --user neovim-remote
fi

# Install hgreview
# cd "$HOME"/tmp
# hg clone https://bitbucket.org/techtonik/python-review/
# cd python-review/
# ./refresh.py
# sudo ./setup.py install
# cd ..
# hg clone https://bitbucket.org/nicoe/hgreview
# cd hgreview
# sudo python setup.py install
# cd "$HOME"
# cp "$HOME"/tmp/python-review/rietveld/upload.py "$HOME"/bin/
# chmod +x "$HOME"/bin/upload.py

# Install Power Line Fonts
if [[ "$SERVER" = "0" ]] && [[ "$(fc-list | grep Powerline)" = "" ]]; then
    # echo_comment "Installing powerline fonts"
    # cd "$HOME"/tmp
    # chronic git clone https://github.com/powerline/fonts
    # chronic ./fonts/install.sh
    # sudo rm -rf fonts
    echo_comment "Loading nerd fonts"
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    chronic curl -fLo "monofur Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monofur/Regular/complete/monofur%20Nerd%20Font%20Complete%20Mono.ttf
    chronic curl -fLo "monofur bold Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monofur/Bold/complete/monofur%20bold%20Nerd%20Font%20Complete%20Mono.ttf
    chronic curl -fLo "monofur italic Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monofur/Italic/complete/monofur%20italic%20Nerd%20Font%20Complete%20Mono.ttf
    cd ~/.local/share/fonts
    chronic curl -fLo "FiraCode Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.ttf
    chronic curl -fLo "FiraCode bold Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/complete/Fira%20Code%20Bold%20Nerd%20Font%20Complete%20Mono.ttf
    chronic curl -fLo "FiraCode italic Nerd Font Mono.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete%20Mono.ttf
    chronic fc-cache -f -v
    cd "$HOME"
fi

if [ ! -e "$HOME/.cargo" ]; then
    echo_comment "Installing rust"
    curl https://sh.rustup.rs -sSf > /tmp/rustup
    sh /tmp/rustup -y --no-modify-path
    source "$HOME/.bashrc"
fi

if [[ "$SERVER" = "0" ]] && [[ "$TERMINAL" = "alacritty" ]] && \
        [[ ! "$(command -v alacritty)" ]]; then
    echo_comment "Installing alacritty"
    mkdir -p "$HOME/Projets"
    cd "$HOME/Projets"
    chronic git clone https://github.com/jwilm/alacritty
    cd "$HOME/Projets/alacritty"
    cargo build --release
    cp target/release/alacritty "$HOME/bin"
    mkdir -p "$HOME/.config/alacritty"
    rm -f  "$HOME/.config/alacritty/alacritty.yml"
    ln -s "$dir/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
fi

if [ ! "$(command -v delta)" ]; then
    echo_comment "Installing delta"
    cargo install git-delta
fi

if [ ! "$(command -v kritik)" ]; then
    echo_comment "Installing kritik"
    cargo install --git https://github.com/jcavallo/kritik
fi

# Install n(ode)
if [ ! "$(command -v n)" ]; then
    echo_comment "Installing latest node js through n"
    curl -s -L https://git.io/n-install | chronic bash -s -- -y -n
    export PATH="$PATH:$HOME/n/bin"
    chronic npm i -g yarn
fi

# Install hub (for github)
if [ ! "$(command -v hub)" ]; then
    echo_comment "Installing latest hub"
    chronic brew install hub
fi

# Install fasd
if [ ! "$(command -v fasd)" ]; then
    echo_comment "Installing fasd"
    chronic brew install fasd
fi

# Install q for csv / tabular data queries
if [ ! "$(command -v q)"  ]; then
    echo_comment "Installing q (query-as-text)"
    chronic brew install harelba/q/q
fi

# Install tmux configuration
if [ ! -e "$HOME/.tmux" ]; then
    echo_comment "Installing tmux configuration"
    cd "$HOME"
    chronic git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf

    # Install tmux plugin
    mkdir -p "$HOME/.tmux_plugins"
    chronic git clone https://github.com/tmux-plugins/tpm ~/.tmux_plugins/tpm
fi

# Cheat
if [ ! "$(command -v cheat)" ]; then
    echo_comment "Installing cheat (for cheating)"
    cd /tmp
    chronic curl -sL -o cheat.gz https://github.com/cheat/cheat/releases/latest/download/cheat-linux-amd64.gz
    chronic gzip -d cheat.gz
    chronic chmod +x cheat
    chronic mv cheat "$HOME"/bin/
    chronic  mkdir -p "$HOME"/.config/cheat
    cheat --init > ~/.config/cheat/conf.yml
fi

# Pyenv
if [ ! "$(command -v pyenv)" ]; then
    echo_comment "Installing pyenv"
    curl -s -L \
        https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer \
        | chronic bash
    source "$HOME/.bashrc"
fi

if [ ! "$(command -v poetry)" ]; then
    curl https://install.python-poetry.org | python3 -
    poetry config virtualenvs.in-project true
fi

# Install pspg (psql pager)
if [ ! "$(command -v pspg)" ]; then
    echo_comment "Installing pspg"
    cd /tmp
    chronic git clone https://github.com/okbob/pspg
    cd pspg
    chronic ./configure
    chronic make
    chronic sudo make install
    cd "$HOME"
fi

# Install bitwarden cli
if [ ! "$(command -v bw)" ]; then
    echo_comment "Installing Bitwarden CLI"
    export PATH="$PATH:$HOME/n/bin"
    chronic npm i -g @bitwarden/cli
fi

function perso {
    if [ ! -e "$HOME/.ssh/id_rsa" ]; then
        echo_comment "Logging in to Bitwarden account"
        bw login
        session=$(bw unlock | grep "export BW_SESSION" | \
            sed -e 's/.*BW_SESSION="\(.*\)"/\1/')
        export BW_SESSION=$session

        echo_comment "Installing ssh keys"
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        bw get notes "b1aced9b-befd-4ad0-958c-adc0013b54b9" > "$HOME/.ssh/id_rsa"
        bw get notes "c32661a6-9569-4528-b528-adc0013b2982" > "$HOME/.ssh/id_rsa.pub"
        chmod 600 "$HOME/.ssh/id_rsa"
        chmod 644 "$HOME/.ssh/id_rsa.pub"
        eval "$(keychain --eval --agents ssh id_rsa)"

        if [[ ! -e "$HOME/Personal" ]]; then
            echo_comment "Cloning Personal"
            cd "$HOME"
            git clone ssh://giovanni@linariel.ddns.net:23/home/giovanni/repositories/Movables Personal
        fi

        ~/Personal/dotfiles/install.sh
    fi
}

if [ ! -e "$HOME/Personal" ]; then
    echo_comment "Installing private files"

    while true; do
        read -rp "Are you JC? (You WILL have to prove it)? (Y/n)" yn
        case $yn in
            [Yy]* ) perso && break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

echo_comment "Cleaning up"
# chronic sudo DEBIAN_FRONTEND=noninteractive apt -y remove --purge $BUILD_DEPS
# chronic sudo DEBIAN_FRONTEND=noninteractive apt -y autoremove --purge
chronic sudo DEBIAN_FRONTEND=noninteractive apt -y install $RUN_DEPS
sudo dpkg-reconfigure tzdata
sudo dpkg-reconfigure locales

# Install browser
if [[ "$SERVER" = "0" ]]; then
    if [[ "$BROWSER" = "chrome" ]] && [[ ! "$(command -v google-chrome)" ]]; then
        echo_comment "Installing chrome"
        cd /tmp
        chronic wget \
            https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
        chronic sudo apt install -y -f ./google-chrome-beta_current_amd64.deb
    fi
    if [[ "$BROWSER" = "brave" ]] && [[ ! "$(command -v brave-browser)" ]]; then
        echo_comment "Installing Brave"
        chronic sudo apt -y install apt-transport-https
        chronic sudo curl -fsSLo /usr/share/keyrings/brave-browser-beta-archive-keyring.gpg https://brave-browser-apt-beta.s3.brave.com/brave-browser-beta-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-beta-archive-keyring.gpg arch=amd64] https://brave-browser-apt-beta.s3.brave.com/ stable main" | \
            chronic sudo tee /etc/apt/sources.list.d/brave-browser-beta.list
        chronic sudo apt update
        chronic sudo apt -y install brave-browser-beta
    fi
fi
