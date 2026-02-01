#!/bin/sh

# 1. Configuration
PARTIAL_LIST="f5d93fc7d 4b1f95c13"
INIT_SCRIPT="setup/setup.sh"
PREFER_MOUNT="/mnt/sdb1"

log_msg() {
    logger -t "DISK_INIT" "$1"
    [ -d "$FINAL_PATH/setup" ] && echo "$(date): $1" >> "$FINAL_PATH/setup/boot.log"
}

# 2. Match UUID and get Device Path
FULL_UUID=""
DEV_NAME=""

for p_uuid in $PARTIAL_LIST; do
    # 查找包含该 UUID 的行，并提取开头的设备路径 (如 /dev/sdb1)
    MATCH_LINE=$(block info | grep -i "$p_uuid")
    if [ -n "$MATCH_LINE" ]; then
        FULL_UUID=$(echo "$MATCH_LINE" | grep -oE 'UUID="[^"]+"' | cut -d'"' -f2)
        DEV_NAME=$(echo "$MATCH_LINE" | cut -d':' -f1)
        break
    fi
done

if [ -z "$DEV_NAME" ]; then
    logger -t "DISK_INIT" "No matching UUID found in block info."
    exit 1
fi

# 3. Determine Mount Point
# Check if the device is already mounted anywhere
CURRENT_MOUNT=$(grep "^$DEV_NAME " /proc/mounts | awk '{print $2}' | head -n 1)

if [ -n "$CURRENT_MOUNT" ]; then
    FINAL_PATH="$CURRENT_MOUNT"
    log_msg "Device $DEV_NAME already mounted at $FINAL_PATH"
else
    # Choose mount point: prefer /mnt/sdb1 if not occupied
    if ! grep -q "$PREFER_MOUNT" /proc/mounts; then
        FINAL_PATH="$PREFER_MOUNT"
    else
        FINAL_PATH="/mnt/disk-$(echo $FULL_UUID | cut -c1-8)"
    fi
    
    mkdir -p "$FINAL_PATH"
    log_msg "Mounting $DEV_NAME to $FINAL_PATH"
    
    # 使用设备名进行挂载
    if mount -t ext4 "$DEV_NAME" "$FINAL_PATH"; then
        log_msg "Mount successful."
    else
        log_msg "Error: Failed to mount $DEV_NAME"
        exit 1
    fi
fi

# 4. Execute setup.sh
TARGET_EXEC="$FINAL_PATH/$INIT_SCRIPT"
if [ -f "$TARGET_EXEC" ]; then
    log_msg "Running setup script..."
    cd "$(dirname "$TARGET_EXEC")"
    sh "./$(basename "$INIT_SCRIPT")" "$FINAL_PATH" >> "$FINAL_PATH/setup/setup_output.log" 2>&1
    
    log_msg "Setup done. Self-destructing trigger."
    sed -i '/myinit.sh/d' /etc/rc.local
else
    log_msg "Error: $TARGET_EXEC not found."
fi