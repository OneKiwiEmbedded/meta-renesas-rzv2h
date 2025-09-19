# meta-renesas

## Build Instructions

You can get all Yocto build environment from Renesas, or download all Yocto related public source to prepare the build environment as below.
```bash
    $ git clone https://git.yoctoproject.org/git/poky
    $ cd poky
    $ git checkout dunfell-23.0.31
    $ git cherry-pick eb0915c699fbe86488de172d529f073a30d05b6a
    $ cd ..
    $     
    $ git clone https://github.com/openembedded/meta-openembedded
    $ cd meta-openembedded
    $ git checkout daa4619fe3fbf8c28f342c4a7163a84a330f7653
    $ cd ..
    $    
    $ git clone https://git.yoctoproject.org/git/meta-gplv2
    $ cd meta-gplv2 
    $ git checkout 60b251c25ba87e946a0ca4cdc8d17b1cb09292ac
    $ cd ..
    $
    $ git clone  https://github.com/OneKiwiEmbedded/meta-renesas-rzv2h.git meta-renesas
    $ cd meta-renesas
    $ git checkout onekiwi-dunfell/rzv2h-sdk-v5.20
    $ cd ..
    $
    $ git clone  https://github.com/meta-qt5/meta-qt5.git
    $ cd meta-qt5
    $ git checkout -b tmp c1b0c9f546289b1592d7a895640de103723a0305
    $ cd ..
    $
    $ git clone  https://git.yoctoproject.org/git/meta-virtualization -b dunfell
    $ cd meta-virtualization
    $ git checkout 521459bf588435e847d981657485bae8d6f003b5
    $ cd ..
```
\<tag\> can be selected in any tags of meta-renesas.
Now the latest version is **BSP-3.0.x** or **BSP-3.0.x-updatey** if any new updates are applied.

Currently, there are 2 types of build procedure supported in below description:

**1. New build procedure (Recommended):**
- Initialize a build using the 'oe-init-build-env' script in Poky and point TEMPLATECONF to platform conf path. e.g.:
   ```bash
   $ source poky/oe-init-build-env
   $ cp ../meta-renesas/meta-rzv2h/docs/template/conf/rzv2h-onekiwi/*.conf conf/
   ```
- To build optional features (Docker, Codec or Graphics, QT5, Bootloaders, Security), add necessary layers:
   ```bash
   # For Docker
   $ bitbake-layers add-layer ../meta-openembedded/meta-filesystems
   $ bitbake-layers add-layer ../meta-openembedded/meta-networking
   $ bitbake-layers add-layer ../meta-virtualization

   # For Codec
   $ bitbake-layers add-layer ../meta-rz-features/meta-rz-codecs

   # For Graphics
   $ bitbake-layers add-layer ../meta-rz-features/meta-rz-graphics

   # For QT5
   $ bitbake-layers add-layer ../meta-qt5

   # For Bootloaders (only for RZ/V2M and RZ/V2MA)
   $ bitbake-layers add-layer ../meta-rz-features/meta-rz-bootloaders

   # For Security (supported for RZ/G2[H,M,N,E], RZ/G2[L,LC,UL] and RZ/V2L)
   $ bitbake-layers add-layer ../meta-rz-features/meta-rz-security
   ```
- Build the target file system image using bitbake:
   ```bash
   $ bitbake core-image-weston
   ```

Images generated:
* Image (generic Linux Kernel binary image file)
* DTB for target machine
* core-image-weston-rzv2h-onekiwi.tar.bz2 (rootfs tar+bzip2)
* core-image-weston-rzv2h-onekiwi.ext4  (rootfs ext4 format)
* core-image-weston-rzv2h-onekiwi.wic.gz  (rootfs wic gz format)
* core-image-weston-rzv2h-onekiwi.wic.bmap  (rootfs wic block map format)

## Build Instructions for SDK

