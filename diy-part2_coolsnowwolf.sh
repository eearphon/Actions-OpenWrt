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
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-rclone=y
CONFIG_PACKAGE_kmod-fuse=y
# CONFIG_PACKAGE_automount is not set
# CONFIG_PACKAGE_autosamba is not set
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_luci-proto-ipv6=y
CONFIG_PACKAGE_odhcp6c=y
CONFIG_PACKAGE_odhcpd-ipv6only=y
EOF

#CONFIG_PACKAGE_ipv6helper=y

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

rm -rf package/alist
git clone https://github.com/sbwml/luci-app-alist package/alist
cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-alist=y
EOF

git clone --single-branch https://github.com/openwrt/packages myfeeds/packages
git clone --single-branch https://github.com/openwrt/luci myfeeds/luci
rm -rf feeds/packages/net/transmission
cp -a myfeeds/packages/net/transmission feeds/packages/net/
#cp -a myfeeds/packages/net/transmission-web-control feeds/packages/net/
#cp -a myfeeds/luci/applications/luci-app-transmission feeds/luci/applications/
rm -rf myfeeds

sed -i '/^PKG_SOURCE_DATE:=/c\PKG_SOURCE_DATE:=2024-04-09' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_SOURCE_VERSION:=/c\PKG_SOURCE_VERSION:=f02a47aff2680de10c2269e22a3d0b37a318dbcd' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=265e413f24427dda4ec4a4bb24d67876ebe6245850bd27855bc6f475a923094f' feeds/packages/net/transmission-web-control/Makefile
sed -i '/DEPENDS:=/d' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/transmission\/web/transmission\/public_html/g' feeds/packages/net/transmission-web-control/Makefile

cat >> .config <<EOF
CONFIG_PACKAGE_transmission-web-control=y
CONFIG_PACKAGE_transmission-daemon=y
EOF
