#!/bin/bash
# This script is used to add user and password for VNC on CentOS 7
# Usage: sudo ./vnc_user_add.sh user password

# Define some constants
FIREWALL_SERVICE=firewalld
# Define a range of ports to use for VNC
MIN_PORT=5901
MAX_PORT=5999

# Define some functions
check_error() {
  # Check the last command result, if not 0, output the error message and exit the script
  if [ $? -ne 0 ]; then
    printf "[ERROR] %s\n" "$1"
    exit 1
  fi
}

print_error() {
  # Print the information message with a prefix
  printf "[ERROR] %s\n" "$1"
}

print_info() {
  # Print the information message with a prefix
  printf "[INFO] %s\n" "$1"
}

change_permission() {
  # Change the permission of the file, and check the result
  chmod "$1" "$2"
  check_error "[ERROR]Failed to change the permission of $2"
}

# Check if the script is run as root, if not, prompt the user to use sudo
if [ $EUID -ne 0 ]; then
  print_error "Please run this script as root or use sudo"
  exit 1
fi

# If the number of parameters is not two, output the standard command input method and exit
if [ $# -ne 2 ]; then
  print_error "Script input error, correct input method is as follows:"
  print_info "sudo $0 username password"
  exit 1
fi

# Get input parameters
user="$1"
pass="$2"

# Set port and vnc_port
port=5901
vnc_port=$(($port-5900))

# Check input parameters
check_input(){
  # Check if the entered username exists. If not, output an error message and exit
  if ! id -u "$user" &>/dev/null; then
    print_error "User does not exist, please create the user first"
    exit 2
  fi

  # Validate the password length and criteria
  # Check if the password is at least 6 characters long
  if [ ${#pass} -lt 6 ]; then
    print_error "Password is too short, it must be at least 6 characters long"
    exit 5
  fi
}

check_port(){
  for port in $(seq $MIN_PORT $MAX_PORT); do
    # Use nc command to test if the port is open
    # Use -z option to scan without sending any data
    # Use -w option to set the timeout in seconds
    # Use &>/dev/null to redirect both stdout and stderr to /dev/null
    nc -z -w 1 localhost $port &>/dev/null
    if [ $? -ne 0 ]; then
      print_info "Port $port is available, assigning it to user $user"
      vnc_port=$(($port-5900)) 
      break
    fi
  done
}

# Define a function to create a VNC user and set its password
create_vnc_user() {
  print_info "Creating VNC user $user..."
  su - "$user" -c "vncpasswd <<EOF
$pass
$pass
n
EOF"
  check_error "Fail to set VNC password"
  print_info "VNC password configuration successful"
}

change_configuration(){
  # Modify the VNC resolution to 1920x1080
  su - "$user" -c "echo 'geometry=1920x1080' >> ~/.vnc/config"
  check_error "Fail to set VNC resolution"
  print_info "VNC resolution configuration successful"
}

start_service(){
      # Copy the VNC server configuration file
      # Use a different file name for each user to avoid overwriting
      cp /lib/systemd/system/vncserver@.service "/etc/systemd/system/vncserver-"$user"@:"$vnc_port".service"
      check_error "Fail to set copy vncserver file"

      # Use sed command to replace the port number in the VNC configuration file
      sed -i "s/<USER>/"$user"/g" "/etc/systemd/system/vncserver-"$user"@:"$vnc_port".service"
      check_error "Fail to set VNC user in vncserver file"

      # Reload the systemd daemon
      systemctl daemon-reload
      check_error "Fail to reload the systemd daemon"
      # Start the VNC service
      systemctl start "vncserver-"$user"@:"$vnc_port".service"
      check_error "Fail to start the VNC service"
      # Enable the VNC service
      systemctl enable "vncserver-"$user"@:"$vnc_port".service"
      check_error "Fail to enable the VNC service"
      # Check the VNC service status
      systemctl status "vncserver-"$user"@:"$vnc_port".service"
      check_error "Fail to check the VNC service status"
      print_info "Start vnc server successful"
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
  print_info "VNC user and password added successfully"
  print_info "username: $user"
  print_info "VNC password: $pass"
  print_info "The eth0 address of this container is: $(ifconfig eth0 | grep "inet" | awk '{print $2}')"
  print_info "The lo address of this container is: $(ifconfig lo | grep "inet" | awk '{print $2}')"
  print_info "VNC server is installed and configured on port $port"
  print_info "The VNC ip maybe "$(ifconfig eth0 | grep "inet" | awk '{print $2}')":$port or "$(ifconfig lo | grep "inet" | awk '{print $2}')":$port"
}

# Call the functions
check_input
check_port
create_vnc_user
change_configuration
start_service
stop_firewall
print_successful

