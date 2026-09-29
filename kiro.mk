#
# KiroOS on the Android emulator (x86_64, qemu2 "ranchu" with KVM), to try the OS on the PC.
#
# The same system as the phones (frameworks, SystemUI, Settings, the KiroOS apps, theme, boot
# animation, kAI with its models) on the emulator's virtual hardware. Not here: the Samsung
# hardware and what drives it (perf profiles, charging control, Edge Glow, speaker EQ) and
# GApps, which ship ARM libraries only. Apps from KeurStore install when they have x86 builds.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_x86_64.mk)
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

KIROOS_COMMON := device/samsung/universal7420-common/kiroos

# KiroOS overlays (theme, wallpaper, framework defaults) over the emulator ones
DEVICE_PACKAGE_OVERLAYS += $(KIROOS_COMMON)/overlay

PRODUCT_COPY_FILES += \
    $(KIROOS_COMMON)/media/bootanimation.zip:system/media/bootanimation.zip

# kAI models, as on the phones (kiroos.mk)
KIROOS_KAI := vendor/kiroos/kai
KIROOS_KAI_FILES := \
    qwen3-0.6b-q4_k_m.gguf \
    smollm2-135m-instruct-q4_k_m.gguf \
    llama-3.2-1b-instruct-q4_k_m.gguf \
    whisper-base-q5_1.bin \
    NOTICE.txt \
    LICENSE-Qwen3.txt \
    LICENSE-Llama-3.2.txt \
    LICENSE-whisper.txt
PRODUCT_COPY_FILES += \
    $(foreach f,$(KIROOS_KAI_FILES),$(if $(wildcard $(KIROOS_KAI)/$(f)),$(KIROOS_KAI)/$(f):system/usr/share/kai/$(f)))

# adb on from boot, authorized for this PC's adb keys only (adb_keys: WSL and Windows adbkey.pub,
# made by ~/kai/r8_adbkeys.sh, not in git). LineageOS defaults to usb.config none, which left the
# emulator without adb.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=adb
ifneq ($(wildcard device/kiroos/kiro_emu_x86_64/adb_keys),)
# adbd (N) trusts /adb_keys besides /data/misc/adb/adb_keys; this tree has no PRODUCT_ADB_KEYS
PRODUCT_COPY_FILES += device/kiroos/kiro_emu_x86_64/adb_keys:root/adb_keys
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.webview.provider=com.android.webview \
    ro.kiroos.model=Emulator \
    ro.kiroos.ram_gb=4 \
    ro.kiroos.edge=0 \
    ro.kiroos.emulator=1

# KiroOS app suite and the stock apps it replaces
$(call inherit-product, packages/apps/KiroOS/kiroos_apps.mk)

# LineageOS's FFmpeg codec plugins: external/ffmpeg has no x86_64 configuration, the emulator
# plays media with the stock Android codecs
PRODUCT_PACKAGES_REMOVE += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

# WebView: the tree only has the ARM prebuilts (roomservice.xml removes the x86 projects). Until
# external/chromium-webview/prebuilt/x86_64/webview.apk is fetched (Git LFS, ~251 MB), the
# emulator has no WebView and the apps that show web pages can't open them.
ifeq ($(wildcard external/chromium-webview/prebuilt/x86_64/webview.apk),)
PRODUCT_PACKAGES_REMOVE += webview
endif

PRODUCT_NAME := kiro_emu_x86_64
PRODUCT_DEVICE := kiro_emu_x86_64
PRODUCT_BRAND := KiroOS
PRODUCT_MODEL := KiroOS Emulator
PRODUCT_MANUFACTURER := KiroOS
