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
# CONFIG_PACKAGE_autosamba is not set
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_PACKAGE_luci-app-transmission=y
CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y
EOF

#CONFIG_PACKAGE_ipv6helper=y

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

#luci-app-alist
rm -rf package/alist
git clone https://github.com/sbwml/luci-app-alist package/alist
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-alist=y
EOF

#luci-app-aliyundrive-webdav
git clone --single-branch https://github.com/messense/aliyundrive-webdav
rm -rf feeds/packages/multimedia/aliyundrive-webdav feeds/luci/applications/luci-app-aliyundrive-webdav
cp -a aliyundrive-webdav/openwrt/aliyundrive-webdav feeds/packages/multimedia/
cp -a aliyundrive-webdav/openwrt/luci-app-aliyundrive-webdav feeds/luci/applications/
rm -rf aliyundrive-webdav

#rclone
sed -i 's/PKG_VERSION:=1.61.1/PKG_VERSION:=1.66.0/' feeds/packages/net/rclone/Makefile
sed -i 's/PKG_HASH:=f9fb7bae1f19896351db64e3713b67bfd151c49b2b28e6c6233adf67dbc2c899/PKG_HASH:=9249391867044a0fa4c5a948b46a03b320706b4d5c4d59db9d4aeff8d47cade2/' feeds/packages/net/rclone/Makefile
