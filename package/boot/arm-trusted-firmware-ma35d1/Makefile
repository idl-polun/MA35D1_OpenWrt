#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=arm-trusted-firmware-ma35d1
PKG_VERSION:=2.3
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/OpenNuvoton/MA35D1_arm-trusted-firmware-v2.3.git
PKG_SOURCE_DATE:=2022-07-26
PKG_SOURCE_VERSION:=64cc1d801ec4834e80dc6d816b5d1e70063f1f9c

PKG_MAINTAINER:=Chih-Chiang Chang <ccchang12@nuvoton.com>

PKG_LICENSE_FILES:=LICENCE.ma35d1

include $(INCLUDE_DIR)/trusted-firmware-a.mk
include $(INCLUDE_DIR)/package.mk

define Trusted-Firmware-A/Default
  BUILD_TARGET:=ma35d1
  PLAT:=ma35d1
  TFA_IMAGE:=bl2.bin bl31.bin
  BOOT_DEVICE:=
  DDR_BLOB:=
endef

define Trusted-Firmware-A/som
  BUILD_SUBTARGET:=som
  NAME:=MA35D1 SOM Board
endef

define Trusted-Firmware-A/iot
  BUILD_SUBTARGET:=iot
  NAME:=MA35D1 IoT Board
endef

TFA_TARGETS:= \
        som \
        iot

TFA_MAKE_FLAGS += NEED_BL32=yes all dtbs fiptool

define Package/trusted-firmware-a/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/bl2.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-bl2.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/bl31.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-bl31.bin
ifeq ($(SUBTARGET),som)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/fdts/ma35d1-cpu800-wb-256m.dtb $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-bl2.dtb
else ifeq ($(SUBTARGET),iot)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/fdts/ma35d1-cpu800-wb-512m.dtb $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-bl2.dtb
endif
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/tools/fiptool/fiptool $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fiptool
	chmod +x $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-fiptool
endef

$(eval $(call BuildPackage/Trusted-Firmware-A))
