#!/bin/bash

LOGFILE="/tmp/usbip_attach.log"
echo "[$(date)] Attaching USB devices from InputBox..." | tee -a $LOGFILE

# Wait for network to be ready
sleep 15

# Load necessary kernel module
modprobe vhci-hcd
echo "[$(date)] Loaded vhci-hcd module" | tee -a $LOGFILE

# InputBox IP
SERVER_IP="192.168.50.1"

# Define USB device (Vendor:Product ID)
USB_ID="345f:2130"

# Retry loop: Wait for the USB device to become available
TRIES=0
MAX_TRIES=30  # Increased from 10 to 30 retries (2.5 minutes max)

while [[ $TRIES -lt $MAX_TRIES ]]; do
    BUSID=$(usbip list -r $SERVER_IP | grep "$USB_ID" | awk '{print $1}' | tr -d ':')

    if [[ -n "$BUSID" ]]; then
        echo "[$(date)] Found device on InputBox: $BUSID" | tee -a $LOGFILE
        break
    fi

    echo "[$(date)] Device not found, retrying in 5 seconds... ($TRIES/$MAX_TRIES)" | tee -a $LOGFILE
    ((TRIES++))
    sleep 5
done

# If no device was found after retries, exit
if [[ -z "$BUSID" ]]; then
    echo "[$(date)] USB device $USB_ID not found after multiple retries. Exiting." | tee -a $LOGFILE
    exit 1
fi

# Force attach the device if found
for i in {1..5}; do
    usbip attach -r $SERVER_IP -b $BUSID
    sleep 2
    ATTACHED=$(usbip port | grep "Port" | grep -E "In Use|Super Speed|unknown vendor")

    if [[ -n "$ATTACHED" ]]; then
        echo "[$(date)] Successfully attached USB device: $USB_ID (Bus ID: $BUSID)" | tee -a $LOGFILE
        usbip port | tee -a $LOGFILE
        lsusb | tee -a $LOGFILE
        exit 0
    fi

    echo "[$(date)] Attach failed, retrying ($i/5)..." | tee -a $LOGFILE
    sleep 5
done

echo "[$(date)] WARNING: Device may have attached but was not detected by the script. Check usbip port manually." | tee -a $LOGFILE
exit 1
