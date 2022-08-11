#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=optee-ma35d1
PKG_VERSION:=3.9.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/OpenNuvoton/MA35D1_optee_os-v3.9.0.git
PKG_SOURCE_DATE:=2022-07-13
PKG_SOURCE_VERSION:=b571ccc281333465bcd767c2d4945f1fb16b4597

include $(INCLUDE_DIR)/optee.mk
include $(INCLUDE_DIR)/package.mk

define Optee/Default
  BUILD_TARGET:=ma35d1
  PLATFORM:=nuvoton
  PLATFORM_FLAVOR:=MA35D1
  OPTEE_IMAGE:=tee.bin tee-pager_v2.bin tee-pageable_v2.bin tee-header_v2.bin
endef

define Optee/som
  NAME:=MA35D1 SOM board
  BUILD_SUBTARGET:=som
endef

define Optee/iot
  NAME:=MA35D1 IoT board
  BUILD_SUBTARGET:=iot
endef

OPTEE_TARGETS := \
	som \
	iot

OPTEE_MAKE_FLAGS += all

define Package/optee/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/out/arm-plat-nuvoton/core/tee.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/out/arm-plat-nuvoton/core/tee-pager_v2.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee-pager_v2.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/out/arm-plat-nuvoton/core/tee-pageable_v2.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee-pageable_v2.bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/out/arm-plat-nuvoton/core/tee-header_v2.bin $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-tee-header_v2.bin
endef

$(eval $(call BuildPackage/Optee))
