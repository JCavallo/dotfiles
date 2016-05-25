#!/bin/sh
rm -rf /tmp/vim_/*
rm -rf /tmp/cache_/*
cd /tmp/vim_/
ln -s ~/Projets/Nvimrc/dotfiles/vim_rc_files rc
FORCE_VIM_FOLDER=/tmp/vim_ FORCE_VIM_CACHE=/tmp/cache_ nvim -u ~/Projets/Nvimrc/dotfiles/vimrc
