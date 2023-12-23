#!/bin/bash
# This script is for installing basic packages on CentOS 7
# Usage: sudo ./basic_packages_install.sh

# Define some functions
check_error() {
  # Check the last command result, if not 0, output the error message and exit the script
  if [ $? -ne 0 ]; then
    printf "[ERROR] %s\n" "$1"
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

# Define a function to install packages
install_packages() {
  # Use an array to store package names
  local packages=(epel-release vim net-tools)
  # Loop through the array and install each package
  for package in "${packages[@]}"; do
    print_info "Installing $package..."
    yum -y install "$package"
    check_error "Failed to install $package"
    print_info "Installing $package successful..."
  done
}

# Define a function to clean up on exit
cleanup() {
  print_info "Cleaning up..."
  # Add any commands to clean up here
  yum clean all
}

# Trap the exit signal and call the cleanup function
trap cleanup EXIT

# Call the install_packages function
# Remove the redundant functions for each package
install_packages