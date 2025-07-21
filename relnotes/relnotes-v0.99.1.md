# Zeppe-Lin v0.99.1: Release Notes

Released Dec 11, 2023.  2nd Zeppe-Lin Release.

## Introduction

The Zeppe-Lin project is happy to announce the second stable release
v0.99.1!
It represents a selected subset of fixes and updates for
[v0.99](relnotes-v0.99.html) and has one small (and not painful)
breaking compatibility change.

## Incompatible Changes

- **pkgutils Footprint File Changes**:
  During performance optimizations for `pkgutils`, the generation and
  sorting order of footprint files has been changed.  This may break
  system updates via `sysup`.  To avoid this, perform a forced upgrade
  of `pkgutils` and `pkgmk` before running a system upgrade:

      # pkgman update -f pkgmk pkgutils
      # rejmerge

- **New traceroute conflicts with inetutils**:
  New package `traceroute`, introduced to replace buggy
  `traceroute(8)` utility provided by `inetutils`.  Make sure you
  update `inetutils` before you install `traceroute`.

## New Features

- `pkgsrc-core/traceroute`: New package.  Previously, the buggy
  `traceroute(8)` utility was provided by `inetutils`.
- `pkgsrc-system/tree`: Switched to the maintained fork.
- `pkgsrc-system/ntfs-3g`: Added `fsck.ntfs`, a wrapper script around
  `ntfsfix(8)` that silently discards any unsupported flags from
  `/etc/rc`'s `fsck(8)`.  Also added `fsck.ntfs(8)` manual page.
- `pkgsrc-system/p11-kit`: Added a custom `update-ca-trust(1)` manual
  page.
- `pkgsrc-system/rdfind`: New package (needed by `linux-firmware`).
- `pkgsrc-system/alsa-ucm-conf`: New package.
- `pkgsrc-xorg/vulkan-{header,loader,tools}`: New packages (needed by
  `mesa` for `zink` support).
- `pkgsrc-xorg/xcompmgr`: New package.
- `pkgsrc-xorg/ttf-font-jetbrains-mono{,-nerd}`: New packages.
- `pkgsrc-xorg/gxmessage`: New package.
- `pkgsrc-xorg/libxpresent`: New package (needed by `mpv`).
- `pkgsrc-desktop/lsw`: New package.
- `pkgsrc-desktop/ratpoison`: New package.
- `pkgsrc-desktop/firefox-{darkreader,vimium}`: New packages.
- `pkgsrc-desktop/alsa-{firmware,plugins}`: New packages.
- `pkgsrc-desktop/ladspa`: New package.
- `pkgsrc-desktop/lxrandr`: New package.
- `pkgsrc-desktop/json-glib`: New package (needed by `zathura`).
- `pkgsrc-desktop/pick`: New package.
- `pkgsrc-desktop/broodwar-cursor-theme`: New package.

## Package Changes

### pkgsrc-core

- **New Packages**:
  ```
  traceroute
  ```

- **Removed Packages**:
  None in this release for pkgsrc-core.

- **Key Changes**:
  - `capstone` moved to `pkgsrc-system`
  - `/etc/pkgadd.conf` updated to silently upgrade `/etc/revdep.d`
    files
  - `rejmerge(8)` now allows redefining `PAGER` and `EDITOR` from
    command-line
  - small fixes and cleanups for `sysklogd`'s `rotatelog`
  - added `rotatelog(8)` man page to `sysklogd`

### pkgsrc-system

- **New Packages**:
  ```
  alsa-ucm-conf
  rdfind
  ```

- **Removed Packages**:
  None in this release for `pkgsrc-system`.

- **Key Changes**:
  - `tree` switched to the maintained fork
  - `capstone` imported from the `pkgsrc-core`
  - `ntfs-3g`: added `fsck.ntfs` (wrapper for `ntfsfix(8)`) and
    `fsck.ntfs(8)` man page
  - `lm-sensors`: configurations moved from `/usr/etc` to `/etc`
  - `freetype`: no longer pollutes `/etc/profile.d`
  - `p11-kit`: added `update-ca-trust(1)` man page

### pkgsrc-xorg

- **New Packages**:
  ```
  gxmessage
  libxpresent
  ttf-font-jetbrains-mono
  ttf-font-jetbrains-mono-nerd
  vulkan-header
  vulkan-loader
  vulkan-tools
  xcompmgr
  ```

- **Removed Packages**:
  None in this release for `pkgsrc-xorg`.

- **Key Changes**:
  None in this release for `pkgsrc-xorg` beyond new packages.

### pkgsrc-desktop

- **New Packages**:
  ```
  lsw
  ratpoison
  firefox-darkreader
  firefox-vimium
  alsa-firmware
  alsa-plugins
  ladspa
  lxrandr
  json-glib
  pick
  broodwar-cursor-theme
  ```

- **Removed Packages**:
  None in this release for `pkgsrc-desktop`.

- **Key Changes**:
  None in this release for `pkgsrc-desktop` beyond new packages.

## Cover Artwork

The release cover for Zeppe-Lin v0.99.1:

- Cover Image: [Direct Link](https://github.com/zeppe-lin/artwork/blob/master/v0.99.1.png?raw=true)
- Artwork Concept: None

The cover artwork is licensed under the Creative Commons
Attribution-ShareAlike 3.0 Unported License (CC-BY-SA 3.0).

## Kernel

- `linux` 5.4.244 (LTS until Dec 2025)

Included [Wi-Fi pentest patches](https://github.com/sighook/lwpp).

## Toolchain

- `glibc` 2.36 + CVE patches
- `gcc` 12.2.0
- `binutils` 2.39

## X11

- `Xorg` 7.7
- `xorg-server` 21.1.9
- `mesa` 23.3.0
- `amdgpu` 23.0.0
- `ati` 22.0.0
- `intel` 2.99.917-923

## Changelogs

For a comprehensive list of changes in this release, please refer to
the detailed changelogs available for each component:

- [pkgsrc-core ChangeLog](https://github.com/zeppe-lin/pkgsrc-core/releases/tag/v0.99.1)
- [pkgsrc-system ChangeLog](https://github.com/zeppe-lin/pkgsrc-system/releases/tag/v0.99.1)
- [pkgsrc-xorg ChangeLog](https://github.com/zeppe-lin/pkgsrc-xorg/releases/tag/v0.99.1)
- [pkgsrc-desktop ChangeLog](https://github.com/zeppe-lin/pkgsrc-desktop/releases/tag/v0.99.1)

## Download

Before downloading Zeppe-Lin, please read the
[handbook](https://zeppe-lin.github.io/handbook.html) to be sure
your hardware is supported and you know how to install it.

The release files are available at:

- [**Root Filesystem Archive**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v0.99.1/rootfs-v0.99.1-x86_64.tar.xz)
- [**Root Filesystem Signature**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v0.99.1/rootfs-v0.99.1-x86_64.tar.xz.sig)

You might also want to check out:

- [`mkrootfs`](https://github.com/zeppe-lin/mkrootfs>) (tool to build custom rootfs image)
- [`dockerfile`](https://github.com/zeppe-lin/dockerfile) (instructions to build docker image)


*sighook // Until the next entry... Zeppe-Lin awaits.*
