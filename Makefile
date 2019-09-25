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

ifeq ($(SIMULATOR), 1)
setup:: all
	@rm -f /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(THEOS_OBJ_DIR)/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).dylib
	@cp -v $(PWD)/$(TWEAK_NAME).plist /opt/simject

remove::
	@rm -f /opt/simject/$(TWEAK_NAME).dylib /opt/simject/$(TWEAK_NAME).plist
endif
