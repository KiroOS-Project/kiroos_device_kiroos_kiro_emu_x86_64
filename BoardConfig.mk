#
# KiroOS emulator board: the generic x86_64 emulator board (qemu2 "ranchu", goldfish HALs)
# with room for the KiroOS system and the kAI models. The stock 2 GB system partition can't
# hold them: the phones' system is ~3 GB with the models.
#

include build/target/board/generic_x86_64/BoardConfig.mk

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2147483648
