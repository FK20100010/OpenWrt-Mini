# 此脚本用处是：定制个性化参数
#============================================================================================


# 1-设置默认主题
#sed -i 's/bootstrap/opentomcat/g' ./feeds/luci/collections/luci/Makefile

# 2-设置管理地址
sed -i 's/192.168.1.1/192.168.1.10/g' package/base-files/files/bin/config_generate

# 3-编译内核版本
# sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=5.15/g' ./target/linux/x86/Makefile

# 4-设置密码为空
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# 5-修改时间格式
#sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' feeds/kwrt_packages/autocore/files/*/index.htm

# 6-添加固件日期
#sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
#sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk

# 7-修正硬件信息
#sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' feeds/kwrt_packages/autocore/files/autocore

# 8-增固件连接数
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=165535' package/base-files/files/etc/sysctl.conf

curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://github.com/lisaac/luci-app-dockerman.git package/luci-app-dockerman
