#!/bin/sh

# Run mpd earlier
if [ -f "${TARGET_DIR}/etc/init.d/S95mpd" ]; then
    mv -f "${TARGET_DIR}/etc/init.d/S95mpd" "${TARGET_DIR}/etc/init.d/S35mpd"
fi

# Optimize database size by limiting stored audio metadata
if ! grep -q "# Metadata stored in database" "${TARGET_DIR}/etc/mpd.conf"; then
    cat << EOF >> "${TARGET_DIR}/etc/mpd.conf"

# Metadata stored in database
metadata_to_use        "artist,album,title,track,name,genre,date"
EOF
fi

if ! grep -q "  fdtoverlays" "${TARGET_DIR}/boot/extlinux/extlinux.conf"; then
    cat << EOF >> "${TARGET_DIR}/boot/extlinux/extlinux.conf"
  fdtoverlays /boot/dtbo/sun8i-h3-gpio-poweroff.dtbo /boot/dtbo/sun8i-h3-i2s-pcm5102.dtbo /boot/dtbo/sun8i-h3-uart2.dtbo
EOF
fi

BOARD_DIR="$(dirname $0)"

DTS_OVERLAYS_DIR="${BOARD_DIR}/orangepi/orangepi-one/dts_overlays"
DTBO_OVERLAYS_DIR="${TARGET_DIR}/boot/dtbo"

mkdir -p ${DTBO_OVERLAYS_DIR}

for dts in ${DTS_OVERLAYS_DIR}/*.dts
do
	dtbo=$(basename ${dts} | sed -e 's/dts$/dtbo/')
	echo "Compiling ${dtbo}..."
	${HOST_DIR}/bin/dtc -O dtb -o ${DTBO_OVERLAYS_DIR}/${dtbo} ${dts}
done
