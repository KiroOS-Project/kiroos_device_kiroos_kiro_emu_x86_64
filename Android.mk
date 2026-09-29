#
# KiroOS emulator (x86_64)
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),kiro_emu_x86_64)

# LineageOS modules (tinyalsa, ...) depend on the kernel headers a kernel build installs in
# KERNEL_OBJ/usr (vendor/cm/build/tasks/kernel.mk). The emulator boots the prebuilt ranchu kernel,
# so nothing creates it: an empty include dir, the UAPI headers then come from bionic.
$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr:
	@mkdir -p $@/include

endif
