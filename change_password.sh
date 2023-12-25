#!/bin/bash
# This script is for change the user password on CentOS 7
# Usage: sudo ./change_password.sh username password

# Define some constants
SUDOERS_FILE="/etc/sudoers"
SHELL="/bin/bash"

# Check if the first argument is supplied, if not, output the usage and exit
if [[ -z $1 ]]; then
  printf "[ERROR]No user name supplied\n"
  print_info "Usage: $0 username password"
  exit 2
fi

# Check if the second argument is supplied, if not, output the usage and exit
if [[ -z $2 ]]; then
  printf "[ERROR]No user passowrd supplied\n"
  print_info "Usage: $0 username password"
  exit 3
fi

# Get input parameters
user="${1}"
pass="${2}"

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

check_input(){
  # Check if the script is run as root, if not, prompt the user to use sudo
  if [ $EUID -ne 0 ]; then
    print_info "Please run this script as root or use sudo"
    exit 1
  fi

  # Check if the entered username exists, if not, create the user
  if ! id "$user" &> /dev/null; then
    print_info "User $user not found, creating user"
    useradd -d "/home/$user" -s "$SHELL" "$user"
    check_error "Failed to create user $user"
    print_info "User $user has been creating now"
  fi
}

change_password(){
  # Use the echo command and pipeline to pass the password to the passwd command, and use the --stdin option to have the passwd command read the new password from standard input
  echo "$pass" | passwd --stdin "$user"
  check_error "Failed to change password for user $user"
  print_info "Change $user password successfully"
}

print_information(){
  # Print out information on successful password change
  print_info "Password change successful"
  print_info "username: $user"
  print_info "password: $pass"
}

# Call the functions
check_input
change_password
print_information