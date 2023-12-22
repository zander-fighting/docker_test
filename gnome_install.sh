#!/bin/bash
# This script is for installing gnome desktop on CentOS 7
# Usage: ./gnome_install.sh

# Prompt the user to enter the sudo password
get_sudo_password(){
  echo "Please enter your sudo password:"
  read -s password
}

# Define a function to install GNOME Desktop and Graphical Administration Tools
install_gnome() {
  echo "Installing GNOME Desktop..."
  echo $password | sudo -S yum -y groupinstall "GNOME Desktop"
  # Set the default target to graphical.target
  echo $password | sudo -S systemctl set-default graphical.target
}

# Define a function to print a success message
print_success() {
  # Use printf command to format the output
  printf "GNOME Deskpot is installed"
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
get_sudo_password
install_gnome
print_success