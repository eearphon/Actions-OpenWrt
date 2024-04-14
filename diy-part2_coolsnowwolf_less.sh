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

# Default settings
[ -f $GITHUB_WORKSPACE/99-default-settings ] && cp -f $GITHUB_WORKSPACE/99-default-settings package/base-files/files/etc/uci-defaults/

rm -rf .config tmp/
make defconfig
cat >> .config <<EOF
CONFIG_PACKAGE_bash=y
CONFIG_PACKAGE_open-vm-tools=y
CONFIG_PACKAGE_screen=y
# CONFIG_PACKAGE_automount is not set
# CONFIG_PACKAGE_autosamba is not set
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
EOF

sed -i '/^PKG_SOURCE_DATE:=/c\PKG_SOURCE_DATE:=2024-04-09' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_SOURCE_VERSION:=/c\PKG_SOURCE_VERSION:=f02a47aff2680de10c2269e22a3d0b37a318dbcd' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=265e413f24427dda4ec4a4bb24d67876ebe6245850bd27855bc6f475a923094f' feeds/packages/net/transmission-web-control/Makefile
sed -i '/DEPENDS:=/d' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/transmission\/web/transmission\/public_html/g' feeds/packages/net/transmission-web-control/Makefile
cat >> .config <<EOF
CONFIG_PACKAGE_transmission-web-control=y
EOF

#Fri Mar 29 19:02:39 CST 2024
sed -i '/^KERNEL_PATCHVER:=/c\KERNEL_PATCHVER:=5.15' target/linux/x86/Makefile
