include $(TOPDIR)/rules.mk

PKG_NAME:=zizzania
PKG_VERSION:=0.2.1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=libpthread libpcap

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=zizzania
	MAINTAINER:=cyrus-and<https://github.com/cyrus-and/zizzania>
	DEPENDS:=+libpthread +libpcap
endef

define Package/$(PKG_NAME)/description
	Automated DeAuth Attack Tool
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp -r src/* $(PKG_BUILD_DIR)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/zizzania $(1)/usr/bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
