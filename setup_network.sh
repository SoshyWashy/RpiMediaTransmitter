#!/bin/bash

echo "Select device type:"
echo "1) InputBox (HDMI & USB Capture)"
echo "2) OutputBox (USB Passthrough & HDMI Output)"
read -p "Enter choice (1 or 2): " choice

if [[ $choice -eq 1 ]]; then
    echo "Setting up InputBox..."

    nmcli connection modify preconfigured ipv4.route-metric 100
    nmcli connection modify eth0 ipv4.addresses 192.168.50.1/24 ipv4.method manual
    nmcli connection modify eth0 ipv4.route-metric 200
    nmcli connection modify eth0 ipv4.gateway ""

    echo "InputBox setup complete."

elif [[ $choice -eq 2 ]]; then
    echo "Setting up OutputBox..."

    nmcli connection modify preconfigured ipv4.route-metric 100
    nmcli connection modify eth0 ipv4.addresses 192.168.50.2/24 ipv4.method manual
    nmcli connection modify eth0 ipv4.route-metric 200
    nmcli connection modify eth0 ipv4.gateway ""

    echo "OutputBox setup complete."

else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Restart network connections
nmcli connection down eth0 && nmcli connection up eth0
nmcli connection down preconfigured && nmcli connection up preconfigured

# Log the setup
ip route > /tmp/network_setup.log

