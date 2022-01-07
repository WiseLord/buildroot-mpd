#!/bin/bash

BOARD_DIR="$(dirname $0)"

DTS_OVERLAYS_DIR="${BOARD_DIR}/dts_overlays"
DTBO_OVERLAYS_DIR="${BINARIES_DIR}/overlays"

cp -f ${BOARD_DIR}/bootenv.txt ${BINARIES_DIR}/

mkdir -p ${DTBO_OVERLAYS_DIR}

for dts in ${DTS_OVERLAYS_DIR}/*.dts
do
	dtbo=$(basename ${dts} | sed -e 's/dts$/dtbo/')
	echo "Compiling ${dtbo}..."
	${HOST_DIR}/bin/dtc -O dtb -o ${DTBO_OVERLAYS_DIR}/${dtbo} ${dts}
done
