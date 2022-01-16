#!/bin/sh

BASE_DIR=$(dirname $(dirname $(realpath ${0})))
cd ${BASE_DIR}

make raspberrypi3_defconfig

. mpd/config/common.sh
. mpd/config/rpi.sh
. mpd/config/wifi.sh

cat << __EOF__ >> ".config"

# Rootfs configuration

BR2_ROOTFS_OVERLAY=mpd/rootfs_overlay "board/raspberrypi3/rootfs_overlay_3"

__EOF__

make olddefconfig
