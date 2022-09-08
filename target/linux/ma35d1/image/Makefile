#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

UBIFS_OPTS = -F -m 2048 -e 124KiB -c 4096 -U
UBI_OPTS = -m 2048 -p 128KiB -s 2048 -O 2048

include $(SUBTARGET).mk

#################################################
# Images
#################################################

DEVICE_VARS += MKUBIFS_OPTS UBOOT BOOT_SCRIPT

define Build/copy-dtb
	echo DEVICE_DTS=$(DEVICE_DTS) >> /tmp/openwrt.env
	echo DEVICE_NAME=$(DEVICE_NAME) >> /tmp/openwrt.env
	$(CP) $(KDIR)/image-${BOARD}-$(DEVICE_NAME).dtb $(STAGING_DIR_IMAGE)/Image.dtb
endef

define Image/Build
	$(info "Image/Build" $(1))
	$(call Image/Build/$(1),$(1))
ifeq ($(1),squashfs)
	echo BOARD=$(BOARD) >> /tmp/openwrt.env
	echo SUBTARGET=$(SUBTARGET) >> /tmp/openwrt.env
	echo BUILD_DIR=$(BUILD_DIR) >> /tmp/openwrt.env
	echo BIN_DIR=$(BIN_DIR) >> /tmp/openwrt.env
	echo STAGING_DIR_IMAGE=$(STAGING_DIR_IMAGE) >> /tmp/openwrt.env
	env - BASH_ENV=/tmp/openwrt.env /usr/bin/bash $(BUILD_DIR)/../../Nuvoton/script/pack-image.sh
endif
endef


#################################################
# Devices
#################################################

KERNEL_LOADADDR=0x00008000

define Device/select-dtb
  IMAGES += image-dtb
  IMAGE/image-dtb := copy-dtb
endef

define Device/Default
  PROFILES := Default
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := Image
  KERNEL_PREFIX := $$(IMAGE_PREFIX)
  KERNEL := kernel-bin | uImage none
  FILESYSTEMS := squashfs
  IMAGES := firmware.bin sysupgrade.bin
endef

ifeq ($(SUBTARGET),som)
define Device/som
  IMAGE_SIZE := 32768k
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  IMAGE/firmware.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | append-metadata | check-size $$$$(IMAGE_SIZE)
endef
endif

ifeq ($(SUBTARGET),iot)
define Device/iot
  IMAGE_SIZE := 32768k
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  IMAGE/firmware.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | append-metadata | check-size $$$$(IMAGE_SIZE)
endef
endif

$(eval $(call BuildImage))
