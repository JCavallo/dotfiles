#!/bin/bash

# Use strict mode
set -euo pipefail
IFS=$'\n\t'

echo_comment () {
    echo ' '
    printf "\e[1;38;5;196m%s\e[0m" "$*"
    echo ' '
    echo ' '
}

echo_comment "Installing dependencies"
sudo apt -y install moreutils &> /dev/null
chronic sudo apt -y install \
    autoconf \
    automake \
    cmake \
    compton \
    ctags \
    curl \
    direnv \
    fbterm \
    fontconfig \
    fonts-font-awesome \
    g++ \
    pkg-config \
    feh \
    gettext \
    htop \
    keychain \
    libcap2-bin \
    libev-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libncursesw5-dev \
    libpango1.0-dev \
    libstartup-notification0-dev \
    libtool \
    libtool-bin \
    libunibilium-dev \
    libxcb-cursor-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-util0-dev \
    libxcb-xinerama0-dev \
    libxcb-xkb-dev \
    libxcb1-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libyajl-dev \
    python-pip \
    python3-pip \
    redshift-gtk \
    shellcheck \
    tmux \
    tree \
    unzip \
    wget \
    xclip \
    xinit \
    xutils-dev
    # i3 \
    # rxvt-unicode-256color \
    # silversearcher-ag \

dir="$HOME"/dotfiles
olddir="$HOME/.old_dotfiles"

if [ ! -e "$olddir" ]; then
    echo_comment "Backuping old dotfiles"
    files="agignore bashrc bash_profile colors gitconfig gitignore hgignore \
        hgrc inputrc nvimrc psqlrc tmux.conf tmux.conf.local vimrc Xdefaults \
        xonshrc"    # list of files/folders to symlink in homedir
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
mkdir -p "$HOME"/.config/i3
mkdir -p "$HOME"/.config/i3status

if [ ! -e "$HOME"/.config/i3/config ]; then
    ln -s "$dir"/i3config "$HOME"/.config/i3/config
    ln -s "$dir"/i3status_config "$HOME"/.config/i3status/config
fi

if [ ! -e "$HOME"/.config/compton.conf ]; then
    ln -s "$dir"/compton.conf "$HOME"/.config/
fi

