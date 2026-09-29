#
# KiroOS emulator board: the generic x86_64 emulator board (qemu2 "ranchu", goldfish HALs)
# with room for the KiroOS system and the kAI models. The stock 2 GB system partition can't
# hold them: the phones' system is ~3 GB with the models.
#

include build/target/board/generic_x86_64/BoardConfig.mk

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2147483648

# No build-time dexpreopt: the host dex2oat of Android 7 can't map the x86_64 boot image at its
# fixed address on the WSL 6.x kernel ("Failed to mmap at expected address, mapped at
# 0x772f57c00000 instead of 0x70514000"). The emulator compiles the boot image and the apps on
# its first boot instead.
WITH_DEXPREOPT := false
