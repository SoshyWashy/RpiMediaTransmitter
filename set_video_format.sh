#!/bin/bash

LOGFILE="/tmp/set_video_format.log"
DEVICE="/dev/video0"

echo "[$(date)] Waiting for 30 seconds" | tee -a $LOGFILE
sleep 30 # just another wait to raise the chance that video0 is online in the time frame of the loop below

echo "[$(date)] Waiting for video device to be ready..." | tee -a $LOGFILE

# Wait until /dev/video0 appears
for i in {1..20}; do
    if [ -e "$DEVICE" ]; then
        echo "[$(date)] Video device found: $DEVICE" | tee -a $LOGFILE
        break
    fi
    echo "[$(date)] Video device not found, retrying in 5s..." | tee -a $LOGFILE
    sleep 5
done

# If the device is still missing, log an error and exit
if [ ! -e "$DEVICE" ]; then
    echo "[$(date)] ERROR: Video device not detected. Exiting..." | tee -a $LOGFILE
    exit 1
fi

echo "[$(date)] Setting video format and FPS..." | tee -a $LOGFILE
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=MJPG
sleep 2  # Wait a little before setting FPS
v4l2-ctl --set-parm=30

echo "[$(date)] Verifying FPS setting..." | tee -a $LOGFILE
v4l2-ctl --get-parm | tee -a $LOGFILE
