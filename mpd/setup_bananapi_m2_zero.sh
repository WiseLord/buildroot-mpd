#!/bin/sh

BASE_DIR=$(dirname $(dirname $(realpath ${0})))
cd ${BASE_DIR}

make bananapi_m2_zero_defconfig

. mpd/config/common.sh
. mpd/config/wifi.sh

cat << __EOF__ >> ".config"

# Rootfs configuration

BR2_ROOTFS_OVERLAY="mpd/rootfs_overlay board/bananapi/bananapi-m2-zero/rootfs_overlay"
BR2_ROOTFS_POST_BUILD_SCRIPT="board/bananapi/bananapi-m2-zero/post-build.sh"
BR2_TARGET_ROOTFS_EXT2_SIZE="120M"

# Linux configuration

BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="board/bananapi/bananapi-m2-zero/linux.fragment"
BR2_LINUX_KERNEL_DTB_OVERLAY_SUPPORT=y
BR2_LINUX_KERNEL_PATCH="board/bananapi/bananapi-m2-zero/patches/linux/ssd1322-support.patch"

__EOF__

make olddefconfig
