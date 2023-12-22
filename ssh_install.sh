#!/bin/bash
# This script is for installing ssh on CentOS 7
# Usage: sudo ./ssh_install.sh

# Define some constants
SUDOERS_FILE="/etc/sudoers"
SHELL="/bin/bash"
FIREWALL_SERVICE=firewalld

# Define some functions
check_error() {
  # Check the last command result, if not 0, output the error message and exit the script
  if [ $? -ne 0 ]; then
    printf "[ERROR]%s\n" "$1"
    exit 1
  fi
}

print_info() {
  # Print the information message with a prefix
  printf "[INFO] %s\n" "$1"
}

# Check if the script is run as root, if not, prompt the user to use sudo
if [ $EUID -ne 0 ]; then
  print_info "Please run this script as root or use sudo"
  exit 1
fi

# Install net-tools
yum -y install net-tools
check_error "Failed to install net-tools"

# Install openssh-server and openssh-clients
yum -y install openssh-server openssh-clients
check_error "Failed to install openssh-server and openssh-clients"

# Start and enable sshd service
systemctl start sshd
check_error "Failed to start sshd service"
systemctl enable sshd
check_error "Failed to enable sshd service"

# Restart sshd service to apply the changes
systemctl restart sshd
check_error "Failed to restart sshd service"

# Check if the firewall service is active
if systemctl is-active --quiet "$FIREWALL_SERVICE"; then
  systemctl stop "$FIREWALL_SERVICE"
else
  echo "The firewall has been turned off..."
fi
check_error "Failed to stop firewall"

# Define a function to clean up on exit
cleanup() {
  echo "Cleaning up..."
  # Add any commands to clean up here
  yum clean all
}

# Trap the exit signal and call the cleanup function
trap cleanup EXIT

print_info "SSH installation and configuration completed successfully"