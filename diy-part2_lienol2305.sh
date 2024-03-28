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
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

rm -rf .config tmp/
cat >> .config <<EOF
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_ROOTFS_PARTSIZE=400
CONFIG_VMDK_IMAGES=y
CONFIG_PACKAGE_open-vm-tools=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-frps=y
CONFIG_PACKAGE_luci-app-hd-idle=y
CONFIG_PACKAGE_luci-app-minidlna=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_screen=y
CONFIG_PACKAGE_kmod-fuse=y
CONFIG_PACKAGE_luci-app-dockerman=y
EOF

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

rm -rf package/alist
git clone https://github.com/sbwml/luci-app-alist package/alist
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-alist=y
EOF
