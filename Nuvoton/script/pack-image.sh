#!/usr/bin/env bash

ROOT_DIR=${BUILD_DIR}/../..
CONFIG=${ROOT_DIR}/.config
NUWRITER_DIR=${ROOT_DIR}/Nuvoton/nuwriter
HOST_DIR=${STAGING_DIR_IMAGE}/../../host

IMAGE_BASENAME="openwrt-ma35d1"

# Boot partition size [in KiB]
BOOT_SPACE="32768"

UBINIZE_ARGS="-m 2048 -p 128KiB -s 2048 -O 2048"
IS_OPTEE=
UBOOT_DTB_NAME=

#
# get the subtarget from config
#
subtarget()
{
	echo $(sed -n 's/^CONFIG_TARGET_SUBTARGET="\([\/a-z0-9 \-]*\)"$/\1/p' ${CONFIG})
}

#
# get the storage from config
#
storage()
{
	echo "spinand"
}

optee_image()
{
	if grep -Eq "^BR2_TARGET_OPTEE_OS=y$" ${CONFIG}; then
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

	if [ -f ${STAGING_DIR_IMAGE}/${SUBTARGET}-fip.bin ]; then
		( \
			cd ${STAGING_DIR_IMAGE}; \
			ln -sf ${SUBTARGET}-bl2.bin bl2.bin; \
			ln -sf ${SUBTARGET}-bl2.dtb bl2.dtb; \
			ln -sf ${SUBTARGET}-bl31.bin bl31.bin; \
			ln -sf ${SUBTARGET}-fip.bin fip.bin; \
			ln -sf openwrt-${BOARD}-${SUBTARGET}-${SUBTARGET}.dtb Image.dtb; \
			ln -sf ${BIN_DIR}/openwrt-${BOARD}-${SUBTARGET}-${SUBTARGET}-squashfs-firmware.bin firmware.bin; \
			cp ${NUWRITER_DIR}/ddrimg_tfa.bin ${STAGING_DIR_IMAGE}; \
			cp fip.bin fip.bin-spinand; \
			python3 ${NUWRITER_DIR}/nuwriter.py -c ${NUWRITER_DIR}/header-spinand.json; \
			cp conv/header.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${SUBTARGET}-header-spinand.bin; \
			python3 ${NUWRITER_DIR}/nuwriter.py -p ${NUWRITER_DIR}/pack-spinand.json; \
			cp pack/pack.bin ${BIN_DIR}/${IMAGE_BASENAME}-${SUBTARGET}-${SUBTARGET}-pack-spinand.bin; \
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
		${HOST_DIR}/bin/ubinize ${UBINIZE_ARGS} -o ${STAGING_DIR_IMAGE}/u-boot-env.ubi-nand ${ROOT_DIR}/env/uEnv-nand-ubi.cfg \
	)

	if [ -f ${STAGING_DIR_IMAGE}/rootfs.ubi ]; then
		( \
			cd ${STAGING_DIR_IMAGE}; \
			ln -sf ${SUBTARGET}.dtb Image.dtb; \
			cp ${NUWRITER_DIR}/ddrimg_tfa.bin ${STAGING_DIR_IMAGE}; \
			cp fip.bin fip.bin-nand; \
			${HOST_DIR}/bin/nuwriter.py -c ${NUWRITER_DIR}/header-nand.json; \
			cp conv/header.bin header-${IMAGE_BASENAME}-${SUBTARGET}-nand.bin; \
			${HOST_DIR}/bin/nuwriter.py -p ${NUWRITER_DIR}/pack-nand.json; \
			cp pack/pack.bin pack-${IMAGE_BASENAME}-${SUBTARGET}-nand.bin; \
			rm -rf $(date "+%m%d-*") conv pack; \
			rm Image.dtb; \
		)
	fi
}

uboot_cmd() {
	cp ${ROOT_DIR}/Nuvoton/uboot_env/openwrt-${BOARD}-${SUBTARGET}-${SUBTARGET}-u-boot-env.txt ${STAGING_DIR_IMAGE}/uboot-env.txt
	cp ${ROOT_DIR}/Nuvoton/uboot_env/*.cfg ${STAGING_DIR_IMAGE}/
	if [[ $SUBTARGET == "som" ]]
	then	
		if [[ $IS_OPTEE == "yes" ]] 
		then
			sed -i "s/kernelmem=256M/kernelmem=248M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi

	elif  [[ $SUBTARGET == "iot" ]]
	then
		sed -i "s/kernelmem=256M/kernelmem=128M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		if [[ $IS_OPTEE == "yes" ]]
		then
			sed -i "s/kernelmem=128M/kernelmem=120M/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
		fi
		sed -i "s/mmc_block=mmcblk1p1/mmc_block=mmcblk0p1/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
	fi

	if [[ $(echo $STORAGE | grep "sdcard0") != "" ]]
	then
		sed -i "s/mmc_block=mmcblk1p1/mmc_block=mmcblk0p1/1" ${STAGING_DIR_IMAGE}/uboot-env.txt
	fi

	${HOST_DIR}/bin/mkenvimage -s 0x10000 -o ${STAGING_DIR_IMAGE}/uboot-env.bin ${STAGING_DIR_IMAGE}/uboot-env.txt
}

main()
{
	STORAGE=$(storage)
#	IS_OPTEE=$(optee_image)
	uboot_cmd
	if [[ $(echo $STORAGE | grep "spinand") != "" ]]
	then
		IMAGE_CMD_spinand
	elif [[ $(echo $STORAGE | grep "nand") != "" ]]
	then
		echo IMAGE_CMD_nand
	else
		echo IMAGE_CMD_sdcard
	fi

	echo "========================================================="
	echo "SUBTARGET = ${SUBTARGET}"
	echo "ROOT_DIR = ${ROOT_DIR}"
	echo "BIN_DIR = ${BIN_DIR}"
	echo "STAGING_DIR_IMAGE = ${STAGING_DIR_IMAGE}"
	echo "HOST_DIR = ${HOST_DIR}"

	exit $?
}

main $@
