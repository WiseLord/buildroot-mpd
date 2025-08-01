#!/bin/bash

set -e

export BR2_EXTERNAL=$(dirname $(realpath ${0}))
export BUILDROOT_DIR=${BR2_EXTERNAL}/buildroot

BOARD=${1}

cd ${BR2_EXTERNAL}

usage() {
    echo "Usage: ${0} <board>"
    echo "Supported boards:"
    for board in config/*; do
        echo "  $(basename ${board})"
    done
}

if [ ! -f "config/${BOARD}" ]; then
    echo "Config '${BOARD}' not found"
    usage
    exit 1
fi

make -C ${BUILDROOT_DIR} ${BOARD}_defconfig

for fragment in $(cat config/${BOARD}); do
    echo $fragment
    cat fragments/${fragment} >> ${BUILDROOT_DIR}/.config
done

make -C ${BUILDROOT_DIR} olddefconfig
