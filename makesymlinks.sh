#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="agignore bashrc gitconfig hgignore hgrc inputrc tmux.conf vimrc"    # list of files/folders to symlink in homedir

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

# Get mercurial cli tools
mkdir -p ~/Tools
cd ~/Tools
hg clone http://bitbucket.org/sjl/mercurial-cli-templates/

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
