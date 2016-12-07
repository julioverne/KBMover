include theos/makefiles/common.mk

TWEAK_NAME = KBMover
KBMover_FILES = KBMover.xm
KBMover_FRAMEWORKS = UIKit CoreGraphics CoreImage Foundation CoreFoundation QuartzCore CydiaSubstrate
KBMover_PRIVATE_FRAMEWORKS = 
KBMover_CFLAGS = -fobjc-arc -std=c++11
KBMover_LDFLAGS = -Wl,-segalign,4000
export ARCHS = armv7 arm64
KBMover_ARCHS = armv7 arm64
include $(THEOS_MAKE_PATH)/tweak.mk

all::
	@echo "[+] Copying Files..."
	@ldid -S ./obj/KBMover.dylib
	@cp ./obj/KBMover.dylib //Library/MobileSubstrate/DynamicLibraries/KBMover.dylib
	@cp ./KBMover.plist //Library/MobileSubstrate/DynamicLibraries/KBMover.plist
	@echo "DONE"
	@killall SpringBoard

	
