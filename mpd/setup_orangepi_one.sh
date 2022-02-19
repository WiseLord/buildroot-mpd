#!/bin/sh

BASE_DIR=$(dirname $(dirname $(realpath ${0})))
cd ${BASE_DIR}

make orangepi_one_defconfig

. mpd/config/common.sh

cat << __EOF__ >> ".config"

# Rootfs configuration

BR2_ROOTFS_OVERLAY="mpd/rootfs_overlay board/orangepi/orangepi-one/rootfs_overlay"
BR2_TARGET_ROOTFS_EXT2_SIZE="120M"

# Linux configuration

BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="board/orangepi/orangepi-one/linux.fragment"
BR2_LINUX_KERNEL_DTB_OVERLAY_SUPPORT=y

# U-Boot configuration

BR2_TARGET_UBOOT_CONFIG_FRAGMENT_FILES="board/orangepi/orangepi-one/uboot.fragment"

__EOF__

make olddefconfig
