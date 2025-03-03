#!/bin/bash

LOGFILE="/tmp/set_video_format.log"
DEVICE="/dev/video0"

echo "[$(date)] Setting video format for $DEVICE..." | tee -a $LOGFILE
v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=MJPG
RESULT=$?

if [[ $RESULT -eq 0 ]]; then
    echo "[$(date)] Successfully set video format." | tee -a $LOGFILE
else
    echo "[$(date)] ERROR: Failed to set video format." | tee -a $LOGFILE
fi
