#!/usr/bin/env bash

ROOT_DIR=${BUILD_DIR}/../..
CONFIG=${ROOT_DIR}/.config
NUWRITER_DIR=${ROOT_DIR}/Nuvoton/nuwriter
HOST_DIR=${STAGING_DIR_IMAGE}/../../host

IMAGE_BASENAME="openwrt-ma35d1"
UBINIZE_ARGS="-m 2048 -p 128KiB -s 2048 -O 2048"

optee_image()
{
	if grep -Eq "^CONFIG_PACKAGE_optee-generic=y$" ${CONFIG}; then
		echo "yes"
	else
		echo "no"
	fi
}

IMAGE_CMD_spinand() {
	( \
		cd ${STAGING_DIR_IMAGE}; \
		cp ${STAGING_DIR_IMAGE}/uboot-env.bin ${STAGING_DIR_IMAGE}/uboot-env.bin-spinand; \
		cp ${STAGING_DIR_IMAGE}/uboot-env.txt ${STAGING_DIR_IMAGE}/uboot-env.txt-spinand; \
		${HOST_DIR}/bin/ubinize ${UBINIZE_ARGS} -o ${STAGING_DIR_IMAGE}/uboot-env.ubi-spinand ${STAGING_DIR_IMAGE}/uEnv-spinand-ubi.cfg; \
	)

	if [ -f ${STAGING_DIR_IMAGE}/fip.bin ]; then
		( \
			cd ${STAGING_DIR_IMAGE}; \
			ln -sf openwrt-${BOARD}-${SUBTARGET}-${SUBTARGET}.dtb Image.dtb; \
			ln -sf ${BIN_DIR}/openwrt-${BOARD}-${SUBTARGET}-${DEVICE_NAME}-squashfs-firmware.bin firmware.bin; \
			cp ${NUWRITER_DIR}/ddrimg_tfa.bin ${STAGING_DIR_IMAGE}; \
			cp fip.bin fip.bin-spinand; \
			python3 ${NUWRITER_DIR}/nuwriter.py -c ${NUWRITER_DIR}/header-spinand.json; \
			cp conv/header.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${DEVICE_NAME}-header-spinand.bin; \
			python3 ${NUWRITER_DIR}/nuwriter.py -p ${NUWRITER_DIR}/pack-spinand.json; \
			cp pack/pack.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${DEVICE_NAME}-pack-spinand.bin; \
			rm -rf $(date "+%m%d-*") conv pack; \
			rm Image_xxx.dtb; \
		)
	fi
}

IMAGE_CMD_nand() {
	( \
		cd ${STAGING_DIR_IMAGE}; \
		cp ${STAGING_DIR_IMAGE}/uboot-env.bin ${STAGING_DIR_IMAGE}/uboot-env.bin-nand; \
		cp ${STAGING_DIR_IMAGE}/uboot-env.txt ${STAGING_DIR_IMAGE}/uboot-env.txt-nand; \
		${HOST_DIR}/bin/ubinize ${UBINIZE_ARGS} -o ${STAGING_DIR_IMAGE}/uboot-env.ubi-nand ${STAGING_DIR_IMAGE}/uEnv-nand-ubi.cfg; \
	)

	if [ -f ${STAGING_DIR_IMAGE}/fip.bin ]; then
		( \
			cd ${STAGING_DIR_IMAGE}; \
			ln -sf openwrt-${BOARD}-${SUBTARGET}-${SUBTARGET}.dtb Image.dtb; \
			ln -sf ${BIN_DIR}/openwrt-${BOARD}-${SUBTARGET}-${DEVICE_NAME}-squashfs-firmware.bin firmware.bin; \
			cp ${NUWRITER_DIR}/ddrimg_tfa.bin ${STAGING_DIR_IMAGE}; \
			cp fip.bin fip.bin-nand; \
			python3 ${NUWRITER_DIR}/nuwriter.py -c ${NUWRITER_DIR}/header-nand.json; \
			cp conv/header.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${DEVICE_NAME}-header-nand.bin; \
			python3 ${NUWRITER_DIR}/nuwriter.py -p ${NUWRITER_DIR}/pack-nand.json; \
			cp pack/pack.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${DEVICE_NAME}-pack-nand.bin; \
			rm -rf $(date "+%m%d-*") conv pack; \
			rm Image_xxx.dtb; \
		)
	fi
}

uboot_cmd() {
	cp ${ROOT_DIR}/Nuvoton/uboot_env/uboot-env.txt ${STAGING_DIR_IMAGE}/
	cp ${ROOT_DIR}/Nuvoton/uboot_env/*.cfg ${STAGING_DIR_IMAGE}/
	if echo $DEVICE_NAME | grep -q "256m"
	then
		if [[ $IS_OPTEE == "yes" ]]
		then
			sed -i "s/kernelmem=256M/kernelmem=248M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi

	elif echo $DEVICE_NAME | grep -q "128m"
	then
		sed -i "s/kernelmem=256M/kernelmem=128M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		if [[ $IS_OPTEE == "yes" ]]
		then
			sed -i "s/kernelmem=128M/kernelmem=120M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi
	elif echo $DEVICE_NAME | grep -q "512m"
	then
		sed -i "s/kernelmem=256M/kernelmem=512M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		if [[ $IS_OPTEE == "yes" ]]
		then
			sed -i "s/kernelmem=512M/kernelmem=504M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi
	elif echo $DEVICE_NAME | grep -q "1g"
	then
		sed -i "s/kernelmem=256M/kernelmem=1024M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		if [[ $IS_OPTEE == "yes" ]]
		then
			sed -i "s/kernelmem=1024M/kernelmem=1016M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi
	fi

	if echo $UBOOT_CONFIG | grep "sdcard0"
	then
		sed -i "s/mmc_block=mmcblk1p1/mmc_block=mmcblk0p1/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
	elif echo $UBOOT_CONFIG | grep -q "spinand"
	then
		sed -i "s/boot_targets=/boot_targets=mtd0 /1" ${STAGING_DIR_IMAGE}/uboot-env.txt
	fi

	${HOST_DIR}/bin/mkenvimage -s 0x10000 -o ${STAGING_DIR_IMAGE}/uboot-env.bin ${STAGING_DIR_IMAGE}/uboot-env.txt
}

main()
{
	IS_OPTEE=$(optee_image)
	uboot_cmd
	if [[ $(echo $UBOOT_CONFIG | grep "spinand") != "" ]]
	then
		IMAGE_CMD_spinand
	elif [[ $(echo $UBOOT_CONFIG | grep "nand") != "" ]]
	then
		IMAGE_CMD_nand
	else
		echo IMAGE_CMD_sdcard
	fi

	echo "========================================================="
	echo "SUBTARGET = ${SUBTARGET}"
	echo "DEVICE_NAME = ${DEVICE_NAME}"
	echo "UBOOT_CONFIG = ${UBOOT_CONFIG}"
	echo "ROOT_DIR = ${ROOT_DIR}"
	echo "BIN_DIR = ${BIN_DIR}"
	echo "STAGING_DIR_IMAGE = ${STAGING_DIR_IMAGE}"
	echo "HOST_DIR = ${HOST_DIR}"

	exit $?
}

main $@
