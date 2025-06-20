DESCRIPTION = "U-boot for the RZ/V2H based board"

#UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"
#BRANCH = "v2021.10/rzv2h"
UBOOT_URL = "git://github.com/OneKiwiEmbedded/uboot-renesas-rzv2h.git"
BRANCH = "onekiwi-v2021.10/rzv2h-sdk-v5.00-dev"

SRC_URI = "${UBOOT_URL};branch=${BRANCH}"
SRCREV = "${AUTOREV}"

PV = "v2021.10+git${SRCPV}"
