PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Default sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Titania.ogg \
    ro.config.notification_sound=Tethys.ogg

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/tipsy/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/tipsy/prebuilt/common/bin/50-tipsy.sh:system/addon.d/50-tipsy.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Tipsy-specific init file
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.local.rc:root/init.tipsy.rc

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/tipsy/overlay/dictionaries

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/tipsy/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/tipsy/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/tipsy/prebuilt/common/bin/sysinit:system/bin/sysinit

# debug packages
ifneq ($(TARGET_BUILD_VARIENT),user)
PRODUCT_PACKAGES += \
    Development
endif

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam \
    Chromium

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra Optional packages
PRODUCT_PACKAGES += \
    SlimOTA \
    BluetoothExt \
    KernelAdiutor \
    LatinIME \
    LockClock \
    masquerade \
    Tavern
    

# SlimFileManager removed until updated

ifneq ($(DISABLE_SLIM_FRAMEWORK), true)
## Slim Framework
include frameworks/opt/slim/slim_framework.mk
endif

## Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Pixel Launcher
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/app/PixelLauncherPrebuilt.apk:system/priv-app/PixelLauncher/PixelLauncherPrebuilt.apk \
    vendor/tipsy/prebuilt/common/app/WallpaperPickerGooglePrebuilt.apk:system/app/PixelLauncher/WallpaperPickerGooglePrebuilt.apk
	    
# Google Dialer 
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/app/googledialer.apk:system/priv-app/GoogleDialer/googledialer.apk
	
# Adaway
PRODUCT_COPY_FILES += \
vendor/tipsy/prebuilt/common/app/adaway.apk:system/app/adaway.apk

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/tipsy/overlay/common

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/tipsy/overlay/dictionaries

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/tipsy/prebuilt/common/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Versioning System
# tipsy version.
PRODUCT_VERSION_MAJOR = 7.1.1
PRODUCT_VERSION_MINOR = Beta
PRODUCT_VERSION_MAINTENANCE = v4.0
ifdef TIPSY_BUILD_EXTRA
    TIPSY_POSTFIX := $(TIPSY_BUILD_EXTRA)
endif
ifndef TIPSY_BUILD_TYPE
    TIPSY_BUILD_TYPE := Release
    TIPSY_POSTFIX := $(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
TIPSY_VERSION := Tipsy-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)
TIPSY_MOD_VERSION := Tipsy-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    tipsy.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date) \
    ro.tipsy.version=$(TIPSY_VERSION) \
    ro.modversion=$(TIPSY_MOD_VERSION) \
    ro.tipsy.buildtype=$(TIPSY_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/tipsy/tools/tipsy_process_props.py

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
endif
