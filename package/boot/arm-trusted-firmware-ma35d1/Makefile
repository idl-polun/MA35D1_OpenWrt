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

define Trusted-Firmware-A/ma35d1-cpu800-wb-128m
  NAME:=Winbond
  TFA_DTB_NAME:=ma35d1-cpu800-wb-128m
endef

define Trusted-Firmware-A/ma35d1-cpu800-wb-256m
  NAME:=Winbond
  TFA_DTB_NAME:=ma35d1-cpu800-wb-256m
endef

define Trusted-Firmware-A/ma35d1-cpu800-wb-512m
  NAME:=Winbond
  TFA_DTB_NAME:=ma35d1-cpu800-wb-512m
endef

define Trusted-Firmware-A/ma35d1-cpu1g-wb-256m
  NAME:=Winbond
  TFA_DTB_NAME:=ma35d1-cpu1g-wb-256m
endef

define Trusted-Firmware-A/ma35d1-cpu1g-wb-512m
  NAME:=Winbond
  TFA_DTB_NAME:=ma35d1-cpu1g-wb-512m
endef

define Trusted-Firmware-A/ma35d1-cpu800-zt-1g
  NAME:=Zentel
  TFA_DTB_NAME:=ma35d1-cpu800-zt-1g
endef

define Trusted-Firmware-A/ma35d1-cpu800-mc-1g
  NAME:=Micron
  TFA_DTB_NAME:=ma35d1-cpu800-mc-1g
endef

define Trusted-Firmware-A/ma35d1-cpu800-issi-1g
  NAME:=ISSI
  TFA_DTB_NAME:=ma35d1-cpu800-issi-1g
endef

define Trusted-Firmware-A/ma35d1-cpu1g-zt-1g
  NAME:=Zentel
  TFA_DTB_NAME:=ma35d1-cpu1g-zt-1g
endef

define Trusted-Firmware-A/ma35d1-cpu1g-mc-1g
  NAME:=Micron
  TFA_DTB_NAME:=ma35d1-cpu1g-mc-1g
endef

define Trusted-Firmware-A/ma35d1-cpu1g-issi-1g
  NAME:=ISSI
  TFA_DTB_NAME:=ma35d1-cpu1g-issi-1g
endef

TFA_TARGETS:= \
	ma35d1-cpu800-wb-128m \
	ma35d1-cpu800-wb-256m \
	ma35d1-cpu800-wb-512m \
	ma35d1-cpu1g-wb-256m \
	ma35d1-cpu1g-wb-512m \
	ma35d1-cpu800-zt-1g \
	ma35d1-cpu800-mc-1g \
	ma35d1-cpu800-issi-1g \
	ma35d1-cpu1g-zt-1g \
	ma35d1-cpu1g-mc-1g \
	ma35d1-cpu1g-issi-1g

TFA_MAKE_FLAGS += NEED_BL32=yes all dtbs fiptool

define Package/trusted-firmware-a/install
	echo TFA_DTB_NAME=$(TFA_DTB_NAME) > /tmp/openwrt.env
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/bl2.bin $(STAGING_DIR_IMAGE)/bl2.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/bl31.bin $(STAGING_DIR_IMAGE)/bl31.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/build/ma35d1/release/fdts/${TFA_DTB_NAME}.dtb $(STAGING_DIR_IMAGE)/bl2.dtb
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/tools/fiptool/fiptool $(STAGING_DIR_IMAGE)/fiptool
	chmod +x $(STAGING_DIR_IMAGE)/fiptool
endef

$(eval $(call BuildPackage/Trusted-Firmware-A))
