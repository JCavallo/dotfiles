#!/bin/bash

# Use strict mode
set -euo pipefail
IFS=$'\n\t'

dir="$HOME"/dotfiles
olddir="$olddir"
files="agignore bashrc bash_profile gitconfig gitignore hgignore hgrc inputrc nvimrc psqlrc tmux.conf tmux.conf.local vimrc Xdefaults xonshrc"    # list of files/folders to symlink in homedir
IFS=' ' read -ra files <<< "${files}"

# Create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in $HOME ..."
mkdir -p "$olddir"
echo "done"

# Change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd "$dir"
echo "done"

# Move any existing dotfiles in homedir to _dotfiles_old directory, then create
# symlinks from the homedir to any files in the "$HOME"/dotfiles directory
# specified in $files
for file in "${files[@]}"; do
    echo "$HOME/.$file"
    if [ -e "$HOME/.$file" ]; then
        echo "Moving existing .$file from $HOME to $olddir"
        mv "$HOME/.$file" "$olddir"/
    fi
    echo Creating symlink to "$file" in home directory.
    ln -s "$dir"/"$file" "$HOME/.$file"
done

# Create config folder
mkdir -p "$HOME"/.config

# Hangups
pip3 install --user hangups
mkdir -p "$HOME"/.config/hangups
ln -s "$HOME"/dotfiles/hangups.conf "$HOME"/.config/hangups/

# Create local binary folder
mkdir -p "$HOME"/bin
ln -s "$HOME"/dotfiles/tools/* "$HOME"/bin/

# Move existing .vim
if [ -d "$HOME/.vim" ]; then
    mv "$HOME"/.vim "$olddir"/
fi

# Create vim directory
mkdir -p "$HOME"/.vim

# Link rc directory
ln -s "$HOME"/dotfiles/vim_rc_files/ "$HOME"/.vim/rc

# Create subdirectories
mkdir -p "$HOME"/.vim/swap
mkdir -p "$HOME"/.vim/backup
mkdir -p "$HOME"/.vim/undodir

# Add argcomplete to bash_completion
mkdir -p "$HOME"/.bash_completion.d
ln -s "$HOME"/dotfiles/bash_completion/python_argcomplete.sh "$HOME"/.bash_completion.d/python-argcomplete.sh

# Load fzf
git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME"/.fzf
sudo "$HOME"/.fzf/install

# Create temporary directory
mkdir -p "$HOME"/tmp

# Create projects directory
mkdir -p "$HOME"/Projets

# Build latest neovim
cd "$HOME"/Projets
git clone https://github.com/neovim/neovim Neovim
sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip libunibilium-dev
cd Neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
mkdir -p "$HOME"/.config
mkdir -p "$HOME"/.config/nvim
cd "$HOME"/.config/nvim
ln -s "$HOME"/dotfiles/nvimrc init.vim

# Install hgreview
sudo apt-get install python-pip python3-pip
pip install --user neovim
pip3 install --user neovim
cd "$HOME"/tmp
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
cd "$HOME"/tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..
rm -r fonts
cd "$HOME"

# Install fbterm (replace tty)
sudo apt-get install fbterm
sudo usermod -aG video giovanni
sudo setcap 'cap_sys_tty_config+ep' "$(command -v fbterm)"
sudo chmod u+s /usr/bin/fbterm

# Handle remote neovim
pip3 install --user neovim-remote

# Install tmux
sudo apt-get install tmux rxvt-unicode-256color

# Install tmux configuration
cd "$HOME"
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

# Install tmux plugin
mkdir -p "$HOME/.tmux_plugins"
git clone https://github.com/tmux-plugins/tpm ~/.tmux_plugins/tpm

# Install tools
sudo apt-get install shellcheck keychain direnv
