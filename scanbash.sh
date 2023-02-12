#!/bin/bash

# Function to check if a port is open
check_port() {
  local host=$1
  local port=$2

  # Use netcat to check if the port is open
  nc -z -w 1 $host $port > /dev/null 2>&1

  # If exit status of the above command is 0, the port is open
  if [ $? -eq 0 ]; then
    echo "Port $port is open on $host"
  fi
}

# Get the host from the user
echo -n "Enter the IP address or hostname: "
read host

# Check if the host is reachable
ping -c 1 $host > /dev/null 2>&1

# If the host is reachable, check for open ports
if [ $? -eq 0 ]; then
  for port in {1..65535}; do
    # Use a subshell to run the check_port function in the background
    ( check_port $host $port ) &
  done

  # Wait for all background processes to finish
  wait
else
  echo "Host is unreachable"
fi

