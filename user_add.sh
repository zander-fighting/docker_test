#!/bin/bash
# This script is used to add user and give the sudo/normal authority for user on CentOS 7
# Usage: sudo ./user_add.sh user password [sudo/normal]

# Define some constants
SUDOERS_FILE="/etc/sudoers"
SHELL="/bin/bash"

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

change_permission() {
  # Change the permission of the sudoers file, and check the result
  chmod "$1" "$SUDOERS_FILE"
  check_error "Failed to change the permission of $SUDOERS_FILE"
}

# Check if the script is run as root, if not, prompt the user to use sudo
if [ $EUID -ne 0 ]; then
  print_info "Please run this script as root or use sudo"
  exit 1
fi

# Get input parameters
user="$1"
pass="$2"
perm="${3:-normal}"

# Check input parameters
# If the number of parameters is not three, output the standard command input method and exit
if [ $# -ne 3 ]; then
  print_info "Script input error, correct input method is as follows:"
  print_info "$0 username password [sudo/normal]"
  exit 1
fi

# Check the input user permissions. If it is not sudo or normal, output that the user permissions are illegal and exit
if [ "$perm" != "sudo" ] && [ "$perm" != "normal" ]; then
  print_info "User permissions are illegal"
  exit 2
fi

# Check if the entered username exists. If it does, output that the user already exists. User addition failed and exit
if id "$user" &> /dev/null; then
  print_info "User already exists, user addition failed"
  exit 3
fi

# Use the useradd command to create a user and specify their home directory and login shell
useradd -d "/home/$user" -s "$SHELL" "$user"
check_error "Failed to create user $user"

# Use the echo command and pipeline to pass the password to the passwd command, and use the --stdin option to have the passwd command read the new password from standard input
echo "$pass" | passwd --stdin "$user"
check_error "Failed to set password for user $user"

# According to user permissions, modify the sudoers file to add or remove sudo permissions for users
# To modify the file, you need to first add write permission to it before restoring it
change_permission u+w
if [ "$perm" == "sudo" ]; then
  # If the user permission is sudo, add a line at the end of the file to add sudo permission to the user
  echo "$user ALL=(ALL) NOPASSWD: ALL" >> "$SUDOERS_FILE"
  check_error "Failed to add sudo permission for user $user"
else
  # If the user's permission is normal, delete the user's sudo permission from the file, if it exists
  sed -i "/^$user/d" "$SUDOERS_FILE"
  check_error "Failed to remove sudo permission for user $user"
fi
change_permission u-w

# Print out information on successful user addition
print_info "User added successfully"
print_info "username: $user"
print_info "user permission: $perm"
print_info "user password: $pass"