# Create local binary folder
if [ ! -e "$HOME/bin" ]; then
    mkdir -p "$HOME"/bin
    ln -s "$HOME"/dotfiles/tools/* "$HOME"/bin/
fi

# Move existing .vim
if [[ -d "$HOME/.vim" ]] && [[ ! -e "$olddir/.vim" ]]; then
    mv "$HOME"/.vim "$olddir"/
fi

# Create vim directory
mkdir -p "$HOME"/.vim

# Link rc directory
if [ ! -e "$HOME/.vim/rc" ]; then
    ln -s "$HOME"/dotfiles/vim_rc_files/ "$HOME"/.vim/rc
fi

# Create subdirectories
mkdir -p "$HOME"/.vim/swap
mkdir -p "$HOME"/.vim/backup
mkdir -p "$HOME"/.vim/undodir

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

# Create temporary directory
mkdir -p "$HOME"/tmp

# Create projects directory
mkdir -p "$HOME"/Projets

# Installing i3 gap
if [[ "$(which i3)" = '' ]]; then
    echo_comment "Installing i3 gap"
    cd /tmp
    chronic git clone https://github.com/Airblader/xcb-util-xrm
    cd xcb-util-xrm
    chronic git submodule update --init
    chronic ./autogen.sh --prefix=/usr
    chronic make
    chronic sudo make install
    cd /tmp
    chronic git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps
    chronic autoreconf --force --install
    chronic mkdir build
    cd build
    chronic ../configure --prefix=/usr --sysconfdir=/etc
    chronic make
    chronic sudo make install
fi

# Build latest neovim
if [ "$(which nvim)" = '' ]; then
    echo_comment "Building Latest Neovim"
    cd "$HOME"/Projets
    chronic git clone https://github.com/neovim/neovim Neovim
    cd Neovim
    chronic make CMAKE_BUILD_TYPE=Release
    chronic sudo make install
    mkdir -p "$HOME"/.config
    mkdir -p "$HOME"/.config/nvim
    cd "$HOME"/.config/nvim
    ln -s "$HOME"/dotfiles/nvimrc init.vim
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
if [ "$(fc-list | grep Powerline)" = '' ]; then
    echo_comment "Installing powerline fonts"
    cd "$HOME"/tmp
    chronic git clone https://github.com/powerline/fonts
    chronic ./fonts/install.sh
    sudo rm -rf fonts
    cd "$HOME"
fi

if [ ! -e "$HOME/.cargo" ]; then
    echo_comment "Installing rust"
    curl https://sh.rustup.rs -sSf > /tmp/rustup
    sh /tmp/rustup -y --no-modify-path
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ ! "$(command -v alacritty)" ]; then
    echo_comment "Installing alacritty"
    cargo install --git https://github.com/jwilm/alacritty
    mkdir -p "$HOME/.config/alacritty"
    rm -f  "$HOME/.config/alacritty/alacritty.yml"
    ln -s "$dir/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
fi

if [ ! "$(command -v bat)" ]; then
    echo_comment "Installing bat"
    cargo install --git https://github.com/sharkdp/bat
fi

if [ ! "$(command -v rg)" ]; then
    echo_comment "Installing ripgrep"
    cargo install ripgrep
fi

if [ ! "$(command -v kritik)" ]; then
    echo_comment "Installing kritik"
    cargo install --git https://github.com/jcavallo/kritik
fi

# Install fbterm (replace tty)
echo_comment "Installing fbterm"
sudo usermod -aG video giovanni
sudo setcap 'cap_sys_tty_config+ep' "$(command -v fbterm)"
sudo chmod u+s /usr/bin/fbterm

# Install n(ode)
if [ ! "$(command -v n)" ]; then
    echo_comment "Installing latest node js through n"
    curl -s -L https://git.io/n-install | chronic bash -s -- -y -n
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

    # Install tmuxp
    chronic pip install --user tmuxp
    mkdir -p "$HOME/.tmuxp"
    ln -s "$dir/tmuxp_main.yaml" "$HOME/.tmuxp/main.yaml"
fi

# Pyenv
if [ ! "$(command -v pyenv)" ]; then
    echo_comment "Installing pyenv"
    curl -s -L \
        https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer \
        | chronic bash
fi

# Install pspg (psql pager)
if [ ! "$(command -v pspg)" ]; then
    echo_comment "Installing pspg"
    cd "$HOME"/tmp
    chronic git clone https://github.com/okbob/pspg
    cd pspg
    chronic ./configure
    chronic make
    chronic sudo make install
    cd "$HOME"
    rm -rf "$HOME"/tmp/pspg
fi

# Manage private files
if [ ! "$(command -v git-blur)" ]; then
    echo_comment "Installing private files"
    while true; do
        read -rp "Are you JC? (You WILL have to prove it)? (Y/n)" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit 0;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    chronic sudo apt -y install ruby
    echo_comment "Installing git blur"
    chronic sudo gem install git-blur
    cd "$dir"

    echo_comment "Decrypting blurred files"
    # In case installation changed something
    chronic git stash -u
    git blur init

    # Check files are properly decrypted
    if [ "$(cat vimrc.local | git blur smudge 2>&1 | \
            grep 'bad decrypt')" != '' ]; then
        echo_comment "Tried to cheat, did'nt ya? I'll exit"
        exit 1
    fi

    # Force checkout to decrypt all files. Use git add --renormalize . when
    # available
    chronic git read-tree --empty
    chronic git reset --hard HEAD

    if [ "$(git stash list)" != '' ]; then
        chronic git stash pop
    fi

    echo_comment "Installing decrypted files"
    files="vimrc.local bash_local pgpass"
    IFS=$' \n' read -ra files <<< "${files}"
    for file in "${files[@]}"; do
        ln -s "$dir"/"$file" "$HOME/.$file"
    done
    if [ -e "$HOME/.tmuxp" ]; then
        ln -s "$dir/tmuxp_projects.yaml" "$HOME/.tmuxp/projects.yaml"
    fi
    if [ ! -e "$HOME/.ssh/id_rsa" ]; then
        mkdir -p "$HOME/.ssh"
        ln -s "$dir/ssh/config" "$HOME/.ssh/config"
        cp "$dir/ssh/public" "$HOME/.ssh/id_rsa.pub"
        cp "$dir/ssh/private" "$HOME/.ssh/id_rsa"
        chmod 700 "$HOME/.ssh"
        chmod 600 "$HOME/.ssh/id_rsa"
        chmod 644 "$HOME/.ssh/id_rsa.pub"
    fi
fi
