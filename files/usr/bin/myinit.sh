#!/bin/sh

# 1. Configuration
PARTIAL_LIST="f5d93fc7d 4b1f95c13"
INIT_SCRIPT="setup/setup.sh"
PREFER_MOUNT="/mnt/sdb1"

FULL_UUID=""

# 2. Match Partial UUID from the list
for p_uuid in $PARTIAL_LIST; do
    logger -t "DISK_INIT" "Trying to match prefix: $p_uuid"
    MATCH=$(block info | grep -i "$p_uuid" | grep -oE 'UUID="[^"]+"' | cut -d'"' -f2 | head -n 1)
    
    if [ -n "$MATCH" ]; then
        FULL_UUID="$MATCH"
        logger -t "DISK_INIT" "Matched Full UUID: $FULL_UUID"
        break
    fi
done

# 3. Exit if no device found
if [ -z "$FULL_UUID" ]; then
    logger -t "DISK_INIT" "Error: No matching device found. Exiting."
    exit 1
fi

# 4. Locate device name and current mount point
DEV_NAME=$(block info | grep "$FULL_UUID" | cut -d':' -f1)
CURRENT_MOUNT=$(grep "^$DEV_NAME " /proc/mounts | awk '{print $2}' | head -n 1)

if [ -n "$CURRENT_MOUNT" ]; then
    FINAL_PATH="$CURRENT_MOUNT"
    logger -t "DISK_INIT" "Device already mounted at: $FINAL_PATH"
else
    # 5. Handle Mounting
    if ! grep -q "$PREFER_MOUNT" /proc/mounts; then
        FINAL_PATH="$PREFER_MOUNT"
        logger -t "DISK_INIT" "Using preferred path: $FINAL_PATH"
    else
        FINAL_PATH="/mnt/disk-$FULL_UUID"
        logger -t "DISK_INIT" "Preferred path busy, using: $FINAL_PATH"
    fi

    mkdir -p "$FINAL_PATH"
    if mount -t ext4 -U "$FULL_UUID" "$FINAL_PATH"; then
        logger -t "DISK_INIT" "Mount successful."
    else
        logger -t "DISK_INIT" "Error: Mount failed. Check filesystem."
        exit 1
    fi
fi

# 6. Execute setup script
TARGET_EXEC="$FINAL_PATH/$INIT_SCRIPT"
if [ -f "$TARGET_EXEC" ]; then
    logger -t "DISK_INIT" "Executing: $TARGET_EXEC"
    
    cd "$(dirname "$TARGET_EXEC")"
    # Pass final path as $1 to setup.sh
    sh "./$(basename "$INIT_SCRIPT")" "$FINAL_PATH"
    
    # 7. Cleanup rc.local trigger and reboot
    logger -t "DISK_INIT" "Setup finished. Removing trigger."
    sed -i '/myinit.sh/d' /etc/rc.local
else
    logger -t "DISK_INIT" "Error: Script not found at $TARGET_EXEC"
fi