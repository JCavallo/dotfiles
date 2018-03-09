#!/bin/sh

# This script is used to bootstrap a test (debian) docker image before trying
# out the install.sh script in it.

# Typical use :
#
#   docker run -v ~/dotfiles:/dotfiles -it debian \
#       sh /dotfiles/misc/test_install.sh
#
# Then once basic installation is done :
#
#   ./dotfiles/install.sh

set -eu
echo Installing minimal dependencies
apt update > /dev/null
apt -y install sudo bash vim git > /dev/null
useradd -s /bin/bash -m giovanni
chown -R giovanni /home/giovanni
echo 'giovanni  ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'giovanni:giovanni' | chpasswd
cd /home/giovanni
git clone /dotfiles dotfiles
chown -R giovanni dotfiles
su giovanni
bash
