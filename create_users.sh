#!/bin/bash

# Function to generate a random password
generate_password() {
    local password_length=12
    tr -dc A-Za-z0-9 </dev/urandom | head -c ${password_length} ; echo ''
}

# Check if the input file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
log_file="/var/log/user_management.log"
password_file="/var/secure/user_passwords.txt"

# Ensure the log and password files exist
touch $log_file
mkdir -p /var/secure
touch $password_file
chmod 600 $password_file

# Debugging statements
echo "Password file created at $password_file"

# Read the input file and process each line
while IFS=';' read -r username groups; do
    echo "Processing $username with groups $groups"  # Debug statement

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists, skipping..." | tee -a $log_file
        continue
    fi

    # Create the user and personal group
    useradd -m "$username"
    echo "Created user $username" | tee -a $log_file

    # Generate a random password
    password=$(generate_password)
    echo "Generated password for $username is $password"  # Debug statement
    echo "$username:$password" | sudo chpasswd
    echo "Password set for user $username"  # Debug statement
    echo "$username,$password" | sudo tee -a $password_file
    echo "Password for $username written to $password_file"  # Debug statement

    # Assign the user to the specified groups
    IFS=',' read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        # Create group if it does not exist
        if ! getent group "$group" >/dev/null; then
            groupadd "$group"
            echo "Created group $group" | tee -a $log_file
        fi
        usermod -aG "$group" "$username"
        echo "Added user $username to group $group" | tee -a $log_file
    done

done < "$input_file"

echo "User creation and password assignment completed."