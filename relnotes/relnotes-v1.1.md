# Zeppe-Lin v1.1: Release Notes

Released Aug 1, 2025.  4th Zeppe-Lin Release.

## 1. Introduction

Zeppe-Lin 1.1 is here.

Still minimal. Still sharp.  Built quietly -- as always -- and tuned with care.
This release brings smoother control, fewer rough edges, and a bit more
attitude.

The vibe is: **Built in the dark, ready to shine on your rig**.
This line belongs to **Stine Luft Satomi** -- the fictional hacker spirit of
Zeppe-Lin.  She's part of the art, part of the vision: focused, quiet, and
deliberate.

If you're upgrading from a previous version, please check the
[v1.0 release notes](relnotes-v1.0.html) for important transitional
information.

## 2. Release Artwork

* **Image**: [v1.1 Cover Art](https://github.com/zeppe-lin/artwork/blob/master/v1.1.png?raw=true)

* **Concept**: The art depicts Stine Luft Satomi in her underground lair,
  visually echoing the quiet, focused, and intentional energy behind Zeppe-Lin.

* **License**: Creative Commons Attribution-ShareAlike 3.0 Unported (CC-BY-SA 3.0)

## 3. Incompatible Changes

* **Glibc Recompiled for Kernel 6.1**:

  `glibc` and `glibc-32` are now compiled with `--enable-kernel=6.1` and
  updated kernel API headers (6.1.147).  This change enables support for newer
  `e2fsprogs` (1.47.3+) features such as `fs-verity`.  Attempting to build
  `e2fsprogs` against older headers (e.g., 5.4.x) will fail.

  A full toolchain rebuild is strongly recommended for system stability and
  compatibility.

  1. Build and install `linux-6.1`.
  2. Reboot into the new kernel.
  3. Rebuild toolchain in this order:
     * `glibc`, `glibc-32`
     * `binutils`
     * `gcc`
     * `libtool`
     * `binutils` _(again)_
     * `glibc`, `glibc-32` _(again)_
     * `libtool` _(again)_

  See [Toolchain Update Guide](https://zeppe-lin.github.io/codebook.html#321-core-toolchain-update-pkgsrc-core)
  for details.

## 4. What's New

### 4.1. Infrastructure

* **Mailing Lists**:

  Stay connected and get support through our new mailing lists on
  FreeLists.org.

  * **Users & Support**: `zeppe-lin@freelists.org`

    For questions, help, or tips.

    **[Subscribe via Email](mailto:zeppe-lin-request@freelists.org?subject=subscribe)** \|
    **[View List Page](https://www.freelists.org/list/zeppe-lin)**

  * **Development**: `zeppe-lin-dev@freelists.org`

    Code discussions, proposals, patch talks, and project changes.

    **[Subscribe via Email](mailto:zeppe-lin-dev-request@freelists.org?subject=subscribe)** \|
    **[View List Page](https://www.freelists.org/list/zeppe-lin-dev)**

* **Development**:

  * Commits to `pkgsrc-core`, `pkgsrc-system`, `pkgsrc-xorg`, `pkgsrc-desktop`
    now notify `zeppe-lin-dev@freelists.org`.

  * Commits with `[notify]` in the title also notify `zeppe-lin@freelists.org`.

### 4.2. Documentation

* New [Handbook](https://zeppe-lin.github.io/handbook.html)
  and [Codebook](https://zeppe-lin.github.io/codebook.html)
  built from scratch.

* New [Website](https://zeppe-lin.github.io/) launched.

All documentation/website sources are available at
<https://github.com/zeppe-lin/zeppe-lin.github.io>.

### 4.3. Package Changes

#### 4.3.1. pkgsrc-core

* **Added**:

  ```
  libxcrypt-32
  scdoc
  ```

* **Removed**:

  ```
  libxcrypt-compat
  ```

* **Notes**:

  * `glibc` and `glibc-32` now require kernel 6.1+.

#### 4.3.2. pkgsrc-system

* **Added**:

  ```
  iperf3
  pandoc-bin
  cmark
  nouveau-firmware
  linux-6.1
  ```

* **Removed**:

  ```
  handbook
  ```

#### 4.3.3. pkgsrc-xorg

* **Added**:

  ```
  xorg-xf86-input-evdev
  xorg-xf86-video-nouveau
  ```

* **Removed**:

  ```
  ninja
  xkbswitch
  ```

#### 4.3.4. pkgsrc-desktop

* **Added**:

  ```
  libxml2-2.13
  ```

* **Removed**:

  ```
  firefox-darkreader-bin
  firefox-vimium-bin
  st
  lsw
  dwmblocks
  dwm
  win3x-gtk-theme
  ```

* **Notes**:

  * `libxml2-2.13` required by `librsvg-compat`.

  * `firefox-darkreader-bin` and `firefox-vimium-bin` moved to `pkgsrc-stuff`.

  * `st`, `lsw`, `dwmblocks`, and `dwm` have been removed and now live at
    <https://github.com/rawmkit>.

### 4.4. System Components

#### 4.4.1. Kernel

* `linux` 6.15.8
* `linux-firmware` 20250708

#### 4.4.2. Toolchain

* `glibc` 2.40.1
* `gcc` 14.3.0
* `binutils` 2.44

#### 4.4.3. X11

* `Xorg` 7.7
* `xorg-server` 21.1.18
* `mesa` 24.3.4
* `amdgpu` 23.0.0
* `ati` 22.0.0
* `intel` 2.99.917-923
* `nouveau` 1.0.18
* `vesa` 2.6.0

## 5. Changelogs

Full per-repository details:

* [pkgsrc-core](https://github.com/zeppe-lin/pkgsrc-core/releases/tag/v1.1)
* [pkgsrc-system](https://github.com/zeppe-lin/pkgsrc-system/releases/tag/v1.1)
* [pkgsrc-xorg](https://github.com/zeppe-lin/pkgsrc-xorg/releases/tag/v1.1)
* [pkgsrc-desktop](https://github.com/zeppe-lin/pkgsrc-desktop/releases/tag/v1.1)

## 6. Download

Check the [Handbook](https://zeppe-lin.github.io/handbook.html) before
installing for setup tips and compatibility.

### 6.1. Root Filesystem

* [RootFS](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.1/rootfs-v1.1-x86_64.tar.xz)
* [RootFS Signature](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.1/rootfs-v1.1-x86_64.tar.xz.sig)

### 6.2. Binary Packages

* [BinPkgs](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.1/binpkgs-v1.1-x86_64.tar.xz)
* [BinPkgs Signature](https://github.com/zeppe-lin/pkgsrc-core/releases/download/v1.1/binpkgs-v1.1-x86_64.tar.xz.sig)

### 6.3. Extras

* [mkrootfs](https://github.com/zeppe-lin/mkrootfs) (build your own rootfs)
* [dockerfile](https://github.com/zeppe-lin/dockerfile) (instructions to build docker image)


*sighook // Until the next entry... Zeppe-Lin awaits.*
