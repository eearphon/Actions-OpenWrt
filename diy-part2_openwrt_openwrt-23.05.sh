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
CONFIG_TARGET_x86=y
CONFIG_TARGET_x86_64=y
CONFIG_TARGET_ROOTFS_PARTSIZE=400
CONFIG_VMDK_IMAGES=y
CONFIG_PACKAGE_luci=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_luci-app-ddns=y
CONFIG_PACKAGE_open-vm-tools=y
# CONFIG_PACKAGE_dnsmasq is not set
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-transmission=y
CONFIG_PACKAGE_luci-app-samba4=y
CONFIG_PACKAGE_luci-app-frps=y
CONFIG_PACKAGE_luci-app-hd-idle=y
CONFIG_PACKAGE_luci-app-minidlna=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_screen=y
CONFIG_PACKAGE_kmod-fuse=y
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_transmission-web-control=y
CONFIG_PACKAGE_block-mount=y
CONFIG_PACKAGE_dockerd=y
EOF

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

rm -rf package/alist
git clone https://github.com/sbwml/luci-app-alist package/alist
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-alist=y
EOF

sed -i '/^PKG_SOURCE_DATE:=/c\PKG_SOURCE_DATE:=2024-03-20' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_SOURCE_VERSION:=/c\PKG_SOURCE_VERSION:=9018e35d12d2e20c9ec01b8a858ecaa2c3ce96f4' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=2114a78d15d274a3b4fc5bc349d6de92969fa172ccc1e4359c7e228e9181185c' feeds/packages/net/transmission-web-control/Makefile
sed -i '/DEPENDS:=/d' feeds/packages/net/transmission-web-control/Makefile

git clone https://github.com/eearphon/Rclone-OpenWrt package/Rclone-OpenWrt
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-rclone=y
EOF
