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
chronic sudo apt -y install wget curl libtool libtool-bin autoconf automake \
    cmake g++ pkg-config unzip libunibilium-dev python-pip python3-pip fbterm \
    libcap2-bin tmux rxvt-unicode-256color shellcheck keychain direnv \
    libncursesw5-dev fontconfig silversearcher-ag libfreetype6-dev \
    libfontconfig1-dev xclip

dir="$HOME"/dotfiles
olddir="$HOME/_old_dotfiles"

if [ ! -e "$olddir" ]; then
    echo_comment "Backuping old dotfiles"
    files="agignore bashrc bash_profile gitconfig gitignore hgignore hgrc \
        inputrc nvimrc psqlrc tmux.conf tmux.conf.local vimrc Xdefaults \
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
    echo_comment "Installing rust and alacritty"
    curl https://sh.rustup.rs -sSf > /tmp/rustup
    sh /tmp/rustup -y
    export PATH="$HOME/.cargo/bin:$PATH"
    cargo install --git https://github.com/jwilm/alacritty
fi

# Install fbterm (replace tty)
echo_comment "Installing fbterm"
sudo usermod -aG video giovanni
sudo setcap 'cap_sys_tty_config+ep' "$(command -v fbterm)"
sudo chmod u+s /usr/bin/fbterm

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

# Hangups
if [ "$(which hangups)" = '' ]; then
    echo_comment "Installing hangups"
    chronic pip3 install --user hangups
    mkdir -p "$HOME"/.config/hangups
    ln -s "$HOME"/dotfiles/hangups.conf "$HOME"/.config/hangups/
fi

# Install pspg (psql pager)
if [ "$(which pspg)" = '' ]; then
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
