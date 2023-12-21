#!/bin/bash
# This script is for change the user password on CentOS 7
# Usage: ./change_password.sh user [password]
# default setting [user=$USER] [password=$USER]

# Get the number of input parameters
num=$#
# If there are no parameters, use the current user's username and password
if [ $num -eq 1 ]; then
  user=$1
  pass=$1
# If there are two parameters, use the first parameter as the username and the second parameter as the password
elif [ $num -eq 2 ]; then
  user=$1
  pass=$2
# If the number of parameters is illegal, prompt usage and exit
else
  echo -e "Script input error, correct input method is as follows:\n\
$0 username [password]"
  exit 1
fi

# Check if the entered username exists.
if ! id $user &> /dev/null; then
  echo "$user not found, please add user"
fi

# Prompt the user to enter the sudo password
echo "Please enter your sudo password:"
read -s password

# Use the echo command and pipeline to pass the password to the passwd command, and use the -- stdin option to have the passwd command read the new password from standard input
# Add sudo command before echo and passwd
echo $password | sudo -S passwd --stdin $user
# Determine the result of password modification. If successful, display the password modification as successful. If unsuccessful, display the password modification as failed
if [ $? -eq 0 ]; then
  echo -e "\
  Password modification successful\n\
  user $user is added and the password is $pass"
else
  echo "Password modification failed"
fi