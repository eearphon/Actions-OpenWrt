#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

rm -rf .config tmp/
make defconfig
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-frps=y
CONFIG_PACKAGE_luci-app-hd-idle=y
CONFIG_PACKAGE_luci-app-minidlna=y
CONFIG_PACKAGE_luci-app-nfs=y
CONFIG_PACKAGE_luci-app-softethervpn=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_open-vm-tools=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_screen=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-ssr-plus=y
CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-rclone=y
CONFIG_PACKAGE_kmod-fuse=y
# CONFIG_PACKAGE_automount is not set
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_PACKAGE_luci-app-transmission=y
CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_ftp=y
CONFIG_BUSYBOX_CUSTOM=y
CONFIG_BUSYBOX_CONFIG_TELNET=y
CONFIG_VMDK_IMAGES=y
EOF

sed -i '\#^exit 0#i\[ -f /mnt/sdb1/setup/setup.sh \] \&\& /mnt/sdb1/setup/setup.sh' package/base-files/files/etc/rc.local
