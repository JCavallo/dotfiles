#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="agignore bashrc gitconfig gitignore hgignore hgrc inputrc psqlrc tmux.conf vimrc"    # list of files/folders to symlink in homedir

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

# Move existing .vim
mv ~/.vim ~/dotfiles_old/

# Create vim directory
mkdir ~/.vim

# Link rc directory
ln -s ~/dotfiles/vim_rc_files/ ~/.vim/rc

# Create subdirectories
mkdir ~/.vim/swap
mkdir ~/.vim/backup
mkdir ~/.vim/undodir

# Add argcomplete to bash_completion
mkdir ~/.bash_completion.d
ln -s ~/dotfiles/bash_completion/python_argcomplete.sh ~/.bash_completion.d/python-argcomplete.sh

# Load fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install# Load fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install# Load fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install
