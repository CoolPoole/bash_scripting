#!/bin/bash

# Function to check HTTP(S) response code for an IP Address
check_http_response() {
    ip_address="$1"
    protocol="$2"
    response_code=$(curl -k -s -o /dev/null -w "$%{http_code}" "${protocol}://${ip_address}")
    echo "${ip_address}: ${response_code}"
}

# Function to generate IP Addresses for a given subnet
generate_ips() {
    subnet="$1"
    start_ip=$(echo "$subnet" | cut -d/ -f1)
    prefix_length=$(echo "$subnet" | cut -d/ -f2)
    bits_in_subnet=$(expr 32 - $prefix_length)
    hosts_in_subnet=$(( 2**bits_in_subnet - 2 ))

    ip_address=$(echo "$start_ip" | awk -F '.' '{printf "%d.%d.%d.%d\n", $1, $2, $3, $4}')

    for i in $(seq 1 $hosts_in_subnet); do
        ip_address=$(echo "$ip_address" | awk -F '.' '{printf "%d.%d.%d.%d\n", $1, $2, $3, $4 + 1}')
        echo "$ip_address"
    done
}

# Read Subnet/Protocol from User
read -p "Enter the subnet (e.g., 192.168.1.0/24): " subnet
read -p "Enter protocol (e.g., http or https): " protocol

# Generate IP addresses within subnet
ips=$(generate_ips "$subnet")

# Iterate IP addresses and check for HTTP response codes
for ip_address in $ips; do
    check_http_response "$ip_address" "$protocol"
done