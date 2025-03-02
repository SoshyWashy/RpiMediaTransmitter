#!/bin/bash

echo "Attaching USB devices from InputBox..."

# Load necessary kernel module
modprobe vhci-hcd

# InputBox IP
SERVER_IP="192.168.50.1"

# Define USB device (Vendor:Product ID)
USB_ID="345f:2130"

# Find the correct bus ID dynamically on InputBox
BUSID=$(usbip list -r $SERVER_IP | grep "$USB_ID" | awk '{print $1}')

# Attach USB device if found
if [ -n "$BUSID" ]; then
    usbip attach -r $SERVER_IP -b $BUSID
    echo "Attached USB device: $USB_ID (Bus ID: $BUSID)"
else
    echo "USB device $USB_ID not found on InputBox."
fi
