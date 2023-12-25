#!/bin/bash
# This script is used to complete the base environment on CentOS 7
# Usage: sudo ./init.sh

# install sudo
yum -y install sudo

# add root password.
/opt/init/change_password.sh root root

# add user
/opt/init/user_add.sh admin1 admin1 sudo

# install basic packages
/opt/init/basic_packages_install.sh

# install ssh server
/opt/init/ssh_install.sh

# install gnome desktop
/opt/init/gnome_install.sh

# install VNC server
/opt/init/vnc_install.sh

# creat vnc server
/opt/init/vnc_user_add.sh admin1 admin1

# change user
su admin1
