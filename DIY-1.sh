# 此脚本用处是：添加第三方插件
#=========================================================================================================================


# 1-添加 ShadowSocksR Plus+ 插件
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# 2-添加 PowerOff 关机插件
#git clone https://github.com/WukongMaster/luci-app-poweroff.git package/luci-app-poweroff

# 3-添加主题
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone -b js --single-branch https://github.com/papagaye744/luci-theme-design.git package/luci-theme-design

# 4-添加 clouddrive2 插件
git clone https://github.com/kiddin9/openwrt-clouddrive2.git package/openwrt-clouddrive2

# 5-添加 PassWall 插件
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> "feeds.conf.default"
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git mihomo https://github.com/morytyann/OpenWrt-mihomo.git;main" >> "feeds.conf.default"
# 6-添加 kwrt-packages插件
#echo "src-git kwrt_packages https://github.com/kiddin9/kwrt-packages.git;main" >> "feeds.conf.default"

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

#修改时区
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
