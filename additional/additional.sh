#!/usr/bin/env bash

BUILD_DIR=$(cat BUILD_DIR)
BUILD_MODEL=$(cat BUILD_MODEL)
if [[ -f "additional/$BUILD_MODEL.sh" ]]; then
    chmod 755 additional/$BUILD_MODEL.sh
    additional/$BUILD_MODEL.sh
fi

cd $BUILD_DIR
sed -i '/^#/d' feeds.conf.default
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;v1.10.0" >> "feeds.conf.default"

./scripts/feeds clean && ./scripts/feeds update -a && ./scripts/feeds install -a

#添加自定义插件
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design
# 添加 clouddrive2 插件
git clone https://github.com/kiddin9/openwrt-clouddrive2.git package/openwrt-clouddrive2

rm -rf feeds/packages/net/chinadns-ng
cp -rf feeds/passwall_packages/chinadns-ng/ feeds/packages/net/
rm -rf feeds/luci/applications/luci-app-passwall/
cp -rf feeds/passwall/luci-app-passwall/ feeds/luci/applications

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 增固件连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf
# 安装turboacc
#curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
# 更新luci-app-dockerman
#rm -rf feeds/luci/applications/luci-app-dockerman
#git clone https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman
