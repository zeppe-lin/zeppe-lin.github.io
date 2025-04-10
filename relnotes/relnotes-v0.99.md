Zeppe-Lin v0.99: Release Notes
==============================

## Introduction

The Zeppe-Lin project is happy to announce the first stable release
v0.99! **Happy Birthday, Zeppe-Lin!**

This version represents a selected subset of fixes and updates for the
beta release from 2023-01-02 and has no breaking compatibility
changes.  Therefore, a simple update should not cause any issues:

    # pkgman sysup --deps --depsort

_Most likely_.

## Incompatible Changes

There are no breaking compatibility changes in this release.

## New Features

- _None in this release beyond what might be implicitly included in
  the base system._

## Package Changes

### pkgsrc-core

**New Packages:**

- _None in this release for pkgsrc-core beyond what might be
  implicitly included in the base system._

**Removed Packages:**

- _None in this release for pkgsrc-core._

**Key Changes:**

- Improved _pkgman.conf_ configuration file: added an example of how
  to renice build packages.

- Made screen blanking timeout configurable via the `BLANKTIME`
  variable in _rc.conf_.

### pkgsrc-desktop

**New Packages:**

- wgetpaste

**Removed Packages:**

- _None in this release for pkgsrc-desktop._

**Key Changes:**

- _None in this release for pkgsrc-desktop beyond the new package._

## Cover Artwork

The release cover for Zeppe-Lin v0.99:

- Cover Image: [Direct Link](https://github.com/zeppe-lin/artwork/blob/master/v0.99.png?raw=true)
- Artwork Concept: None.

The cover artwork is licensed under the Creative Commons
Attribution-ShareAlike 3.0 Unported License (CC-BY-SA 3.0).

## Kernel

- **linux** 5.3.238 (LTS until Dec 2025)

Includes [Wi-Fi pentest patches](https://github.com/sighook/lwpp).

## Toolchain

- **glibc** 2.36
- **gcc** 12.2.0
- **binutils** 2.39

## X11

- **Xorg** 7.7
- **xorg-server** 21.1.8
- **mesa** 23.0.3
- **amdgpu** 23.0.0
- **ati** 22.0.0
- **intel** 2.99.917-916

## Changelogs

For a comprehensive list of changes in this release, please refer to
the detailed changelogs available for each component:

- [pkgsrc-core ChangeLog](https://github.com/zeppe-lin/pkgsrc-core/releases/tag/v0.99)
- [pkgsrc-system ChangeLog](https://github.com/zeppe-lin/pkgsrc-system/releases/tag/v0.99)
- [pkgsrc-xorg ChangeLog](https://github.com/zeppe-lin/pkgsrc-xorg/releases/tag/v0.99)
- [pkgsrc-desktop ChangeLog](https://github.com/zeppe-lin/pkgsrc-desktop/releases/tag/v0.99)

## Download

Before downloading Zeppe-Lin, please read the
[handbook](https://zeppe-lin.github.io/handbook.html) to be sure
your hardware is supported and you know how to install it.

**Root Filesystem Archive & Signature**:
- [Root Filesystem Archive](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v0.99/rootfs-v0.99-x86_64.tar.xz)
- [Root Filesystem Signature](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v0.99/rootfs-v0.99-x86_64.tar.xz.sig)

You might also want to check out:

**mkrootfs** - tool to build custom rootfs image:
- <https://github.com/zeppe-lin/mkrootfs>

**dockerfile** - instructions to build docker image:
- <https://github.com/zeppe-lin/dockerfile>
