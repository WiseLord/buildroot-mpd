#!/bin/sh

BASE_DIR=$(dirname $(dirname $(realpath ${0})))
cd ${BASE_DIR}

make raspberrypi_defconfig

. mpd/config/common.sh
. mpd/config/rpi.sh

cat << __EOF__ >> ".config"

# Rootfs configuration

BR2_ROOTFS_OVERLAY="mpd/rootfs_overlay board/raspberrypi/rootfs_overlay_default"

__EOF__

make olddefconfig
