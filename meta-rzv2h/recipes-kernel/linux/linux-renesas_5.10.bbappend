DESCRIPTION = "Linux kernel for the RZ/V2H based board"

COMPATIBLE_MACHINE_rzv2h = "(rzv2h-dev|rzv2h-evk-alpha|rzv2h-evk-ver1|rzv2h-onekiwi)"

#BRANCH = "rzv2h-5.10-cip17"
#SRCREV = "e61e051bbc0ca55359bb92a3e0f1a626da77da16"
KERNEL_URL = "git://github.com/OneKiwiEmbedded/linux-renesas-rzv2h.git"
BRANCH = "onekiwi-rzv2h-5.10-cip17-sdk-v5.00-dev"
SRCREV = "${AUTOREV}"

LINUX_VERSION = "5.10.145-cip17"

SRC_URI_remove = " \
	file://0001-Fixed-an-issue-that-caused-flicker-when-outputting-t.patch \
"
