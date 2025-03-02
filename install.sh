#!/bin/bash

echo "Installing network configuration scripts..."

# Move network setup script to /usr/local/bin
sudo cp setup_network.sh /usr/local/bin/setup_network.sh
sudo chmod +x /usr/local/bin/setup_network.sh

# Move systemd service file
sudo cp network-setup.service /etc/systemd/system/network-setup.service

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable network-setup.service
sudo systemctl start network-setup.service

echo "Installation complete. Rebooting to apply settings..."
sudo reboot
