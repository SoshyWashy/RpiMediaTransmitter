#!/bin/bash

echo "Detaching USB devices from InputBox..."

# Find all attached USB devices and detach them
for PORT in $(usbip port | grep '<Port in Use>' | awk '{print $2}'); do
    usbip detach --port=$PORT
    echo "Detached USB device from port: $PORT"
done