Use bitbake -c populate_sdk for generating the toolchain SDK:
For 64-bit target SDK (aarch64):
```bash
    $ bitbake core-image-weston -c populate_sdk
```
The SDK can be found in the output directory _'tmp/deploy/sdk'_

    poky-glibc-x86_64-core-image-weston-aarch64-toolchain-x.x.sh

Usage of toolchain SDK: Install the SDK to the default: _/opt/poky/x.x_
For 64-bit target SDK:
```bash
    $ sh poky-glibc-x86_64-core-image-weston-aarch64-toolchain-x.x.sh
```
For 64-bit application use environment script in _/opt/poky/x.x_
```bash
    $ source /opt/poky/x.x/environment-setup-aarch64-poky-linux
```

## Build configs

It is possible to change some build configs as below:
* GPLv3: choose to not allow, or allow, GPLv3 packages
  * **Non-GPLv3 (default):** not allow GPLv3 license. All recipes that has GPLv3 license will be downgrade to older version that has alternative license (done by meta-gplv2). In this setting customer can ignore the risk of strict license GPLv3
  ```
  INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"
  ```
  * Allow-GPLv3: allow GPLv3 license. If user is fine with strict copy-left license GPLv3, can use this setting to get newer software version.
  ```
  #INCOMPATIBLE_LICENSE = "GPLv3 GPLv3+"
  ```
* CIP Core: choose the version of CIP Core to build with. CIP Core are software packages that are maintained for long term by CIP community. You can select by changing "CIP_MODE".
  * **Buster (default):** use as many packages from CIP Core Buster as possible.
  ```
  CIP_MODE = "Buster"
  ```
  * Bullseye: use as many packages from CIP Core Bullseye.
  ```
  CIP_MODE = "Bullseye"
  ```
  * None CIP Core: not use CIP Core at all, use all default version from Yocto 3.1 Dunfell
  ```
  CIP_MODE = "None" or unset CIP_MODE
  ```
* QT Demo (unsupported for RZ/V2M and RZ/V2MA): choose QT5 Demonstration to build with core-image-qt. QT5 Demos are some applications to demonstrate QT5 framework.
  * Unset QT_DEMO (default): all QT5 Demos are not built with core-image-qt.
  ```
  #QT_DEMO = "1"
  ```
  * Allow QT_DEMO: all QT5 Demos are built and included in core-image-qt.
  ```
  QT_DEMO = "1"
  ```
* Realtime Linux (unsupported for RZ/V2M and RZ/V2MA): choose realtime characteristic of Linux kernel to build with. You can enable this feature by setting the value "1" to IS_RT_BSP variable in local.conf:
  ```
  IS_RT_BSP = "1"
  ```
* Create SBoM SPDX: generate JSON SPDX for images.
  * **Disable creating SBoM SPDX (default):** creating SPDX is not supported.
  ```
  #INHERIT += "create-spdx"
  ```
  * **Enable creating SBoM SPDX:** creating SPDX is supported and built.
  ```
  INHERIT += "create-spdx"
  ```
    * Below variables are optional settings to create spdx. Uncomment out them to enable the features (disabled by default):
      * SPDX_PRETTY: Make generated files more human readable (newlines, indentation)
      ```
      SPDX_PRETTY = "1"
      ```
      * SPDX_ARCHIVE_PACKAGED: Add compressed archives of the files in the generated target packages.
      ```
      SPDX_ARCHIVE_PACKAGED = "1"
      ```
    * When enabling SBoM SPDX support, SDK will be failed to build. To fix it, please apply below changes in "poky/meta/classes/populate_sdk_base.bbclass":
      ```
      -do_populate_sdk[cleandirs] = "${SDKDEPLOYDIR}"
      +do_populate_sdk[cleandirs] += "${SDKDEPLOYDIR}"

      ```
* WIC image (unsupported for RZ/G1 MPUs): deploy disk images format. It is enabled by default in local.conf. To disable it, please comment out or set 0 to below setting:
  ```
  WKS_SUPPORT ?= "1"
  ```
  If you do not want to use default wic image file, please update "WKS_DEFAULT_FILE" or "WKS_FILE" to your desirable file.
