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

# Define a function to install VNC packages
install_packages() {
  # Use an array to store package names
  local packages=(net-tools openssh-server openssh-clients)
  # Loop through the array and install each package
  for package in "${packages[@]}"; do
    print_info "Installing $package..."
    yum -y install "$package"
    check_error "Failed to install $package"
    print_info "Installing $package successful..."
  done
}

# Define a function to start and enable sshd service
start_sshd() {
  print_info "Starting and enabling sshd service..."

  # Start and enable sshd service
  systemctl start sshd
  check_error "Failed to start sshd service"
  print_info "Start sshd service..."
  systemctl enable sshd
  check_error "Failed to enable sshd service"
  print_info "Enable sshd service..."
}

# Define a function to stop firewall service if active
stop_firewall() {
  print_info "Checking firewall status..."
  # Use if-then-else to handle different cases
  if systemctl is-active --quiet "$FIREWALL_SERVICE"; then
    print_info "Stopping firewall service..."
    systemctl stop "$FIREWALL_SERVICE"
    check_error "Failed to stop firewall service"
  else
    print_info "The firewall service is already inactive"
  fi
}

print_successful(){
  # Print successful message
  print_info "SSH installation and configuration completed successfully"
}

# Define a function to clean up on exit
cleanup() {
  echo "Cleaning up..."
  # Add any commands to clean up here
  yum clean all
}

# Trap the exit signal and call the cleanup function
trap cleanup EXIT

# Call the functions
install_packages
start_sshd
stop_firewall
print_successful