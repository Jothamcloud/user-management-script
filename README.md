# User Management Script

This repository contains a Bash script for automating user and group management on a Linux system. The script reads a text file containing usernames and group names, creates users, assigns them to groups, generates random passwords, and logs all actions.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [File Descriptions](#file-descriptions)
- [Logging and Security](#logging-and-security)
- [Contributing](#contributing)
- [License](#license)

## Overview

Managing user accounts and groups manually can be time-consuming and error-prone. This script automates the process, ensuring consistency and security. It's particularly useful for administrators managing multiple users in a Linux environment.

## Prerequisites

- A Linux environment (tested on Amazon Linux 2)
- Basic knowledge of Linux commands and Bash scripting
- An SSH client to connect to your server

## Setup

### Create the Script and Input File

1. *Create and edit the create_users.sh script file*:
    bash
    notepad create_users.sh
    
    - Paste the following content into create_users.sh:
      bash
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
      

2. *Create and edit the users.txt input file*:
    bash
    notepad users.txt
    
    - Add the following content:
      text
      dave;sudo,dev,www-data
      erin;sudo
      frank;dev,www-data
      

## Usage

1. *Make the script executable*:
    bash
    chmod +x create_users.sh
    

2. *Run the script with the input file*:
    bash
    sudo ./create_users.sh users.txt
    

3. *Verify the users were created*:
    - Check the /etc/passwd file:
        bash
        cat /etc/passwd
        
    - Verify the password file:
        bash
        sudo cat /var/secure/user_passwords.txt
        
    - Review the log file:
        bash
        sudo cat /var/log/user_management.log
        

## File Descriptions

- create_users.sh: The main Bash script that automates user and group management.
- users.txt: A sample input file containing usernames and group names.

## Logging and Security

- *Log File*: Actions performed by the script are logged in /var/log/user_management.log.
- *Password File*: Generated passwords are stored securely in /var/secure/user_passwords.txt with restricted permissions.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This README provides a comprehensive overview of your project, its setup, usage, and other important details. You can now include this README file in your GitHub repository to help others understand and use your project.
