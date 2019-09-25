BUNDLE_NAME := CopyBundleIDPrefs

include $(THEOS)/makefiles/common.mk

internal-stage::
	@mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences
	@cp -v $(BUNDLE_NAME)* $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/
