#!/bin/sh

# This script is used to bootstrap a test (debian) docker image before trying
# out the install.sh script in it.

# Typical use :
#
#   docker run -v ~/dotfiles:/home/giovanni/dotfiles \
#       -v ~/dotfiles/misc:/init_docker -it debian \
#       sh /init_docker/test_install.sh
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
su giovanni
bash
