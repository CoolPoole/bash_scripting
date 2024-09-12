#!/bin/bash

# Variables
file_name=$1

# Function to check HTTP Response Code for a given IP address
check_http_response() {
    ip_address="$1"
    response_code=$(curl -k -s -o /dev/null -w "${http_code}" "https://${ip_address}")
    echo "${ip_address}: ${response_code}"
}

# Read IP Address from a file
while IFS= read -r ip_address; do
    check_http_response "$ip_address"
done < "${file_name}"