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

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/tipsy/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/tipsy/prebuilt/common/bin/50-slim.sh:system/addon.d/50-slim.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Tipsy-specific init file
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.local.rc:root/init.slim.rc

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/tipsy/overlay/dictionaries

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

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

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    LatinIME \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

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
    SlimLauncher \
    BluetoothExt \
    LockClock \
    OmniSwitch \
    DashClock \
    KernelAdiutor \
    masquerade

#    SlimFileManager removed until updated

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    ntfsfix \
    ntfs-3g

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

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

# Busybox
PRODUCT_PACKAGES += \
    Busybox

# Viper4Android
PRODUCT_COPY_FILES += \
   vendor/tipsy/prebuilt/common/bin/audio_policy.sh:system/audio_policy.sh \
   vendor/tipsy/prebuilt/common/addon.d/95-LolliViPER.sh:system/addon.d/95-LolliViPER.sh \
   vendor/tipsy/prebuilt/common/su.d/50viper.sh:system/su.d/50viper.sh \
   vendor/tipsy/prebuilt/common/app/Viper4Android/Viper4Android.apk:system/priv-app/Viper4Android/Viper4Android.apk 

# Bootanimation 
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/media/bootanimation.zip:system/media/bootanimation.zip

# SuperSU
PRODUCT_COPY_FILES += \
	vendor/tipsy/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
	vendor/tipsy/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# NovaLauncher
PRODUCT_COPY_FILES += \
vendor/tipsy/prebuilt/common/app/Nova33.apk:system/app/Nova33.apk

#Es File Explorer
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/app/ESFE.apk:system/app/ESFE.apk

# Adaway
PRODUCT_COPY_FILES += \
vendor/tipsy/prebuilt/common/app/adaway.apk:system/app/adaway.apk


# Versioning System
# tipsyM first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = OMS
PRODUCT_VERSION_MAINTENANCE = v4.4
ifdef TIPSY_BUILD_EXTRA
    TIPSY_POSTFIX := $(TIPSY_BUILD_EXTRA)
endif
ifndef TIPSY_BUILD_TYPE
    TIPSY_BUILD_TYPE := Release
    TIPSY_POSTFIX := $(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
TIPSY_VERSION := Tipsy-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)
TIPSY_MOD_VERSION := Tipsy-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    tipsy.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date) \
    ro.tipsy.version=$(TIPSY_VERSION) \
    ro.modversion=$(TIPSY_MOD_VERSION) \
    ro.tipsy.buildtype=$(TIPSY_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/tipsy/tools/tipsy_process_props.py

