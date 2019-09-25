INSTALL_TARGET_PROCESSES = SpringBoard

SIMULATOR ?= 1
ifeq ($(SIMULATOR), 1)
export ARCHS = x86_64
export TARGET = simulator:clang::7.0
else
export ARCHS = arm64
endif

export SDKVERSION = 12.4

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CopyBundleID
CopyBundleID_FILES = Tweak.xm
CopyBundleID_FRAMEWORKS = UIKit
CopyBundleID_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += CopyBundleIDPrefs

# for Xcode 9 or later
PL_SIMULATOR_ROOT = /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot
PL_SIMULATOR_BUNDLES_PATH = $(PL_SIMULATOR_ROOT)/Library/PreferenceBundles
PL_SIMULATOR_PLISTS_PATH = $(PL_SIMULATOR_ROOT)/Library/PreferenceLoader/Preferences

ifeq ($(SIMULATOR), 1)
setup:: all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject
	@sudo cp -v $(PWD)/CopyBundleIDPrefs/CopyBundleIDPrefs.plist $(PL_SIMULATOR_PLISTS_PATH)/CopyBundleIDPrefs.plist

remove::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).plist
	@sudo rm -f $(PL_SIMULATOR_PLISTS_PATH)/CopyBundleIDPrefs.plist
endif
