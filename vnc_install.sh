#!/bin/bash
# This script is for installing VNC on CentOS 7
# Usage: sudo ./vnc_install.sh

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
  local packages=(tigervnc-server tigervnc-server-module)
  # Loop through the array and install each package
  for package in "${packages[@]}"; do
    print_info "Installing $package..."
    yum -y install "$package"
    check_error "Failed to install $package"
    print_info "Installing $package successful..."
  done
}

print_successful(){
  # Print out information on successful VNC server install
  print_info "VNC server installation successfully"
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
print_successful