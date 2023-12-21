#!/bin/bash
# This script is used to add user and give the sudo/normal authority for user on CentOS 7
# Usage: ./user_add.sh user password [sudo/normal]

# Get the number of input parameters
num=$#
# If the number of parameters is not three, output the standard command input method and exit
if [ $num -ne 3 ]; then
  echo -e "Script input error, correct input method is as follows:\n\
  $0 username password [sudo/normal]"
  exit 1
fi

# Get input parameters
user=$1
pass=$2
perm=${3:-normal}

# Check the input user permissions. If it is not sudo or normal, output that the user permissions are illegal and exit
if [ $perm != "sudo" ] && [ $perm != "normal" ]; then
  echo "User permissions are illegal"
  exit 2
fi

# Check if the entered username exists. If it does, output that the user already exists. User addition failed and exit
if id $user &> /dev/null; then
  echo "User already exists, user addition failed"
  exit 3
fi

# Prompt the user to enter the sudo password
echo "Please enter your sudo password:"
read -s password

# Use the useradd command to create a user and specify their home directory and login shell
echo $password | sudo -S useradd -d /home/$user -s /bin/bash $user

# Use the echo command and pipeline to pass the password to the passwd command, and use the -- stdin option to have the passwd command read the new password from standard input
echo $password | sudo -S echo $pass | passwd --stdin $user

# According to user permissions, modify the/etc/sudoers file to add or remove sudo permissions for users
# To modify the file, you need to first add write permission to it before restoring it
echo $password | sudo -S chmod u+w /etc/sudoers
if [ $perm == "sudo" ]; then
  # If the user permission is sudo, add a line at the end of the file to add sudo permission to the user
  echo $password | sudo -S echo "$user ALL=(ALL) NOPASSWD: NOPASSWD: ALL" >> /etc/sudoers
else
  # If the user's permission is normal, delete the user's sudo permission from the file, if it exists
  echo $password | sudo -S sed -i "/^$user/d" /etc/sudoers
fi
echo $password | sudo -S chmod u-w /etc/sudoers
# Print out information on successful user addition
echo -e "User added successfully\n\
username: $user\n\
user permission: $perm\n\
user password: $pass"