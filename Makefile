export ARCHS = arm64
export SDKVERSION = 12.4

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CopyBundleID
CopyBundleID_FILES = Tweak.xm
CopyBundleID_FRAMEWORKS = UIKit
CopyBundleID_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
