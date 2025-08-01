setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk1p2 rootwait

mmc dev 0
fatload mmc 0 $kernel_addr_r zImage
fatload mmc 0 $fdt_addr_r sun8i-h2-plus-bananapi-m2-zero.dtb

fdt addr ${fdt_addr_r}
fdt resize 65536

setenv load_addr "0x45000000"

fatload mmc 0 ${load_addr} bootenv.txt
env import -t ${load_addr} ${filesize}

for overlay_file in ${overlays}
do
	if fatload mmc 0 ${load_addr} overlays/${overlay_file}.dtbo
	then
		echo "Applying dtb overlay ${overlay_file}"
		fdt apply ${load_addr} || echo "Error applying ${overlay_file}"
	fi
done

bootz $kernel_addr_r - $fdt_addr_r
