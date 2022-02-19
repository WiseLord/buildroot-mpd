#!/bin/sh

linux_image()
{
	if grep -Eq "^BR2_LINUX_KERNEL_UIMAGE=y$" ${BR2_CONFIG}; then
		echo "uImage"
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGE=y$" ${BR2_CONFIG}; then
		echo "Image"
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGEGZ=y$" ${BR2_CONFIG}; then
		echo "Image.gz"
	else
		echo "zImage"
	fi
}

generic_getty()
{
	if grep -Eq "^BR2_TARGET_GENERIC_GETTY=y$" ${BR2_CONFIG}; then
		echo ""
	else
		echo "s/\s*console=\S*//"
	fi
}

PARTUUID="$($HOST_DIR/bin/uuidgen)"

install -d "$TARGET_DIR/boot/extlinux/"

sed -e "$(generic_getty)" \
	-e "s/%LINUXIMAGE%/$(linux_image)/g" \
	-e "s/%PARTUUID%/$PARTUUID/g" \
	"board/orangepi/common/extlinux.conf" > "$TARGET_DIR/boot/extlinux/extlinux.conf"

sed "s/%PARTUUID%/$PARTUUID/g" "board/orangepi/common/genimage.cfg" > "$BINARIES_DIR/genimage.cfg"

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
