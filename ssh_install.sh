#!/bin/bash
# This script is for installing ssh on CentOS 7
# Usage: ./ssh_install.sh

# Prompt the user to enter the sudo password
echo "Please enter your sudo password:"
read -s password

echo $password | sudo -S yum -y install net-tools

# Install openssh-server and openssh-clients
echo $password | sudo -S yum -y install openssh-server openssh-clients

# Start and enable sshd service
echo $password | sudo -S systemctl start sshd
echo $password | sudo -S systemctl enable sshd

# Restart sshd service to apply the changes
echo $password | sudo -S systemctl restart sshd