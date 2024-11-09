#!/usr/bin/env bash

set -e

source /etc/profile
BASE_PATH=$(cd $(dirname $0) && pwd)
BUILD_DIR=$(cat BUILD_DIR)
BUILD_MODEL=$(cat BUILD_MODEL)
CONFIG_FILE=$BASE_PATH/additional/$BUILD_MODEL.config

aa=$(grep -lri $BUILD_MODEL $BASE_PATH$BUILD_DIR/target | awk -F'[/.]' '{print $3}')
bb=$(grep -lri $BUILD_MODEL $BASE_PATH$BUILD_DIR/target | awk -F'[/.]' '{print $5}')
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat>$BASE_PATH/$BUILD_DIR/.config<<-EOF
    CONFIG_TARGET_$aa=y
    CONFIG_TARGET_$aa_$bb=y
    CONFIG_TARGET_$aa_$bb_DEVICE_$BUILD_MODEL=y
    EOF
    else
    \cp -f $BASE_PATH/additional/$BUILD_MODEL.config $BASE_PATH/$BUILD_DIR/.config
fi
cat $BASE_PATH/$BUILD_DIR/.config

DEVICE_NAME=$(grep '^CONFIG_TARGET.*DEVICE.*=y' $CONFIG_FILE | sed -r 's/.*DEVICE_(.*)=y/\1/')
if [[ "$DEVICE_NAME" != "jdcloud_ax1800-pro" ]] || [[ "$DEVICE_NAME" != "jdcloud_re-ss-01" ]]; then
    sed -i "s/FK20100010/$DEVICE_NAME/g" $BASE_PATH/additional/99-additional-settings
    sed -i '/.encryption=/d' $BASE_PATH/additional/99-additional-settings
    sed -i '/.key=/d' $BASE_PATH/additional/99-additional-settings
    sed -i '/_core/d' $BASE_PATH/additional/99-additional-settings
    sed -i '/\/etc\/shadow/d' $BASE_PATH/additional/99-additional-settings
    chmod 775 $BASE_PATH/additional/99-additional-settings
    cp -f $BASE_PATH/additional/99-additional-settings $BASE_PATH/$BUILD_DIR/package/base-files/files/etc/uci-defaults
fi

TARGET_DIR="$BASE_PATH/$BUILD_DIR/bin/targets"
if [[ -d $TARGET_DIR ]]; then
    find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" \) -exec rm -f {} +
fi

cd $BASE_PATH/$BUILD_DIR
cd $(dirname $0) && pwd
make defconfig
make download -j$(nproc)
make -j$(nproc) || make -j1 || make -j1 V=s

FIRMWARE_DIR="$BASE_PATH/firmware"
\rm -rf "$FIRMWARE_DIR"
mkdir -p "$FIRMWARE_DIR"
find "$TARGET_DIR" -type f \( -name "*.bin" -o -name "*.manifest" -o -name "*.buildinfo" -o -name "*.gz" \) -exec cp -f {} "$FIRMWARE_DIR/" \;
\rm -f "$BASE_PATH/firmware/Packages.manifest" 2>/dev/null
