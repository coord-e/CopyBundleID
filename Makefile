export ARCHS = arm64
export SDKVERSION = 12.4

include theos/makefiles/common.mk

TWEAK_NAME = CopyBundleID
CopyBundleID_FILES = Tweak.xm
CopyBundleID_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
