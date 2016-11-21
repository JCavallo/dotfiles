#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="agignore bashrc bash_profile gitconfig gitignore hgignore hgrc inputrc nvimrc psqlrc tmux.conf tmux.conf.local vimrc xonshrc"    # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# Create config folder
mkdir -p ~/.config

# Hangups
mkdir -p ~/.config/hangups
cp ~/dotfiles/hangups.conf ~/.config/hangups

# Create local binary folder
mkdir -p ~/bin
ln -s ~/dotfiles/tools/* ~/bin/

# Move existing .vim
mv ~/.vim ~/dotfiles_old/

# Create vim directory
mkdir -p ~/.vim

# Link rc directory
ln -s ~/dotfiles/vim_rc_files/ ~/.vim/rc

# Create subdirectories
mkdir -p ~/.vim/swap
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/undodir

# Add argcomplete to bash_completion
mkdir -p ~/.bash_completion.d
ln -s ~/dotfiles/bash_completion/python_argcomplete.sh ~/.bash_completion.d/python-argcomplete.sh

# Load fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install

# Create temporary directory
mkdir -p ~/tmp

# Create projects directory
mkdir -p ~/Projets

# Build latest neovim
cd ~/Projets
git clone https://github.com/neovim/neovim Neovim
sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
cd Neovim
make CMAKE_BUILD_TYPE=Release
sudo make install
mkdir -p ~/.config
mkdir -p ~/.config/nvim
cd ~/.config/nvim
ln -s ~/dotfiles/nvimrc init.vim

# Install hgreview
sudo apt-get install python-pip
cd ~/tmp
# hg clone https://bitbucket.org/techtonik/python-review/
# cd python-review/
# ./refresh.py
# sudo ./setup.py install
# cd ..
# hg clone https://bitbucket.org/nicoe/hgreview
# cd hgreview
# sudo python setup.py install
# cd ~
# cp ~/tmp/python-review/rietveld/upload.py ~/bin/
# chmod +x ~/bin/upload.py

# Install Power Line Fonts
cd ~/tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..
rm -r fonts
cd ~

# Install fbterm (replace tty)
sudo apt-get install fbterm
sudo gpasswd -a giovanni video
sudo chmod u+s /usr/bin/fbterm

# Handle remote neovim
cd ~/tmp
git clone https://github.com/mhinz/neovim-remote.git neovim-remote
cd neovim-remote
git checkout master
chmod +x nvr
cp nvr ~/bin
cd ~/tmp
rm -rf neovim-remote

# Install tmux
echo tmux not installed, you will have to do it manually

# Install tmux plugin
mkdir -p ~/.config/tmux_plug
git clone https://github.com/tmux-plugins/tmux-yank ~/.config/tmux_plug/tmux-yank
