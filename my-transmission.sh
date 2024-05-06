#luci-app-transmission
sed -i 's/transmission-daemon-openssl/transmission-daemon/' feeds/luci/applications/luci-app-transmission/Makefile

#transmission-web-control
sed -i '/^PKG_SOURCE_DATE:=/c\PKG_SOURCE_DATE:=2024-04-09' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_SOURCE_VERSION:=/c\PKG_SOURCE_VERSION:=f02a47aff2680de10c2269e22a3d0b37a318dbcd' feeds/packages/net/transmission-web-control/Makefile
sed -i '/^PKG_MIRROR_HASH:=/c\PKG_MIRROR_HASH:=265e413f24427dda4ec4a4bb24d67876ebe6245850bd27855bc6f475a923094f' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/DEPENDS:=+transmission-daemon-openssl/DEPENDS:=+transmission-daemon/' feeds/packages/net/transmission-web-control/Makefile
sed -i 's/transmission\/web/transmission\/public_html/g' feeds/packages/net/transmission-web-control/Makefile

git clone --single-branch https://github.com/openwrt/packages mytmp/packages
rm -rf feeds/packages/net/transmission
cp -a mytmp/packages/net/transmission feeds/packages/net/
[ -d feeds/packages/libs/libb64 ] || cp -a mytmp/packages/libs/libb64 package/libs/
[ -d feeds/packages/libs/libdeflate ] || cp -a mytmp/packages/libs/libdeflate package/libs/
[ -d feeds/packages/libs/libdht ] || cp -a mytmp/packages/libs/libdht package/libs/
[ -d feeds/packages/libs/libutp ] || cp -a mytmp/packages/libs/libutp package/libs/
rm -rf mytmp
