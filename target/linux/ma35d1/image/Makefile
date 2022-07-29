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


#################################################
# Images
#################################################

DEVICE_VARS += MKUBIFS_OPTS UBOOT BOOT_SCRIPT

define Image/BuildKernel
	$(CP) $(KDIR)/linux-git_github_com_OpenNuvoton_MA35D1_linux_5_4_y_git-HEAD/arch/arm64/boot/dts/nuvoton/ma35d1-som-256m.dtb \
		$(KDIR)/som.dtb
	$(CP) $(KDIR)/linux-git_github_com_OpenNuvoton_MA35D1_linux_5_4_y_git-HEAD/arch/arm64/boot/dts/nuvoton/ma35d1-iot-512m.dtb \
		$(KDIR)/iot.dtb
	$(CP) $(KDIR)/$(SUBTARGET).dtb $(BIN_DIR)/$(IMG_PREFIX)-$(SUBTARGET).dtb
	$(CP) $(KDIR)/$(SUBTARGET).dtb $(STAGING_DIR_IMAGE)/$(IMG_PREFIX)-$(SUBTARGET).dtb
#	$(CP) $(KDIR)/../../../Nuvoton/uboot_env/$(IMG_PREFIX)-$(SUBTARGET)-u-boot-env.txt $(BIN_DIR)/
endef

define Image/Build
	$(info "Image/Build" $(1))
	$(call Image/Build/$(1),$(1))
ifeq ($(1),squashfs)
	echo BOARD=$(BOARD) > /tmp/openwrt.env
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

define Device/Default
  PROFILES := Generic
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := Image
  KERNEL_PREFIX := $$(IMAGE_PREFIX)
  KERNEL := kernel-bin | uImage none
endef

ifeq ($(SUBTARGET),som)
define Device/som
  BOARDNAME := som
  DEVICE_PROFILE = $$(BOARDNAME)
  PROFILES = Default Minimal $$(DEVICE_PROFILE)
  IMAGE_SIZE := 32768k
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  FILESYSTEMS := squashfs ubifs
  SUPPORTED_DEVICES += som
  IMAGES := firmware.bin sysupgrade.bin
  IMAGE/firmware.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | append-metadata | check-size $$$$(IMAGE_SIZE)
endef
TARGET_DEVICES += som
endif

ifeq ($(SUBTARGET),iot)
define Device/iot
  BOARDNAME := iot
  DEVICE_PROFILE = $$(BOARDNAME)
  PROFILES = Default Minimal $$(DEVICE_PROFILE)
  IMAGE_SIZE := 32768k
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  FILESYSTEMS := squashfs ubifs
  SUPPORTED_DEVICES += iot
  IMAGES := firmware.bin sysupgrade.bin
  IMAGE/firmware.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | check-size $$$$(IMAGE_SIZE)
  IMAGE/sysupgrade.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | append-ubi | append-metadata | check-size $$$$(IMAGE_SIZE)
endef
TARGET_DEVICES += iot
endif

$(eval $(call BuildImage))
