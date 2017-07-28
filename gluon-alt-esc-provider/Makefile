include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-alt-esc-provider
PKG_VERSION:=1
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include ../gluon.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/gluon-alt-esc-provider
  SECTION:=gluon
  CATEGORY:=Gluon
  DEPENDS:=+gluon-web-admin +ip6tables-mod-nat
  TITLE:=Gluon Alternative Exit Service Collaborator - Provider
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,gluon-alt-esc-provider,i18n)
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/gluon-alt-esc-provider/install
	$(CP) ./files/* $(1)/
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
endef

$(eval $(call BuildPackage,gluon-alt-esc-provider))
