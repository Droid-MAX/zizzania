include $(TOPDIR)/rules.mk

PKG_NAME:=zizzania
PKG_VERSION:=0.3.0
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=libpthread libpcap
PKG_MAINTAINER:=Andrea Cardaci <https://cardaci.xyz/>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Automated DeAuth attack tool
	MAINTAINER:=Andrea Cardaci <https://cardaci.xyz/>
	URL:=https://github.com/cyrus-and/zizzania
	DEPENDS:=+libpthread +libpcap
	TARGET_CFLAGS:=-std=gnu99 -Wall -O3 -Os
	TARGET_LDFLAGS:=-ldl -lpthread -lpcap
endef

define Package/$(PKG_NAME)/description
	Automated DeAuth attack tool
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp -r src/* $(PKG_BUILD_DIR)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/zizzania $(1)/usr/sbin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
