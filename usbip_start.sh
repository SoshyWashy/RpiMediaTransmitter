#!/bin/bash

echo "Starting USBIP on InputBox..."

# Load necessary kernel modules
modprobe usbip_host

# Define USB device (Vendor:Product ID)
USB_ID="345f:2130"

# Find the correct bus ID dynamically based on Vendor:Product ID
BUSID=$(usbip list -p -l | grep "$USB_ID" | awk -F'#' '{print $1}' | cut -d'=' -f2)

# Bind the USB device if found
if [ -n "$BUSID" ]; then
    usbip bind --busid=$BUSID
    echo "Bound USB device: $USB_ID at BusID: $BUSID"
else
    echo "USB device $USB_ID not found."
fi

# Start USBIP daemon
usbipd -D

