#!/bin/sh

if ! grep -q "  fdtoverlays" "${TARGET_DIR}/boot/extlinux/extlinux.conf"; then
    cat << EOF >> "${TARGET_DIR}/boot/extlinux/extlinux.conf"
  fdtoverlays /boot/dtbo/sun8i-h3-gpio-poweroff.dtbo /boot/dtbo/sun8i-h3-i2s-pcm5102.dtbo /boot/dtbo/sun8i-h3-uart2.dtbo
EOF
fi

BOARD_DIR="$(dirname $0)"

DTS_OVERLAYS_DIR="${BOARD_DIR}/dts_overlays"
DTBO_OVERLAYS_DIR="${TARGET_DIR}/boot/dtbo"

mkdir -p ${DTBO_OVERLAYS_DIR}

for dts in ${DTS_OVERLAYS_DIR}/*.dts
do
	dtbo=$(basename ${dts} | sed -e 's/dts$/dtbo/')
	echo "Compiling ${dtbo}..."
	${HOST_DIR}/bin/dtc -O dtb -o ${DTBO_OVERLAYS_DIR}/${dtbo} ${dts}
done
