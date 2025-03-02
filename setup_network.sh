#!/bin/bash

# Ensure preconfigured (wlan0 equivalent) remains the default route
nmcli connection modify preconfigured ipv4.route-metric 100

# Ensure eth0 is used only for local traffic (192.168.50.0/24)
nmcli connection modify eth0 ipv4.route-metric 200
nmcli connection modify eth0 ipv4.gateway ""

# Restart network connections to apply changes
nmcli connection down eth0 && nmcli connection up eth0
nmcli connection down preconfigured && nmcli connection up preconfigured

# Verify routing table (for debugging)
ip route > /tmp/network_setup.log
echo "Network setup complete. wlan0 (preconfigured in this case) is the default route." >> /tmp/network_setup.log
