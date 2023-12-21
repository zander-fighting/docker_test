#!/bin/bash
# This script is used to complete the base environment on CentOS 7
# Usage: ./init.sh

# set root sudo password
rootpassword="root"

yum -y install sudo

# add root password
echo "$rootpassword" | /opt/init/change_password.sh root root
echo "$rootpassword" | /opt/init/user_add.sh admin1 admin1 sudo

# Clear password
unset rootpassword

su admin1