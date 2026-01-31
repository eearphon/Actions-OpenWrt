#!/bin/sh

# 配置参数
PARTIAL_UUID="f5d93fc7d"
INIT_SCRIPT="setup/setup.sh"
PREFER_MOUNT="/mnt/sdb1"

# 1. 动态获取完整 UUID
FULL_UUID=$(block info | grep -i "$PARTIAL_UUID" | grep -oE 'UUID="[^"]+"' | cut -d'"' -f2 | head -n 1)
[ -z "$FULL_UUID" ] && { logger -t "DISK_INIT" "未发现匹配硬盘"; exit 1; }

# 2. 寻找当前挂载点
DEV_NAME=$(block info | grep "$FULL_UUID" | cut -d':' -f1)
CURRENT_MOUNT=$(grep "^$DEV_NAME " /proc/mounts | awk '{print $2}' | head -n 1)

if [ -n "$CURRENT_MOUNT" ]; then
    FINAL_PATH="$CURRENT_MOUNT"
    logger -t "INIT_BOOT" "设备已挂载在: $FINAL_PATH"
else
    # 尝试挂载逻辑
    if ! grep -q "$PREFER_MOUNT" /proc/mounts; then
        FINAL_PATH="$PREFER_MOUNT"
    else
        FINAL_PATH="/mnt/disk-$FULL_UUID"
    fi
    mkdir -p "$FINAL_PATH"
    mount -t ext4 -U "$FULL_UUID" "$FINAL_PATH" || exit 1
fi

# 3. 执行硬盘上的 setup.sh
TARGET_EXEC="$FINAL_PATH/$INIT_SCRIPT"
if [ -f "$TARGET_EXEC" ]; then
    logger -t "DISK_INIT" "开始执行 $TARGET_EXEC"
    cd "$(dirname "$TARGET_EXEC")"
    sh "./$(basename "$INIT_SCRIPT")" "$FINAL_PATH"
    
    # 4. 执行成功后，清理 rc.local 中的触发行并重启
    logger -t "DISK_INIT" "任务完成，清理触发器并重启..."
    sed -i '/myinit.sh/d' /etc/rc.local
    sleep 2
    reboot
else
    logger -t "DISK_INIT" "未找到脚本: $TARGET_EXEC"
fi