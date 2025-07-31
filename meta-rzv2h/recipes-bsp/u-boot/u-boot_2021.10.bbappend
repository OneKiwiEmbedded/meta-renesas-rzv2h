DESCRIPTION = "U-boot for the RZ/V2H based board"

#UBOOT_URL = "git://github.com/renesas-rz/renesas-u-boot-cip.git"
#BRANCH = "v2021.10/rzv2h"
UBOOT_URL = "git://github.com/OneKiwiEmbedded/uboot-renesas-rzv2h.git"
BRANCH = "onekiwi-v2021.10/rzv2h-sdk-v5.20"

#SRC_URI = "${UBOOT_URL};branch=${BRANCH}"
#SRCREV = "31d53b8f6fdc1d9055a8c226643f4ed61570e017"
SRC_URI = "${UBOOT_URL};branch=${BRANCH}"
SRCREV = "${AUTOREV}"

PV = "v2021.10+git${SRCPV}"
