#!/bin/bash
# This script is for installing gnome desktop on CentOS 7
# Usage: sudo ./gnome_install.sh

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

install_packages(){
  # Define a function to install GNOME Desktop and Graphical Administration Tools
  print_info "Installing GNOME Desktop..."
  yum -y groupinstall "GNOME Desktop"
  check_error "fail to install GNOME Desktop"
  print_info "Installing GNOME Desktop successful..."
}

set_default(){
  # Set the default target to graphical.target
  systemctl set-default graphical.target
  check_error "fail to Set the default target to graphical.target"
  print_info "Set the default target to graphical.target successful..."
}

print_successful(){
  # Print out information on successful
  print_info "GNOME Deskpot is installed and configure"
}


# Define a function to clean up on exit
cleanup() {
  print_info "Cleaning up..."
  # Add any commands to clean up here
  yum clean all
}

# Trap the exit signal and call the cleanup function
trap cleanup EXIT

# Call the functions
install_packages
set_default
print_successful