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
cat >> .config <<EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_newifi-d1=y
CONFIG_PACKAGE_luci-app-frpc=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_screen=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-samba=y
CONFIG_PACKAGE_luci-app-turboacc=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_kmod-fs-ext4=y
CONFIG_PACKAGE_kmod-fs-ntfs=y
CONFIG_PACKAGE_kmod-fs-vfat=y
CONFIG_PACKAGE_kmod-sdhci-mt7620=y
CONFIG_PACKAGE_kmod-usb-storage-extras=y
CONFIG_PACKAGE_kmod-usb-storage=y
CONFIG_PACKAGE_lsblk=y
CONFIG_PACKAGE_luci-app-usb-printer=y
CONFIG_PACKAGE_luci-app-p910nd=y
CONFIG_PACKAGE_fdisk=y
CONFIG_PACKAGE_parted=y
CONFIG_PACKAGE_usbutils=y
EOF

#repair# Error: opcode not supported on this processor: mips2 (mips2) `sync'
sed -i -e '/PKG_USE_MIPS16:=0/d' -e '/PKG_BUILD_FLAGS/i\PKG_USE_MIPS16:=0' feeds/passwall_packages/dns2tcp/Makefile
