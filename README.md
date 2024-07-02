# User Management Script

This repository contains a Bash script for automating user and group management on a Linux system. The script reads a text file containing usernames and group names, creates users, assigns them to groups, generates random passwords, and logs all actions.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [File Descriptions](#file-descriptions)
- [Logging and Security](#logging-and-security)


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
    
    - Paste the content into create_users.sh.

2. *Create and edit the users.txt input file*:
    bash
    notepad users.txt
    
    - Add the usernames and group names in the specified format.

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

