#!/bin/bash
# secure-ssh.sh
# Author: Thomas Marshall
# Purpose: Create a user with SSH key-based authentication only
# Usage: ./secure-ssh.sh <username>

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root (use sudo)"
    exit 1
fi

# Check if username parameter provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    echo "Example: $0 testuser"
    exit 1
fi

USERNAME=$1

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists"
    exit 1
fi

# Create user
useradd -m -s /bin/bash $USERNAME

# Setup SSH directory
mkdir -p /home/$USERNAME/.ssh
cp /root/repos/SYS-265/SYS265/linux/keys/web01.pub /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

echo "User $USERNAME created successfully"
