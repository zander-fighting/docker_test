#!/bin/bash
# This script is for installing ssh on CentOS 7
# Usage: ./ssh_install.sh

# Prompt the user to enter the sudo password
get_sudo_password(){
    echo "Please enter your sudo password:"
    read -s password
}

# Install net-tools
install_net-tools(){
    echo $password | sudo -S yum -y install net-tools
}

# Install openssh-server and openssh-clients
install_ssh(){
    echo $password | sudo -S yum -y install openssh-server openssh-clients
}

# Start and enable sshd service
configuration_service(){
    echo $password | sudo -S systemctl start sshd
    echo $password | sudo -S systemctl enable sshd

    # Restart sshd service to apply the changes
    echo $password | sudo -S systemctl restart sshd
}


# Define a function to clean up on exit
cleanup() {
  echo "Cleaning up..."
  # Add any commands to clean up here
  echo $password | sudo -S yum clean all
}

# Trap the exit signal and call the cleanup function
trap cleanup EXIT

get_sudo_password
install_net-tools
install_ssh
configuration_service