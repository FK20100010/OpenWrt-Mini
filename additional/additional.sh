#!/usr/bin/env bash
cd $(cat BUILD_DIR)
sed -i '/^#/d' feeds.conf.default
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"

./scripts/feeds clean && ./scripts/feeds update -a && ./scripts/feeds install -a

#添加自定义插件
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design

rm -rf feeds/packages/net/chinadns-ng
cp -rf feeds/passwall_packages/chinadns-ng/ feeds/packages/net/
rm -rf feeds/luci/applications/luci-app-passwall/
cp -rf feeds/passwall/luci-app-passwall/ feeds/luci/applications

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config
