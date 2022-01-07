#!/bin/sh

cat << __EOF__ >> ".config"

# RPi overlays

BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS=y

__EOF__
