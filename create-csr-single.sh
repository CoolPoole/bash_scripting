#!/bin/bash

# Variables
domain=$1
key_file="$domain.key"
csr_file="$domain.csr"
output_folder="$domain"
altName="DNS:$domain"

# Make Directory
mkdir -p $output_folder

# Create Configuration File
echo "Creating configuration file..."

cat <<EOF > $output_folder/$domain.cfg
HOME                    = .

[ req ]
default_bits            = 2048
default_md              = sha256
distinguished_name      = req_distinguished_name
attributes              = req_attributes
prompt                  = no
encrypt_key             = no
req_extensions          = v3_req
string_mask             = nombstr

[ req_distinguished_name ]
countryName             = US
0.organizationName      = <org>
0.organizationalUnitName    = <something>
1.organizationalUnitName    = <something>
2.organizationalUnitName    = <something>

commonName              = $domain

[ req_attributes ]

[ v3_req ]
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
extendedKeyUsage        = serverAuth, clientAuth
subjectAltName          = $altName

EOF

# Generate Private Key
echo "Generating Private Key..."
openssl genrsa -out "$output_folder/$key_file" 2048

# Verify that the key was created
echo "Key created..."
openssl rsa -in "$output_folder/$key_file" -text

# Generate Certificate Signing Request
echo "Generating Certificate Signing Request..."
openssl req -new -key "$output_folder/$key_file" -out "$output_folder/$csr_file" -config "$output_folder/$domain.cfg"
echo "Certificate Signing Request created..."