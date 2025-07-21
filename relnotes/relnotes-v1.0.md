# Zeppe-Lin v1.0: Release Notes

Released Jan 18, 2025.  3rd Zeppe-Lin Release.

## Introduction

The arrival of Zeppe-Lin v1.0 -- The Maiden Voyage -- marks a major
milestone as our first stable major release.  This version embodies
the resilience and hard work invested in developing essential system
tools, marking the start of a promising future for Zeppe-Lin.  Through
research and refinement, we've emerged stronger, and our cover art
visually encapsulates this spirit of enduring flight.

If you're upgrading from an earlier release (for example, v0.99),
please review the transitional notes in
[v0.99.1](relnotes-v0.99.1.html).

## Incompatible Changes

- **Kernel Ring Buffer Logging**:
  The `/etc/rc` script now saves the kernel ring buffer to
  `/var/log/dmesg` (instead of `/var/log/boot`) for the new
  `bootlogd(8)` functionality.  Update scripts using the old path (if
  any).

- **Glibc's libcrypt replaced by libxcrypt**:
  Update `glibc` before installing `libxcrypt` to avoid file
  conflicts.

- **c99 Now Separate Package: Install After gcc**:
  Update `gcc` first, then install `c99` to avoid file conflicts.

## New Features

- **Binary Package Support**:
  Zeppe-Lin v1.0 now offers pre-built binary packages for
  `pkgsrc-core`.  This significantly simplifies the upgrade process
  and reduces the risk of issues associated with building from source.
  Install them using `pkgadd(1)`.  See the [Download](#download)
  section for the archive.

- **PAX & CAPS in pkgutils**:
  `pkgutils` and `pkgmk` have been updated to optionally handle ACLs
  (`acl(5)`) and extended attributes (`xattr(7)`).  This enhancement
  allows for more fine-grained control over file permissions.

  Zeppe-Lin enables **only** `xattr(7)` in `pkgutils`' `Pkgfile`, with
  `pkgmk` using `pax` as the default archive format.  This allows
  setting specific permissions (Linux capabilities) for programs like
  `ping(8)` without needing full root privileges or extra installation
  steps (like `post-install` scripts with `setcap`).  See `pkgmk(8)`
  and `pkgadd(8)` for details.

- **Standard C Compilers as Separate Packages**:
  New shell wrappers like `c89`, `c99`, and `c17` are now separate
  packages for standard C compilers.  Previously, `c99` was part of
  `gcc`.  This improves system development standards.  Check their man
  pages for details (thanks to NetBSD for them).

- **dumb\_runtime\_dir PAM Module**:
  Zeppe-Lin v1.0 now uses the `dumb-runtime-dir` PAM module by default
  to manage `XDG_RUNTIME_DIR`, improving how user-specific runtime
  directories are handled for desktop applications.  See
  `pam_dumb_runtime_dir(8)` for details.

- **Additional Package Sources Collections**:
  New unofficial collections: `pkgsrc-games` and `pkgsrc-wmaker`.

- **Markdown Package READMEs**:
  `pkgman` now supports Markdown (`.md`) for package READMEs, in
  addition to plain text.  All READMEs have been converted to Markdown
  for improved formatting and readability.  Try:

      PAGER=markdown_viewer pkgman readme dhcpcd

- **Flexible Init with Device Manager Choice**:
  The `DEVMGR` variable in `/etc/rc.conf` now allows you to select
  your preferred device manager.  `udevd` remains the default if no
  choice is made.  See `rc.conf(5)` for details.

- **Boot Logging with bootlogd**:
  Zeppe-Lin v1.0 now includes `/etc/rc.d/bootlogd` for boot logging
  (provided by `sysvinit`).  To enable it, set `BOOTLOGD=yes` in
  `/etc/rc.conf`.  Boot messages will be saved to `/var/log/boot`.
  See `rc.conf(5)` and `bootlogd(8)` for details.

- **Vim Syntax Files and Bash Completion**:
  Vim now highlights syntax in `/etc/pkgadd.conf` and
  `/etc/pkgman.conf`.  Bash completion has also been added for
  Zeppe-Lin command-line tools, enhancing terminal usability.

## Package Changes

### pkgsrc-core

- **New Packages**:

  ```
  c17
  c89
  c99
  dumb-runtime-dir
  ```

- **Removed Packages**:

  None in this release for `pkgsrc-core`.

- **Key Changes**:

  - `filesystem` now provides `pkgmk`'s directories
    (`/var/cache/pkgmk/*`) and adds `/etc/os-release`.
  - `libidn2` imported from `pkgsrc-system` (needed by `cmake`).
  - `eudev` now ships `/etc/rc.d/rc.udevd`.
  - `rejmerge` now ships `gnufind.patch`, [see why](https://github.com/zeppe-lin/rejmerge/issues/8).
  - `sysvinit` now ships `/etc/rc.d/rc.bootlogd`.

### pkgsrc-system

- **New Packages**:

  ```
  liburcu
  py3-packaging
  ```

- **Removed Packages**:

  ```
  scons
  ```

- **Key Changes**:

  None in this release for `pkgsrc-system` beyond new and removed
  packages.

### pkgsrc-xorg

- **New Packages**:

  ```
  gxmessage3
  ninja
  py3-yaml
  xdialog
  xorg-font-misc-misc
  xorg-xcalc
  xorg-xcursorgen
  xorg-xdpyinfo
  xorg-xmag
  xorg-xmessage
  xorg-xmodmap
  xorg-xterm
  ```

- **Removed Packages**:

  ```
  xorg-libdmx
  vulkan-tools
  xorg-libxxf86misc
  ```

  Related issues:
  [1](https://github.com/zeppe-lin/pkgsrc-xorg/issues/1) and
  [2](https://github.com/zeppe-lin/pkgsrc-xorg/issues/2).

- **Key Changes**:

  None in this release for `pkgsrc-xorg` beyond new and removed
  packages.

### pkgsrc-desktop

- **New Packages**:

  ```
  adwaita-gtk-theme
  alsa-oss
  android-file-transfer
  bluecurve-gtk-theme
  bluecurve-icon-theme
  btop
  buuf-icon-theme
  buuf-nestort-icon-theme
  crengine-ng
  crqt-ng
  dapper
  desktop-file-utils
  dragon-drop
  ffmpegthumbnailer
  gnome-icon-theme
  gpicview
  greymond-gtk-theme
  gtk-engine-bluecurve
  gtk-engine-clearlooks
  gtk-engine-crux
  gtk-engine-hc
  gtk-engine-murrine
  gtk-engine-redmond95
  icon-naming-utils
  krb5
  leafpad
  libplacebo
  libptytty
  libreoffice-bin
  libwebp
  libwnck
  lxinput
  lxtask
  mac
  mint-gtk-theme
  moc-eqsets
  notification-daemon
  nsxiv
  oath-toolkit
  p5-gnome2-wnck
  p5-gtk2-notify
  p5-xml-namespacesupport
  p5-xml-sax
  p5-xml-sax-base
  p5-xml-sax-expat
  p5-xml-simple
  parcellite
  password-store-otp
  py3-glad
  py3-jinja2
  recordmydesktop
  retrosmart-cursor-theme
  scrot
  shntool
  snownews
  ssr
  tango-icon-theme
  tango-icon-theme-extras
  udevil
  utf8cpp
  vifm-colors
  wavpack
  when
  win3x-gtk-theme
  xbindkeys
  xdg-utils
  xmlsec
  xpdf
  yt-dlp
  zbar
  zzzfm
  ```

- **Removed Packages**:

  ```
  broodwar-cursor-theme
  dunst
  gmtp
  jdk11-bin
  newsboat213
  stfl
  sxiv (*renamed to nsxiv basically*)
  youtube-dl
  ```

- **Key Changes**:

  Desktop-related packages have significantly expanded, introducing
  new themes and utility programs.

## Cover Artwork

Our release cover is an artful expression of Zeppe-Lin's spirit:

- Cover Image: [Direct Link](https://github.com/zeppe-lin/artwork/blob/master/v1.0.png?raw=true)

- Artwork Concept:
  A weathered zeppelin, a symbol of enduring flight through changing
  times, is held within the precise embrace of a gear -- representing
  the robust and carefully engineered core of Zeppe-Lin.  This emblem
  signifies the start of a reliable and enduring journey.

The cover artwork is licensed under the Creative Commons
Attribution-ShareAlike 3.0 Unported License (CC-BY-SA 3.0).

## Kernel

- `linux` 5.4.263 (LTS until Dec 2025)

  Includes [Wi-Fi pentest patches](https://github.com/sighook/lwpp).

## Toolchain

- `glibc` 2.40
- `gcc` 14.2.0
- `binutils` 2.43.1

## X11

- `Xorg` 7.7
- `xorg-server` 21.1.15
- `mesa` 24.3.3
- `amdgpu` 23.0.0
- `ati` 22.0.0
- `intel` 2.99.917-923

## Changelogs

For a comprehensive list of changes in this release, please refer to
the detailed changelogs available for each component:

- [pkgsrc-core ChangeLog](https://github.com/zeppe-lin/pkgsrc-core/releases/tag/v1.0)
- [pkgsrc-system ChangeLog](https://github.com/zeppe-lin/pkgsrc-system/releases/tag/v1.0)
- [pkgsrc-xorg ChangeLog](https://github.com/zeppe-lin/pkgsrc-xorg/releases/tag/v1.0)
- [pkgsrc-desktop ChangeLog](https://github.com/zeppe-lin/pkgsrc-desktop/releases/tag/v1.0)

## Download

Before downloading, please review
[handbook](https://zeppe-lin.github.io/handbook.html)
for installation tips and hardware compatibility.

The release files are available at:

- [**Root Filesystem Archive**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.0/rootfs-v1.0-x86_64.tar.xz)
- [**Root Filesystem Signature**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.0/rootfs-v1.0-x86_64.tar.xz.sig)
- [**Binary Packages Archive**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.0/binpkgs-v1.0-x86_64.tar.xz)
- [**Binary Packages Signature**](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.0/binpkgs-v1.0-x86_64.tar.xz.sig)

You might also want to check out:

- [`mkrootfs`](https://github.com/zeppe-lin/mkrootfs)
  Tool to build custom rootfs image.  It can be installed on Zeppe-Lin
  using the command:

      pkgman install --deps --group mkrootfs

- [`dockerfile`](https://github.com/zeppe-lin/dockerfile)
  Instructions to build docker image.


*sighook // Until the next entry... Zeppe-Lin awaits.*
