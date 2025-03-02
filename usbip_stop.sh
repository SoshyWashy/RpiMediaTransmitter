#!/bin/bash

echo "Stopping USBIP on InputBox..."

# Unbind all devices dynamically
for BUSID in $(usbip list -p -l | grep "Exported" | awk '{print $2}' | tr -d ':'); do
    # Get device information
    DEVICE_INFO=$(usbip list -p -l | grep "$BUSID")
    DEVICE_NAME=$(echo "$DEVICE_INFO" | awk -F'(' '{print $2}' | awk -F')' '{print $1}')
    DEVICE_ID=$(echo "$DEVICE_INFO" | awk '{print $4}' | tr -d ':')

    # Unbind the USB device
    usbip unbind --busid=$BUSID
    echo "Unbound: Name='$DEVICE_NAME', BusID='$BUSID', DeviceID='$DEVICE_ID'"
done

# Stop USBIP daemon
killall usbipd
