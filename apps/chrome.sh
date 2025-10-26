#!/bin/bash

# Script to install Google Chrome stable on Fedora if not already installed

echo "Checking if Google Chrome is already installed..."

# Check if google-chrome-stable is installed
if rpm -q google-chrome-stable &> /dev/null; then
    echo "Google Chrome stable is already installed."
    google-chrome-stable --version
    exit 0
fi

echo "Google Chrome stable is not installed. Installing now..."

# Check if we can run sudo without prompting (i.e., credentials cached or NOPASSWD)
if sudo -n true 2>/dev/null; then
    echo "Sudo access confirmed."
else
    echo ""
    echo "This script requires sudo privileges to install Chrome."
    echo "Please run: sudo -v"
    echo "Then run this script again."
    echo ""
    echo "Alternatively, run the script with: sudo bash $0"
    exit 1
fi

# Download the Chrome RPM package
CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
CHROME_RPM="/tmp/google-chrome-stable_current_x86_64.rpm"

echo "Downloading Google Chrome..."
if wget -q --show-progress -O "$CHROME_RPM" "$CHROME_URL"; then
    echo "Download completed successfully."
else
    echo "Error: Failed to download Google Chrome."
    exit 1
fi

# Install the RPM package
echo "Installing Google Chrome..."
if timeout 300 sudo dnf install -y --nogpgcheck "$CHROME_RPM" 2>&1 | grep -v "^\s*$"; then
    echo "Google Chrome installed successfully!"
    google-chrome-stable --version
else
    EXITCODE=${PIPESTATUS[0]}
    if [ $EXITCODE -eq 124 ]; then
        echo "Error: Installation timed out after 5 minutes."
    else
        echo "Error: Failed to install Google Chrome."
    fi
    rm -f "$CHROME_RPM"
    exit 1
fi

# Clean up the downloaded RPM
rm -f "$CHROME_RPM"
echo "Installation complete and cleanup done."
