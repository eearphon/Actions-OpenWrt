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
CONFIG_TARGET_ramips_mt7621_DEVICE_xiaomi_redmi-router-ac2100=y
CONFIG_PACKAGE_luci-app-nfs=y
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_iperf3=y
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_screen=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
# CONFIG_PACKAGE_automount is not set
# CONFIG_PACKAGE_autosamba is not set
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
CONFIG_PACKAGE_luci-app-aliyundrive-webdav=y
EOF

#CONFIG_PACKAGE_ipv6helper=y

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang
