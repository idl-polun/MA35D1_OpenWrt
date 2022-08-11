#
# Copyright (C) 2013-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_VERSION:=2020.07
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/OpenNuvoton/MA35D1_u-boot-v2020.07.git
PKG_SOURCE_DATE:=2022-08-05
PKG_SOURCE_VERSION:=4faa8c8a645b743fc3c2bad915343d0ae4c8f98a

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=ma35d1
  UBOOT_IMAGE:=u-boot.bin
endef

define U-Boot/som
  NAME:=MA35D1 SOM board
  BUILD_SUBTARGET:=som
  UBOOT_CONFIG:=ma35d1_spinand
endef

define U-Boot/iot
  NAME:=MA35D1 IoT board
  BUILD_SUBTARGET:=iot
  UBOOT_CONFIG:=ma35d1_spinand
endef

UBOOT_TARGETS := \
	som \
	iot

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(foreach img,$(UBOOT_IMAGE), \
		$(CP) $(PKG_BUILD_DIR)/$(img) $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-$(img); \
	)
	$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fiptool create \
		--soc-fw $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-bl31.bin \
		--tos-fw $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee-header_v2.bin \
		--tos-fw-extra1 $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee-pager_v2.bin \
		--nt-fw $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-u-boot.bin \
		$(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fip.bin
endef

$(eval $(call BuildPackage/U-Boot))
