#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

#Fri Mar 29 19:02:39 CST 2024
#git checkout dc4d37c71423bd48b02f614414b149fa192d3406

sed -i '1i\
src-git packages_up https://github.com/eearphon/packages_up.git\
src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git\
src-git passwall https://github.com/xiaorouji/openwrt-passwall.git\
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git\
src-git helloworld https://github.com/fw876/helloworld.git
' ./feeds.conf.default
