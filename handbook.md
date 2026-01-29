---
title: Zeppe-Lin Handbook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

Zeppe-Lin Handbook.  
*Because figuring it out yourself is overrated.*

This guide provides everything you need to install, configure, and
maintain your Zeppe-Lin system.

Build the system you need.
This handbook shows you how.  
*Because nobody else will.*

---

# INTRODUCTION

## About Zeppe-Lin

Zeppe‑Lin is a lightweight, source‑based GNU/Linux distribution for
x86‑64 systems.
A fork of CRUX, it emphasizes simplicity, predictability, and
maintainable design.
It follows UNIX principles: small tools, plain‑text configuration, and
explicit behavior.
Automation is minimal and visible.

Zeppe‑Lin is designed for users who want full control over their
system.
Everything can be built, inspected, and maintained from source,
ensuring autonomy, transparency, and reproducibility.
The system favors practical, reliable behavior over cleverness or
unnecessary features.

## Audience

Zeppe‑Lin suits users who:

- Prefer a minimal and predictable environment
- Manage and configure the system via text files
- Build software from source to control dependencies
- Want to fully understand and maintain their system

## Summary

By keeping components small, behavior explicit, and operations
visible, Zeppe‑Lin ensures the system is comprehensible, controllable,
and practical, while remaining flexible enough to adapt to individual
needs.

---

# INSTALLATION

## Supported Hardware

Zeppe-Lin Linux supports **x86-64** processors (e.g., AMD Athlon 64,
Intel Core, Intel Atom).
Older architectures, such as i686, are **incompatible**.

## Boot a Live System

Zeppe-Lin is distributed as a compiled tarball containing a root
filesystem.
To install it, first boot your computer using a Linux-based "Live
CD/DVD/USB" system.

Launch your preferred Live system, open a terminal, and gain root
privileges (e.g., `sudo su`).

## Disk Partitions and Filesystems

This section describes "UEFI and LVM on LUKS" installation.
Additional partitions/filesystems schemes may be added in the future.

### UEFI and LVM on LUKS

Set up Zeppe-Lin on a fully encrypted disk (excluding the bootloader
partition for UEFI compatibility) using `dm-crypt` with LUKS and an
LVM container inside the encrypted partition.

> **Important:**
>
> Ensure the following tools are available in the Live system:
>
>  - `parted` - Create and manage partitions.
>  - `dosfstools` - Format the boot partition as FAT32 (UEFI).
>  - `cryptsetup` - Encrypt partition with LUKS.
>  - `lvm2` - Manage logical volumes inside LUKS.

#### Partition Scheme

Example device: `/dev/sda`.
Replace with your actual device (e.g., `/dev/sdb`, `/dev/nvme0n1`).

| Partition | Filesystem | Size             | Description    |
| --------- | ---------- | ---------------- | -------------- |
| /dev/sda1 | FAT32      | 512 MiB          | boot partition |
| /dev/sda2 | none       | remaining space  | LUKS container |

> **Important:**
>
> On UEFI systems, the boot partition must be an
> **EFI System Partition (ESP)**.
>
>  A size of **512 MiB** is recommended.

#### Create Partitions

Use `parted(8)` to partition the disk:

```sh
# as root
parted -s /dev/sda <<'EOF'
mklabel gpt
mkpart ESP fat32 1MiB 513MiB
set 1 boot on
name 1 efiboot
mkpart primary 513MiB 100%
name 2 luks
quit
EOF
```

Encrypt `/dev/sda2` with LUKS and map it:

```sh
# as root
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 crypt
```

#### Create LVM Inside LUKS

Create a physical volume and volume group (e.g., `zpln`):

```sh
# as root
pvcreate /dev/mapper/crypt
vgcreate zpln /dev/mapper/crypt
```

Logical volume layout:

| Volume name | Filesystem | Size            | Description     |
| ----------- | ---------- | :-------------- | :-------------- |
| swap        | none       | 2 x RAM         | swap area       |
| root        | ext4       | remaining space | root filesystem |

Check RAM size with `# free -m`.
For example, if you have 4 GiB RAM, a swap of 8 GiB (2 x RAM) is
recommended.

Create the logical volumes:

```sh
# as root
lvcreate -L 8G -n swap zpln
lvcreate -l 100%FREE -n root zpln
```

#### Create Filesystems and Swap

Format partitions and volumes:

```sh
# as root
mkfs.vfat -F32 /dev/sda1
mkfs.ext4 /dev/zpln/root
mkswap /dev/zpln/swap
swapon /dev/zpln/swap
```

#### Mount Partitions

The `/mnt` directory is used as the default mount point in this
handbook.

Mount the root volume:

```sh
# as root
mount /dev/zpln/root /mnt
```

Mount the boot partition:

```sh
# as root
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

## Install Base System

Download, verify, and extract the rootfs tarball to set up your base
system.

### Download Rootfs Tarball

Download the tarball directly into the `/mnt` directory (the default
mount point) to avoid using live media RAM.

The current Zeppe-Lin release is published at  
<https://github.com/zeppe-lin/pkgsrc-core/releases/latest>

Identify the release version (e.g., `vX.Y`), then download the
corresponding rootfs archive and its detached signature:

```sh
# as root
cd /mnt

URL=https://github.com/zeppe-lin/pkgsrc-core/releases/download
VERSION=vX.Y

wget -c ${URL}/${VERSION}/rootfs-${VERSION}-x86_64.tar.xz \
        ${URL}/${VERSION}/rootfs-${VERSION}-x86_64.tar.xz.sig
```

### Verify Downloaded Tarball

The tarball is signed with GPG.
For security, verifying its integrity is highly recommended.

Import the public key:

```sh
# as root
gpg --keyserver keyserver.ubuntu.com --recv-keys 59ec1986fbd902cf
```

Verify the signature:

```sh
# as root
gpg --verify rootfs-${VERSION}-x86_64.tar.xz.sig \
        rootfs-${VERSION}-x86_64.tar.xz
```

### Extract Rootfs Tarball

Once the rootfs tarball is downloaded and verified, extract its
contents using the following command.
Make sure to replace `${VERSION}` with the version you downloaded:

```sh
# as root
tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
        rootfs-${VERSION}-x86_64.tar.xz
```

> **Important:**
>
> It is critical to use all the specified options to ensure proper
> extraction.
> Here's what each option does:
>
> * `--numeric-owner`
>
>   Ensures numeric UIDs and GIDs from the tarball are preserved,
>   avoiding mismatches caused by the UID/GID mappings on the live
>   system.
>
> * `--xattrs --xattrs-include='*'`
>
>   Preserves filesystem extended attributes, which are used for Linux
>   capabilities (e.g., allowing programs like `ping(8)` enhanced
>   privileges without requiring `suid root`).
>
> * `-xpf`
>
>   Extracts (`x`), preserves permissions and ownership (`p`), and
>   uses the specified file (`f`).

## Chroot Into Base System

> **Important:**
>
> Copy the DNS configuration to ensure network access inside the
> chroot, which is needed for updates and installing software:
>
> ```sh
> # as root
> cp /etc/resolv.conf /mnt/etc/resolv.conf
> ```

Mount necessary pseudo-filesystems:

```sh
# as root
mount -B /dev /mnt/dev
mount -B /tmp /mnt/tmp
mount -B /run /mnt/run
mount -t proc proc /mnt/proc
mount -t sysfs none /mnt/sys
mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 devpts \
        /mnt/dev/pts
```

**For UEFI systems**, mount EFI variables:

```sh
# as root
mount -B /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars
```

Enter the chroot:

```sh
# as root
chroot /mnt /bin/bash
```

Set the `SHELL` variable to `/bin/bash` to ensure tools like `vim`
work properly:

```sh
# chrooted, as root
export SHELL=/bin/bash
```

## Configure Base System

Set the root password:

```sh
# chrooted, as root
passwd root
```

Ensure proper ownership and permissions:

```sh
# chrooted, as root
chown root:root /
chmod 755 /
```

Generate necessary locales (e.g., `en_US`):

```sh
# chrooted, as root
localedef -i en_US -f UTF-8 en_US.UTF-8
```

Set the system default locale by adding it to `/etc/profile`:

```sh
export LANG=en_US.UTF-8
```

See [Generating Locales](#generating-locales) for details.

Edit `/etc/fstab` to configure filesystems (see `fstab(5)`).
Example for [UEFI and LVM on LUKS](#uefi-and-lvm-on-luks):

```fstab
/dev/zpln/root  /      ext4  defaults,noatime,nodiratime  1 2
/dev/sda1       /boot  vfat  defaults,noatime,nodiratime  1 2
/dev/zpln/swap  swap   swap  defaults                     0 0
```

> **Note:**
>
> Use `UUID=...` or `/dev/disk/by-uuid/*` instead of `/dev/*` for
> better reliability on multi-disk systems.
> Find UUIDs with:
> ```sh
> # as root
> blkid -o value -s UUID <DEVICE>
> ```

Edit `/etc/rc.conf` (see `rc.conf(5)`) to configure system settings
like console font, keyboard, timezone, hostname, and services.

Configure network settings in `/etc/rc.d/net`, `/etc/hosts`, and
`/etc/resolv.conf` (see [Networking](#networking)).

### Mount Additional Filesystems

Before building and installing additional software, mount additional
pseudo-filesystems.

Shared memory (needed by some builds, e.g., `python3`):

```sh
# chrooted, as root
mount /dev/shm
```

Optional package build directory (RAM builds):

```sh
# chrooted, as root
mount /var/cache/pkgmk/work
```

> **Important:**
>
> Mount `/var/cache/pkgmk/work` only if enabled in `/etc/fstab` and
> you have enough RAM.

### Configure Users and Privileges

Add a regular user (set a specific UID now if needed):

```sh
# chrooted, as root
useradd --shell /bin/bash \
        --create-home  \
        --groups audio,video,scanner,cdrom,input,users \
        --uid 1000 \
        --user-group <USERNAME>
```

Set the password:

```sh
# chrooted, as root
passwd <USERNAME>
```

To grant administrative privileges (e.g., as Ubuntu does), first add
the user to the `wheel` group:

```sh
# chrooted, as root
usermod -aG wheel <USERNAME>
```

And second, grant the users in the `wheel` group to be root via
`sudo(8)` by creating the file `/etc/sudoers.d/00_wheel` with the
following content:

```sudoers
%wheel ALL=(ALL:ALL) ALL
```

## Update the Base System

Before building and installing additional packages, it is highly
recommended to update the freshly installed Zeppe-Lin system.

### Prepare Pkgsrc Collections

Packages' sources are organized into
[collections](#collections).

Clone the necessary collections, keeping in mind that each depends on
the previous one:

```sh
# chrooted, as root
cd /usr/src/
URL=https://github.com/zeppe-lin
git clone ${URL}/pkgsrc-core    --branch 1.x
git clone ${URL}/pkgsrc-system  --branch 1.x
git clone ${URL}/pkgsrc-xorg    --branch 1.x
git clone ${URL}/pkgsrc-desktop --branch 1.x
```

> **Important:**
>
> The `1.x` branch applies to all **1.** releases (1.0, 1.1, 1.2, ...).
> When a new major line appears, switch to its branch (e.g., `2.x`).
> Verify your release against the
> [current release](index.html#current-release) or the
> [pkgsrc-core releases page](https://github.com/zeppe-lin/pkgsrc-core/releases/latest).

Enable the cloned collections in `/etc/pkgman.conf`.
By default, only `pkgsrc-core` collection is enabled.

### Perform the System Update

Perform a full system update with dependency handling and sorting, and
stop if the installation of at least one package fails:

```sh
# chrooted, as root
pkgman sysup --deps --depsort --group
```

Merge any rejected files during update:

```sh
# chrooted, as root
rejmerge
```

Check for broken packages and rebuild as needed:

```sh
# chrooted, as root
pkgman update -fr --depsort $(revdep)
```

Here, `revdep(1)` identifies packages with broken dependencies, and if
any are reported, `pkgman update -fr` rebuilds the affected packages.

## Install Essential Packages

Install packages required for a minimal, functional workstation:

```sh
# chrooted, as root
pkgman install --deps --group \
        cryptsetup e2fsprogs dosfstools grub2 grub2-efi iw gnupg \
        lvm2 pinentry wireless-tools wpa-supplicant dhcpcd iputils
```

This is a generic setup; users can add any additional packages they
require based on their specific needs.

> **Note:**
>
> For network setup and configuration details, see
> [Networking](#networking).
>
> If you set up a networking bridge, specify the bridge interface in
> the `/etc/rc.d/dhcpcd` and/or `/etc/rc.d/wpa_supplicant`.

## Kernel Setup

Two methods are available: build and install a package or compile
manually.

### Kernel Package

Build and install the packaged Linux kernel:

```sh
# chrooted, as root
pkgman install --deps --group --config-append="runscripts no" linux
```

The `linux` package includes a `post-install` script that runs
`mkinitramfs(8)` and updates the GRUB config.
This script is disabled here through `--config-append="runscripts no"`
to run manually later.

> **Important:**
>
> When you update the `linux` package through the package manager, the
> old kernel and its modules are removed as part of the update
> process.
> This can cause issues if the system is still using the old kernel
> while the new one is being installed.
> To avoid these problems, it is recommended to **lock** the `linux`
> package from automatic updates and handle kernel updates separately
> using `pkgman-update(8)`.
> See `pkgman-lock(8)` for details.

If you installed the kernel using this method, proceed to
[Kernel Firmware](#kernel-firmware) if your system requires
additional firmware, or [Initramfs](#initramfs) otherwise.

### Manual Kernel Compilation

This method suits those wanting a minimal kernel or needing sources
for driver building (e.g., Nvidia, VirtualBox).

> **Important:**
>
> Use the kernel version from Zeppe-Lin's package sources for best
> compatibility.
> Other versions might cause issues.

Download sources:

```sh
# chrooted, as root
pkgman install -do linux
KV=$(pkgman printf %v --filter=linux)
tar -xvf /var/cache/pkgmk/sources/linux-${KV}.tar.?z -C /usr/src/
```

Apply Zeppe-Lin patches:

```sh
# chrooted, as root
cd /usr/src/linux-${KV}
for p in $(pkgman path linux)/*.patch; do
        [ -f "$p" ] && patch -Np1 -i "$p"
done
```

vs

> **Important:**
>
> It is highly recommended to perform a dry run to check for errors
> before applying.
> To do this, simply add `--dry-run` option to the `patch(1)` command
> within the loop shown above.

Configure kernel (choose one of the following):

- **Custom Configuration**:

  Run the menu-based kernel configurator to manually select kernel
  features:

  ```sh
  # chrooted, as root
  make menuconfig
  ```

- **Use Package Defaults**:

  Apply the default configuration from the package:

  ```sh
  # chrooted, as root
  cp $(pkgman path linux)/x86_64-dotconfig .config
  make olddefconfig
  ```

  Build and install:

  ```sh
  # chrooted, as root
  make -j$(nproc) all
  cp arch/x86/boot/bzImage /boot/vmlinuz-${KV}
  cp .config /boot/config-${KV}
  make modules_install
  ```

Next steps:

* Firmware needed? Proceed to [Kernel Firmware](#kernel-firmware).
* No firmware needed? Go to [Initramfs](#initramfs).

## Kernel Firmware

Some hardware (like certain Wi-Fi or graphics cards) needs extra
firmware.

Install non-free firmware if required:

```sh
# chrooted, as root
pkgman install --deps --group linux-firmware
```

Skip this if you prefer a completely free software system.

## Initramfs

First, install `mkinitramfs`:

```sh
# chrooted, as root
pkgman install --deps --group mkinitramfs
```

The `/etc/mkinitramfs/config` file controls how `mkinitramfs(8)`
builds the initial ramdisk image used at boot.
It controls which modules, hooks, and settings are included in the
initramfs image.

Here's an example for [UEFI and LVM on LUKS](#uefi-and-lvm-on-luks):

```sh
# /etc/mkinitramfs/config
hostonly=1 # optional, creates smaller initramfs
compress="gzip --fast"
hooks="eudev luks lvm resume"
root=/dev/zpln/root
root_type=ext4
resume=/dev/zpln/swap
luks_name=crypt
luks_root=/dev/sda2
# End of file.
```

See `mkinitramfs.config(5)` for more information.

> **Important:**
>
> The `hostonly=1` setting creates a smaller initramfs with only
> necessary modules.
> If you move the drive to different hardware later, it might not
> boot.

> **Note:**
>
> For multi-disk systems, using `UUID=...` or
> `/dev/disk/by-uuid/*` instead of `/dev/*` in the config can prevent
> boot issues.
> Find UUIDs with:
>
> ```sh
> # as root
> blkid -o value -s UUID <DEVICE>
> ```

Now, prepare an initramfs.
If you installed the Linux kernel manually, you have already set `KV`
variable to kernel version.
Otherwise, fetch the kernel version from the package source:

```sh
# chrooted, as root
KV=$(pkgman printf %v --filter=linux)
```

Finally, generate the initramfs image:

```sh
# chrooted, as root
mkinitramfs -o /boot/initramfs-${KV}.img -k ${KV}
```

## Bootloader

This section covers installing GRUB2 as your bootloader.
Support for other bootloaders may be added later.

### GRUB2

Create `/etc/default/grub` with:

```sh
# Set the delay before booting:
GRUB_TIMEOUT=3

# Show ZPLN in the GRUB menu:
GRUB_DISTRIBUTOR=ZPLN

# Set kernel parameters (quiet boot, swap for hibernation):
GRUB_CMDLINE_LINUX_DEFAULT="quiet resume=/dev/zpln/swap"
```

> **Important:**
>
> For better reliability on multi-disk systems, use `UUID=...` instead
> of `/dev/*` for the resume partition.
>
> Find the UUID with:
>
> ```sh
> # as root
> blkid -o value -s UUID <DEVICE>
> ```

Next, install GRUB2 on your target drive.
Example device: `/dev/sda`.
Replace with your actual device (e.g., `/dev/sdb`, `/dev/nvme0n1`).

**For UEFI**, ensure the EFI System Partition (ESP) is mounted at
`/boot/efi` inside the chroot.
Then install GRUB with EFI support:

```sh
# chrooted, as root
grub-install --target=x86_64-efi --efi-directory=/boot /dev/sda
```

**For legacy BIOS booting**, install GRUB directly to the disk's MBR:

```sh
# chrooted, as root
grub-install --target=i386-pc /dev/sda
```

Finally, generate the GRUB2 configuration file based on
`/etc/default/grub` and detected kernels:

```sh
# chrooted, as root
grub-mkconfig -o /boot/grub/grub.cfg
```

## Post-installation Tasks

### Install Xorg and Drivers

To find video and input drivers, run:

```sh
# chrooted, as root
pkgman search -vv xf86-
```

Common video drivers include `xorg-xf86-video-intel` (Intel),
`xorg-xf86-video-amdgpu`/`xorg-xf86-video-ati` (AMD), and
`xorg-xf86-video-nouveau` (NVIDIA).
For NVIDIA, the `nouveau-firmware` is also recommended.

For input, modern drivers like `xorg-xf86-input-libinput` and
`xorg-xf86-input-evdev` are recommended.
Legacy options like `xorg-xf86-input-keyboard` and
`xorg-xf86-input-mouse` are also available.

After selecting drivers for your hardware, install `xorg` meta-package
and additional drivers with:

```sh
# chrooted, as root
pkgman install --deps --group xorg [DRIVERS]
```

Replace `[DRIVERS]` with the ones matching your system.

### Install a Window Manager

Zeppe-Lin focuses on lightweight and efficient window managers rather
than complex desktop environments like GNOME or KDE.
This approach avoids unnecessary dependencies and simplifies
configuration.

Zeppe-Lin provides package sources for several window managers, but
users are welcome to choose and contribute package sources for any
window manager they prefer.

#### Ratpoison

Currently, the `pkgsrc-desktop` repository provides the `ratpoison`
window manager.
You can install it with:

```sh
# chrooted, as root
pkgman install --deps --group ratpoison
```

#### Unofficial: Window Maker

For users interested in a retro, intuitive window manager, you can
install **Window Maker** from the unofficial `pkgsrc-wmaker`
repository.

> **Warning:**
>
> Using unofficial repositories means the packages might not follow
> the same update schedule or quality standards as the official
> repositories.
> **Use with caution.**

To install Window Maker, first clone the repository:

```sh
# chrooted, as root
cd /usr/src
URL=https://github.com/zeppe-lin
git clone ${URL}/pkgsrc-wmaker --branch 1.x
```

> **Important:**
>
> The `1.x` branch applies to all **1.** releases (1.0, 1.1, 1.2, ...).
> When a new major line appears, switch to its branch (e.g., `2.x`).
> Verify your release against the
> [current release](index.html#current-release) or the
> [pkgsrc-core releases page](https://github.com/zeppe-lin/pkgsrc-core/releases/latest).

Next, you need to tell `pkgman(1)` about this new repository by adding
the following line to `/etc/pkgman.conf`:

```
pkgsrcdir /usr/src/pkgsrc-wmaker
```

Then, install it with:

```sh
# chrooted, as root
pkgman install --deps --group wmaker
```

Optional meta-packages for Window Maker include `wmaker-dockapps` for
added functionality and `wmaker-themes` for customization.

## Reboot

Exit the chroot:

```sh
# chrooted, as root
exit
```

Unmount all filesystems, and reboot:

```sh
# as root
cd /
umount -R /mnt
shutdown -r now
```

The GRUB menu should appear, allowing you to boot into Zeppe-Lin.

---

# UPGRADING

**WARNING! THIS SECTION IS UNDER DEVELOPMENT AND CANNOT BE USED AS A
MANUAL!**

Upgrading Zeppe-Lin requires careful planning.
This section outlines methods for updating your system.
Follow the steps as presented to ensure a reliable upgrade.

Upgrade methods:

1. Quick binary upgrade (core components).
2. Full update from sources.

Before starting, read the release notes for the target version and
back up important data.

## Release Notes

Read the release notes for the new Zeppe-Lin version.
They contain essential details about new features, removed packages,
and compatibility issues.
The latest release notes you can obtain
[here](https://zeppe-lin.github.io/index.html#latest-release).

## Set Release And Sync

Synchronize your local pkgsrc collections to match the new release
branch.
Replace `1.x` with the specific release you are upgrading to:

```sh
# as root
git -C /usr/src/pkgsrc-core    switch 1.x
git -C /usr/src/pkgsrc-system  switch 1.x
git -C /usr/src/pkgsrc-xorg    switch 1.x
git -C /usr/src/pkgsrc-desktop switch 1.x
```

### Binary Upgrade

Use precompiled binary packages for faster core system upgrades,
especially to avoid build issues during initial updates.

> **Important:**
>
> Upgrades may cause file conflicts, such as a file being reassigned
> between packages.
> To prevent issues, read the release notes for the target Zeppe-Lin
> version.
> They detail package changes like removals, merges, or renames that
> may require manual intervention.

#### Download and Extract binpkgs

> **Note:**
>
> Verify the integrity of the downloaded `binpkgs` tarball before
> extracting it.
> It is signed using the same method as the Zeppe-Lin root filesystem
> image.

Download the tarball and its signature for your upgrade, replacing
`v1.0` with the target version:

```sh
URL=https://github.com/zeppe-lin/pkgsrc-core/releases/download
VERSION=v1.0
wget -c ${URL}/${VERSION}/binpkgs-${VERSION}-x86_64.tar.xz{,.sig}
```

Verify the tarball with `gpg(1)`:

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 59ec1986fbd902cf
gpg --verify binpkgs-${VERSION}-x86_64.tar.xz{.sig,}
```

Extract the tarball after successful verification:

```sh
mkdir -p ~/binpkgs
tar -xf binpkgs-${VERSION}-x86_64.tar.xz -C ~/binpkgs
```

#### Upgrade Core Packages

Navigate to the directory and upgrade core packages:

```sh
cd ~/binpkgs

# as root, upgrade all upgradeable packages
for p in *.pkg.tar.gz; do
    pkgadd -u "$p"
done
```

`pkgadd -u` upgrades each package.
New, non-upgradable packages will return an error, which the loop
skips, ensuring all upgradeable packages are updated.

#### Install New Core Packages

Install new core packages introduced in the release:

```sh
cd ~/binpkgs

# as root, install all new packages
for p in *.pkg.tar.gz; do
    pkgadd "$p"
done
```

`pkgadd` installs each package.
Already installed packages return an error, which the loop skips to
ensure all new packages are installed.

---

# PACKAGE MANAGEMENT

## Introduction

Zeppe-Lin's package management system revolves around packages and
package sources.
Low-level tools handle atomic operations like building and
installation, working with individual package sources or packages as
instructed.
The high-level tool `pkgman` manages the package source collections
and orchestrates these low-level tasks for system-wide software
management.

- **Packages**:
  Compressed archives (e.g., `tar.gz`) containing pre-built software.

- **Package Sources**:
  Files required to create these compressed archives (packages).

To work with packages and package sources, Zeppe-Lin provides:

- Low-level tools:

  - `pkgutils`: Installs or upgrades, removes, and inspects packages.
  - `rejmerge`: Assist with upgrade conflicts.
  - `pkgmk`: Building packages from sources.

  Packages built with `pkgmk` are installed or upgraded using
  `pkgutils`, and files rejected during upgrades are resolved with
  `rejmerge`.

- High-level tool:

  - `pkgman`: Orchestrates package sources, dependencies, and system
    updates, integrating `pkgutils` and `pkgmk`.

## What is a Package?

A Zeppe-Lin package is a compressed archive (e.g., `tar.gz`) that
contains only the software files.
It avoids any kind of embedded metadata, ensuring simplicity and
transparency in its structure.

### Package Naming

Zeppe-Lin packages follow a clear naming convention:

```
name#version-release.pkg.tar.gz
```

Components:

- `name`    -- Package name.
- `version` -- Version number.
- `release` -- Build revision.

Example:

```
ed#1.21-1.pkg.tar.gz
```

The extension `.pkg.tar.gz` denotes a Zeppe-Lin package.
Other common compression formats like `tar.bz2`, `tar.xz`, and
`tar.zst` are also supported.

### Package Database

The package database, located at `/var/lib/pkg/db`, tracks installed
packages and their contents.
Each package entry follows this format:

```sh
<name>                 # Package name
<version>-<release>    # Version and release
<dir>/                 # Top-level directory
<dir>/<subdir>         # Subdirectory
<dir>/<subdir>/<file>  # File within subdirectory
(Blank line)           # Separates package entries
```

Example entry for `ed`:

```sh
ed
1.21-1
bin/
bin/ed
usr/
usr/share/
usr/share/man/
usr/share/man/man1/
usr/share/man/man1/ed.1.gz
(Blank line)
```

> **Note:**
>
> This database enables essential operations like installation
> (`pkgadd(8)`), removal (`pkgrm(8)`), and inspection (`pkginfo(8)`).

## Low-level Tools: pkgutils

`pkgutils` provides the core utilities to handle packages:

- `pkgadd(8)`: Installs or upgrades packages.
- `pkgrm(8)`: Removes packages.
- `pkginfo(1)`: Displays package details.

### Using pkgutils

#### Installing a Package

Install a package file with `pkgadd(8)`:

```sh
# as root
pkgadd bash#5.0.18-1.pkg.tar.gz
```

By default, `pkgadd(8)` prevents overwriting existing files.
Use `-f` or `--force` to override this behavior (**use with caution!**):

```sh
# as root
pkgadd -f bash#5.0.18-1.pkg.tar.gz
```

#### Upgrading a Package

Upgrade a package with the `-u` or `--upgrade` option:

```sh
# as root
pkgadd -u bash#5.0.18-1.pkg.tar.gz
```

This replaces the installed package.
If the package is not installed, it will return an error.
You can even "upgrade" to an older version.

Files that should not be upgraded (based on `/etc/pkgadd.conf`) are
placed in `/var/lib/pkg/rejected/`.

#### Removing a Package

To remove a package, use `pkgrm(8)` followed by the package name:

```sh
# as root
pkgrm bash
```

> **Caution:**
>
> This command removes all files owned by the package, without
> prompting.
> Misspelling the package name may remove something entirely different
> (e.g., `glib` vs. `glibc`).

#### Inspecting Packages

Use `pkginfo(1)` to get information about packages.

List installed packages and versions:

```sh
pkginfo -i
```

List files in a package:

```sh
pkginfo -l bash
```

List files in a package archive (before installing):

```sh
pkginfo -l grep#2.5-1.pkg.tar.gz
```

Find which package owns a file:

```sh
pkginfo -o /usr/bin/ls
```

See `pkgadd(8)`, `pkgrm(8)`, and `pkginfo(1)` for details.

### Configuring pkgadd

You can customize `pkgadd(8)` behavior during package upgrades using
`/etc/pkgadd.conf`.
Rules define whether files should be upgraded or preserved.

#### Rule Format

Each rule in `/etc/pkgadd.conf` follows this format:

```
EVENT   PATTERN   ACTION
```

- `EVENT`: Currently, only `UPGRADE` is supported.
- `PATTERN`: A regular expression matching filenames in the package.
- `ACTION`: `YES` to upgrade files, `NO` to preserve them.

Rules are processed sequentially, with the last matching rule taking
priority.

#### Example

Example `/etc/pkgadd.conf` entries:

```
UPGRADE   ^etc/.*$              NO
UPGRADE   ^var/log/.*$          NO
UPGRADE   ^etc/X11/xorg.conf$   YES
```

These rules will:

- Keep all files in `/etc` and its subdirectories.
- Keep all files in `/var/log` and its subdirectories.
- Upgrade `/etc/X11/xorg.conf` specifically (overrides the `/etc` rule).


> **Caution**:
>
> Patterns match filenames inside the package, not full system paths.
> Do not use **`/`** at the start!

See `pkgadd.conf(5)` for details.

## Low-level Tools: rejmerge

`rejmerge(8)` resolves files rejected during upgrades using `pkgadd -u`.
Rejected files are moved to `/var/lib/pkg/rejected/` for manual
handling, while `rejmerge(8)` provides a way to manage these files
semi-automatically.

### Using rejmerge

If files are present in `/var/lib/pkg/rejected`, `rejmerge(8)` prompts
you to decide their fate.
For each file, you can choose:

```
=======> file
(diff output between installed file and rejected file)
[K]eep [U]pgrade [M]erge [D]iff [S]kip
```

Legend:

- `[K]eep`: Retain the current file as it is.
- `[U]pgrade`: Replace the current file with the new version.
- `[M]erge`: Combine changes from the current and new versions.
- `[D]iff`: Display differences between the current and new versions.
- `[S]kip`: Defer the decision and revisit it later.

See `rejmerge(8)` for details.

### Configuring rejmerge

Configurations for `rejmerge(8)` can be adjusted in
`/etc/rejmerge.conf`.
Key settings:

- `rejmerge_diff`: Defines how differences are displayed.
- `rejmerge_merge`: Controls how files are merged.
- `EDITOR`: Specifies the editor for merges.
- `PAGER`: Specifies the pager for differences.

#### Example

Use unified, colorized output for differences:

```sh
rejmerge_diff() { diff -u --color=always $1 $2 > $3 ; }
```

Use `sdiff(1)` for merging files:

```sh
rejmerge_merge() { sdiff -o $3 $1 $2 ; }
```

See `rejmerge.conf(5)` for more details.

## Low-level Tools: pkgmk

`pkgmk(8)` builds Zeppe-Lin packages (compressed archives) from source
files using a `Pkgfile`.
These files, along with the supporting directory, form a
**Package Source** -- a self-contained unit that includes all files
needed to build and install software.

A **Package Source** typically contains:

- `Pkgfile`: Defines metadata and build steps.
- `.md5sum`: Ensures the integrity of downloaded files.
- `.footprint`: Lists expected files in the final package.

A **Package Source** is the basic unit of software organization in
Zeppe-Lin.
While this section introduces **Package Sources** in the context of
building packages,
[PACKAGE SOURCES AND COLLECTIONS](#package-sources-and-collections)
explores their organization into **Collections** and **Repositories**
for broader software management workflows.

### Pkgfile Format

The `Pkgfile` defines:

- `name`, `version`, `release`: Package identity.
- `source`: URL to download the software's source code.
- `build()`: Instructions to compile and package the software.

#### Example

```sh
name=hello
version=2.12.1
release=1
source=https://ftp.gnu.org/gnu/hello/$name-$version.tar.gz

build() {
    cd $name-$version
    ./configure --prefix=/usr --disable-nls
    make
    make DESTDIR=$PKG install
    rm -rf $PKG/usr/info
}
```

See `pkgmk.Pkgfile(5)` for details.

### Using pkgmk

#### Building a Package

To build a package, create a directory named after the package, `cd`
into this directory, place the `Pkgfile` inside, and run:

```sh
fakeroot pkgmk -d -cf /dev/null
```

- `fakeroot`: Always use to avoid system risks.
- `-d`: Downloads missing source files.
- `-cf /dev/null`: Ignores `/etc/pkgmk.conf` and uses defaults.

On the first build, `pkgmk(8)` generates:

- `.footprint`: Tracks package contents.
- `.md5sum`: Ensures source files integrity.

The final package (e.g., `hello#2.12.1-1.pkg.tar.gz`) will be in the
current directory.

### Configuring pkgmk

Customize `pkgmk(8)` with `/etc/pkgmk.conf`.  Key settings:

- `CFLAGS`, `CXXFLAGS`: Compiler optimization flags.
- `PKGMK_SOURCE_MIRRORS`: Backup URLs for source archives.
- `PKGMK_SOURCE_DIR`: Directory for source archives.
- `PKGMK_PACKAGE_DIR`: Directory for built packages.
- `PKGMK_WORK_DIR`: Temporary build directory.

#### Example

Define backup URLs:

```sh
PKGMK_SOURCE_MIRRORS="http://fileserver.intranet/sources/
                      http://mirror2/sources/"
```

Set a unique work directory:

```sh
PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name-$$"
```

Using `$name` (package name) and `$$` (process ID) avoids conflicts
during simultaneous builds.

> **Note:**
>
> Although unique directories avoid build conflicts, `pkgadd(8)` locks
> the database, so simultaneous installations may fail.

See `pkgmk.conf(5)` for full options.

## High-level Tool: pkgman

`pkgman(1)` serves as a versatile interface for managing Zeppe-Lin's
package ecosystem.
Building on tools like `pkgutils` and `pkgmk`, it unifies and
simplifies workflows while supporting a wide range of package
management tasks.

`pkgman(1)` empowers users to:

- Handle dependencies and system updates efficiently.
- Automate and streamline build processes.
- Extend functionality with dynamic features and workflows.

With its adaptable design, `pkgman(1)` integrates seamlessly into
diverse system management scenarios, making it an indispensable tool
for maintaining and customizing Zeppe-Lin.

### Using pkgman

#### List Installed Packages

List installed packages:

```sh
pkgman list
```

Include versions:

```sh
pkgman list -v
```

Include versions and descriptions:

```sh
pkgman list -vv
```

#### Query Package Information

Display detailed package information:

```sh
pkgman info acl
```

Example output:

```
Name:         acl
Path:         /usr/src/pkgsrc-core
Version:      2.3.1
Release:      1
Description:  Access Control List filesystem support
URL:          http://savannah.nongnu.org/projects/acl
Dependencies: attr
```

#### Search Package Sources

Search by name:

```sh
pkgman search -vv glibc
```

Search using regular expressions:

```sh
pkgman search -vv --regex '^(glib)c?$'
```

Search by description:

```sh
pkgman dsearch -vv archive
```

#### 4.6.1.4. Query Dependencies

Show direct dependencies:

```sh
pkgman dep vim
```

Show recursive dependencies:

```sh
pkgman dep vim --recursive
```

Show detailed dependency tree:

```sh
pkgman dep vim --recursive --tree
```

#### 4.6.1.5. Build and Install Packages

Build and install a package with dependencies (recommended):

```sh
# as root
pkgman install --deps --group xterm
```

Use `--group` to stop installation if a dependency fails.
Retry failed installations:

```sh
# as root
pkgman install --deps --group --force xterm
```

`--force` skips already installed packages during the retry.

#### 4.6.1.6. Update Installed Packages

Identify outdated packages:

```sh
pkgman diff --deps --full
```

Update a single package:

```sh
# as root
pkgman update --deps --group bind
```

Upgrade all packages in the system:

```sh
# as root
pkgman sysup --deps --depsort --group
```

### Configuring pkgman

`pkgman(1)` is configured via `/etc/pkgman.conf`.  Key settings:

- `pkgsrcdir`:
  Defines directories for package source collections (you can list
  multiple).
  The `pkgsrc-core` collection is enabled by default.
  See [Collections](#collections) for additional collections.

  Details about `pkgsrcdir` and how it is used to configure
  **Collections** and **Repositories** are explored in next chapter:
  [PACKAGE SOURCES AND COLLECTIONS](#package-sources-and-collections).

- `runscripts`:
  Enables `pre-install`, `post-install`, `pre-remove`, and
  `post-remove` scripts during operations.
  **Enable this option.**

- `logfile`:
  Specifies the log file for `pkgman(8)` operations.

See `pkgman.conf(5)` for more details.

## The Essentials (outro)

This chapter introduced Zeppe-Lin's tools for managing individual
packages and basic system updates.

In the next chapter, **Collections** of **Package Sources** are
introduced --- a modular approach to organizing and managing
software --- with `pkgman` serving as the central orchestration tool.

---

# PACKAGE SOURCES AND COLLECTIONS

## Introduction

Zeppe-Lin organizes software sources into three key components:

- **Package Sources**:
  Self-contained directories that include all files and instructions
  needed to build and install software.
  These are the foundation of Zeppe-Lin's software management.

- **Collections**:
  Logical groupings of **Package Sources**, organized by purpose
  (e.g., core, system tools, desktop applications).
  **Collections** simplify software organization and provide
  modularity.

- **Repositories**:
  Distributed storage systems that host one or more **Collections**.
  **Repositories** enable versioning, collaboration, and
  synchronization across systems.

These components provide a structured approach to building, managing,
and distributing software on Zeppe-Lin.
Tools like `pkgmk(8)` and `pkgman(1)` are used to interact with these
components, supporting workflows such as dependency management,
package building, and system updates.

## Organizing Package Sources

### Package Source: The Core Unit

In Zeppe-Lin, a **Package Source** is the fundamental unit for
building software.
Each one represents a single application, library, or utility,
organized as a directory with all the necessary files to build and
install the software.

Essential files include:

- `Pkgfile`:
  The main build script.
  It defines the package's metadata (name, version, dependencies) and
  includes the steps for downloading, compiling, and packaging the
  software using `pkgmk(8)`.

  See `pkgmk.Pkgfile(5)` for details.

- `.md5sum`:
  This file contains checksums for verifying the integrity of
  downloaded source files.
  It ensures that the files have not been altered or corrupted during
  transfer.

  See `pkgmk.md5sum(5)` for details.

- `.footprint`:
  Used for build verification, it lists the files expected in the
  final package.
  This helps maintain consistency in builds.

  See `pkgmk.footprint(5)` for details.

Some **Package Sources** may include additional files to support
custom builds or configurations:

- `.32bit`:
  Flag file to trigger 32-bit build mode in `pkgmk(8)`.

  See `pkgmk.32bit(5)` for details.

- `.nostrip`:
  Exceptions for stripping executable binaries and libraries.

  See `pkgmk.nostrip(5)` for details.

- Patch files (`*.patch`):
  Modify the source code before building.

- Configuration files for scheduled tasks (`cron.*`):
  Useful for automating processes.

- Scripts for managing services (`rc.*`):
  Enable or disable services automatically.

  See `rc.d(7)` for details.

- PAM configuration files (`pam.*`):
  Handle user authentication.

Together, these files create a self-contained environment for building
and managing software.

### Collections

**Collections** are logical groupings of **Package Sources**.
A **Collection** is simply a directory containing multiple
**Package Sources** with a shared purpose, like system utilities or
desktop applications.

Example **Collection** structure:

```
Collection (e.g., pkgsrc-core)
|
|-- acl/ (Package Source)
|   |-- Pkgfile
|   |-- .md5sum
|   `-- .footprint
|
|-- bash/ (Package Source)
|   |-- Pkgfile
|   |-- .md5sum
|   `-- .footprint
|
`-- ... (more Package Sources)
```

This logical organization enables modular software management.
Instead of dealing with individual packages in isolation,
**Collections** provide a structured approach to grouping and managing
related sets of software.

Common **Collections** in Zeppe-Lin:

- `pkgsrc-core`: Core packages for a minimal system.
- `pkgsrc-system`: Utilities and system-specific tools.
- `pkgsrc-xorg`: X Window System and related tools.
- `pkgsrc-desktop`: Desktop applications.

These **Collections** form the foundation of Zeppe-Lin's software
ecosystem, allowing users to selectively enable the software they
need.

### Repositories: Distributing and Versioning Collections

**Collections** are organized into **Repositories**, hosted on systems
like Git.
It's important to note that while a repository **can** contain
multiple collections, Zeppe-Lin's official repositories adopt a
strategy where each repository primarily focuses on a single
collection.
This design choice is driven by the benefits of allowing users to
selectively clone only the collections they need.
**Repositories** provide:

- **Versioning**: Branches manage package sources for specific
  Zeppe-Lin releases (e.g., `1.x`, `2.x`), ensuring compatibility.

- **Distribution**: Users can clone repositories to access collections
  and package sources.

The official Zeppe-Lin repositories, following this
one-collection-per-repository approach, include:

- `pkgsrc-core.git`: Core packages for a minimal system.
- `pkgsrc-system.git`: Utilities and system-specific tools.
- `pkgsrc-xorg.git`: X Window System and related tools.
- `pkgsrc-desktop.git`: Desktop applications.

**Repositories** ensure that collections are both modular and
manageable, allowing users to selectively clone only the collections
they need.

## Managing Package Sources

### Setting Up Collections

To access software for installation in Zeppe-Lin, download the
official package source collections and enable them for `pkgman(1)`.

#### Syncing Official Repositories

Clone the repositories from the Zeppe-Lin GitHub account:

```sh
# as root
cd /usr/src/
URL=https://github.com/zeppe-lin
git clone ${URL}/pkgsrc-core    --branch 1.x
git clone ${URL}/pkgsrc-system  --branch 1.x
git clone ${URL}/pkgsrc-xorg    --branch 1.x
git clone ${URL}/pkgsrc-desktop --branch 1.x
```

> **Important:**
>
> The `1.x` branch applies to all **1.** releases (1.0, 1.1, 1.2, ...).
> When a new major line appears, switch to its branch (e.g., `2.x`).
> Verify your release against the
> [current release](index.html#current-release) or the
> [pkgsrc-core releases page](https://github.com/zeppe-lin/pkgsrc-core/releases/latest).

#### Enabling Collections in pkgman.conf

Edit `/etc/pkgman.conf` to enable package sources collections.
For example:

```
pkgsrcdir /usr/src/pkgsrc-core
pkgsrcdir /usr/src/pkgsrc-system
pkgsrcdir /usr/src/pkgsrc-xorg
pkgsrcdir /usr/src/pkgsrc-desktop
```

For detailed configuration options, see `pkgman.conf(5)`.

#### Verify Your Setup

Confirm that `pkgman(1)` recognizes the collections:

```sh
pkgman list --all
```

This lists all package sources from enabled collections.

### Exploring and Installing Packages

With collections enabled, you can explore and install packages using
`pkgman(1)`.

#### Listing Available Packages

List all package sources:

```sh
pkgman list --all
```

Example output:

```
-- list ([i] = installed)
[i] acl
[i] bash
[ ] vim
[ ] zathura
...
```

Legend:

- `[i]`: The package is already installed.
- `[ ]`: The package is available but not installed.

To display the full path of each package source (helpful for
identifying which collection a package belongs to), use the `--path`
option:

```sh
pkgman list --all --path
```

Example output:

```
[i] /usr/src/pkgsrc-core/acl
[ ] /usr/src/pkgsrc-system/vim
```

#### Searching for Packages

If you're looking for specific software, use the `search` command.
For example, to search for packages related to `alsa`:

```
$ pkgman search alsa
-- search ([i] = installed)
[ ] alsa-lib
[ ] alsa-ucm-conf
[i] alsa-utils
```

The output indicates which packages are installed and available.

For a detailed search that includes versions, descriptions, and
collection paths, add the `-vv` and `--path` options:

```
$ pkgman search -vv --path alsa
-- search ([i] = installed)
[ ] /usr/src/pkgsrc-system/alsa-lib 1.2.15.1-1: ALSA libraries
[ ] /usr/src/pkgsrc-system/alsa-ucm-conf 1.2.15.1-1: ALSA Use Case Manager configuration
[i] /usr/src/pkgsrc-system/alsa-utils 1.2.15.1-1: Utilities for the ALSA
```

#### Building and Installing Packages

Build and install a package with dependencies:

```sh
# as root
pkgman install --deps --group <package_name>
```

Example:

```sh
# as root
pkgman install --deps --group vim
```

Build and install multiple packages:

```sh
# as root
pkgman install --deps --group vim zathura
```

For verbose output (show building process on stdout):

```sh
# as root
pkgman install -vv --deps --group vim zathura
```

Dry run:

```sh
# as root
pkgman install -vv --test --deps --group vim zathura
```

> **Tip:**
>
> Use `pkgman search` to locate package names.

Run `pkgman install --help` or see `pkgman-install(8)` for information
about all installation options.

### Keeping Your System Up-to-Date

Maintaining your Zeppe-Lin system involves two primary tasks:

1. Sync your **Repositories** regularly to stay up-to-date.
2. Updating installed packages to their latest versions.

#### Synchronizing Local Collections

Regularly sync local collections with remote repositories using
`git pull`:

```sh
# as root
git -C /usr/src/pkgsrc-core     pull
git -C /usr/src/pkgsrc-system   pull
git -C /usr/src/pkgsrc-xorg     pull
git -C /usr/src/pkgsrc-desktop  pull
```

Include unofficial collections if applicable.

Automate Syncing: Set up a cron job with `crond(8)`:

```crontab
# Weekly sync at 3:00 AM on Sundays
0 3 * * 0 run-one git -C /usr/src/pkgsrc-core    pull -q
0 3 * * 0 run-one git -C /usr/src/pkgsrc-system  pull -q
0 3 * * 0 run-one git -C /usr/src/pkgsrc-xorg    pull -q
0 3 * * 0 run-one git -C /usr/src/pkgsrc-desktop pull -q
```

> **Important:**
>
> Ensure `run-one` package from `pkgsrc-core` collection is installed.

#### Checking for Package Updates

Once the local collections are synced, identify outdated packages with
`pkgman diff`:

```sh
pkgman diff --deps --full
```

Example output:

```
-- Differences between installed packages and packages sources tree
Package         Installed      Available
feh             3.7.2-1        3.7.2-2
screen          4.9.0-1        5.0.0-1
...

-- Packages not found in the packages sources tree
Package         Installed      Required by
libncurses      6.2-1          vim
```

Review this output to determine which packages need updates.
Packages in the "not found" section may have been removed from the
collection or installed manually from other sources.

#### Updating Packages

To upgrade the system, start by downloading all required source files.
This ensures the upgrade won't be interrupted by missing files.

```sh
# as root
pkgman sysup -do
```

Once the sources are downloaded, upgrade the packages with proper
dependency handling and ordering:

```sh
# as root
pkgman sysup --deps --depsort --group
```

Options explained:

- `--deps`  
  Include all dependencies of the packages in the update process.

- `--depsort`  
  Sort packages by dependency order before updating.

- `--group`  
  Update all packages in order, stopping immediately if the update of
  any package fails.
  Useful for updating dependent packages sequentially.

#### Updating Specific Packages

Update individual packages with `pkgman update`.
For example:

```sh
# as root
pkgman update --deps --depsort --group screen feh
```

This command updates only the specified packages while resolving their
dependencies.

### Advanced Package Management

#### Detecting Broken Dependencies with revdep(1)

`revdep(1)` checks installed packages for missing or incorrect shared
libraries.
Use it to verify system stability and identify packages needing a
rebuild after updates.

Check system-wide for broken libraries:

```sh
revdep
```

Rebuild affected packages:

```sh
# as root
pkgman update -fr $(revdep)
```

Inspect a specific package:

```sh
revdep -p bash
```

Run `revdep` regularly after updates or repository syncs to ensure all
packages remain functional.

See `revdep(1)` and `revdep.d(5)` for more information.

#### Ignoring Packages During Updates

Prevent updates to specific packages during system upgrades with
`--ignore`.
Example:

```sh
# as root
pkgman sysup --deps --depsort --group --ignore=vim,screen
```

Regularly revisit ignored packages to avoid security risks and
dependency conflicts.

#### Locking Packages

Lock a package to prevent upgrades indefinitely:

```sh
# as root
pkgman lock vim
```

Unlock a package to resume updates:

```sh
# as root
pkgman unlock vim
```

Locked packages are useful for maintaining specific software versions
critical to workflows.

See `pkgman-lock(8)`, `pkgman-unlock(8)`, and `pkgman-list-locked(1)`
for more information.

#### Handling Lower Available Versions

Occasionally, a package source may revert to a lower version than the
one installed on your system.
This often happens when maintainers roll back to a stable release
after issues with a newer version.
By default, `pkgman` does not prioritize installed versions over
available ones.

To override this behavior, enable the `preferhigher` option:

```sh
# as root
pkgman --config-set="preferhigher yes" sysup --deps --depsort
```

This ensures `pkgman` retains the higher installed version during
upgrades.
Use this feature cautiously, as higher versions might be less stable
or unsupported.

#### Practical Considerations

- Regularly review ignored and locked packages for security and
  compatibility.

- Avoid using `preferhigher` without understanding the implications of
  using potentially unstable software.

- Check dependency trees carefully to prevent system breakages.

## Extending Software Sources

### Adding a Local Collection

This section explains how to create custom collections.
A local collection allows you to add new packages that are not
available in the official repositories.

#### Creating the Collection Directory

Create your local collection directory in `/usr/src`, alongside
official Zeppe-Lin collections.
Using directories with broader read permissions ensures that
unprivileged users like `pkgmk` can access the collection.

Example:

```sh
# as root
cd /usr/src
mkdir mynewcollection
```

#### Enabling the Collection in pkgman.conf

Add your collection to `/etc/pkgman.conf`.
List it above official collections to give it search priority:

```
pkgsrcdir /usr/src/mynewcollection
pkgsrcdir /usr/src/pkgsrc-core
pkgsrcdir /usr/src/pkgsrc-system
pkgsrcdir /usr/src/pkgsrc-xorg
```

Save the file and proceed to verify the setup.

#### Verifying the Collection Setup

Verify that `pkgman(1)` recognizes your collection:

```sh
pkgman dumpconfig
```

Check the "Packages sources directories" section for your collection:

```
Packages sources directories: <n>
  /usr/src/mynewcollection <-- here
  /usr/src/pkgsrc-core
  /usr/src/pkgsrc-system
  /usr/src/pkgsrc-xorg
  ...
```

If it appears, the setup is complete, and you can start adding package
sources.

### Creating Custom Packages

After setting up your local collection, the next step is to add a
package source.
This involves creating a directory for the package and writing a
`Pkgfile` with build instructions and metadata.

#### Creating the Package Directory

Create a subdirectory for the new package in your local collection.
Ensure the directory name matches the package name in the `Pkgfile`:

    # mkdir /usr/src/mynewcollection/hello
    # cd /usr/src/mynewcollection/hello

> **Important:**
>
> Naming consistency is critical.
> A mismatch between the directory name and `name` in the `Pkgfile`
> cause build error.

#### Writing the Pkgfile

The `Pkgfile` serves two purposes:

1. Provides build instructions for `pkgmk(8)`.
2. Supplies metadata for `pkgman(1)` to enable dependency resolution,
   search, and queries.

Example `Pkgfile`:

```sh
# Description: Example package based on GNU hello
# URL:         https://www.gnu.org/software/hello/
# Depends on:  glibc

name=hello
version=2.12.1
release=1
source=https://ftp.gnu.org/gnu/hello/$name-$version.tar.gz

build() {
        cd $name-$version

        ./configure --prefix=/usr --disable-nls

        make V=1
        make DESTDIR=$PKG install

        rm -rf $PKG/usr/share/info
}
```

#### Key Metadata Headers for pkgman

Include these headers in the `Pkgfile` for optimal integration with
`pkgman(1)`:

- `# Description`  
  Brief summary of the package.

- `# URL`  
  Link to official documentation or website.

- `# Depends on`  
  List of dependencies.
  `pkgman(1)` resolves and installs these automatically.

> **Important:**  
> Without these headers, `pkgman(1)` cannot display metadata or
> resolve dependencies.

#### Verifying the Package Source

Verify your package metadata with:

```
$ pkgman info hello
Name:         hello
Path:         /usr/src/mynewcollection/hello
Version:      2.12.1
Release:      1
Description:  Example package based on GNU hello
URL:          https://www.gnu.org/software/hello/
Depends on:   glibc
```

If metadata is missing, review the `Pkgfile` for errors.

### Building and Installing Custom Packages

After creating a custom package source, the next step is to build and
install the package using `pkgman(1)` and `pkgmk(8)`, addressing any
potential permission issues.

#### Building the Package

Build your custom package with:

```sh
# as root
pkgman install -vv --deps hello
```

This command:

1. Downloads source files if not cached.
2. Builds the package using `pkgmk(8)`.
3. Installs the package with `pkgadd(8)`.

> **Note:**
>
> Warnings about missing `.md5sum` and `.footprint` files like
> `/usr/bin/pkgmk: ... cannot create .md5sum: Permission denied` occur
> because packages are built with the unprivileged `pkgmk` user, which
> has not write permissions in `/usr/src/mynewcollection`.

#### Resolving Permissions for Build Files

There are at least two options to resolve permissions case.

1. **Manually Updating Files.**

   Navigate to the package directory and generate the files:

   ```sh
   # as root
   cd /usr/src/mynewcollection/hello
   pkgmk -um   # Update .md5sum
   pkgmk -uf   # Update .footprint
   ```

2. **Adjusting Permissions.**

   Grant write access to `pkgmk` using `setfacl(1)`:

   ```sh
   # as root
   setfacl -m u:pkgmk:rwx /usr/src/mynewcollection/hello
   ```

   Rebuild the package afterward:

   ```sh
   # as root
   pkgman update -fr hello
   ```

#### Verifying Generated Files

After addressing warnings, confirm the presence of required files:

```
$ ls -l /usr/src/mynewcollection/hello
-rw-r--r--  1 pkgmk pkgmk  251 .footprint
-rw-r--r--  1 pkgmk pkgmk   54 .md5sum
-rw-r--r--  1 root  root   359 Pkgfile
```

#### Verifying the Installation

Ensure the package is installed on your system:

```
$ pkgman isinst hello
package 'hello' is installed
```

Run:

```
$ hello
Hello, world!
```

### Building Packages from Bleeding-Edge Sources

Some packages need to be built directly from version control systems
(VCS) like Git or Subversion, instead of fixed release archives.
This section outlines two approaches: a stable approach and a
bleeding-edge approach.

#### Stable Commit Approach

For production, pinning to a specific commit ensures consistent
builds.
Example:

```sh
# Description: Ratpoison window manager
# URL:         https://www.nongnu.org/ratpoison/
# Depends on:  xorg-server

name=ratpoison
version=1.4.9-db94d49  # Release + commit hash
release=1

# Custom function to fetch or clone git repository
download_git() {
    if [ -d $PKGMK_SOURCE_DIR/$name ]; then
        git -C $PKGMK_SOURCE_DIR/$name fetch --depth=1
        git -C $PKGMK_SOURCE_DIR/$name clean -f
        git -C $PKGMK_SOURCE_DIR/$name reset --hard origin/$2
    else
        git -C $PKGMK_SOURCE_DIR clone --depth=1 $1 -b $2 $name
    fi
    cp -r $PKGMK_SOURCE_DIR/$name $PKGMK_WORK_DIR/src/$name
}

build() {
    download_git https://git.savannah.nongnu.org/git/ratpoison.git master
    cd ratpoison
    git checkout ${version#*-}  # Pin commit 'db94d49'

    ./configure --prefix=/usr
    make V=1
    make DESTDIR=$PKG install
}
```

Pinning builds guarantees stability and shields against upstream
changes.

#### Bleeding-Edge Approach

For testing, dynamically set the version to the current date
(`YYYYMMDD`) to track upstream changes.
Example:

```sh
# Description: Ruby interpreter (bleeding-edge)
# URL:         http://www.ruby-lang.org
# Depends on:  gdbm libgmp openssl zlib libffi libyaml

name=ruby-scm
version=$(date +%Y%m%d)  # Version updates daily to track build date
release=1

download_git() {
    if [ -d $PKGMK_SOURCE_DIR/$name ]; then
        git -C $PKGMK_SOURCE_DIR/$name fetch --depth=1
        git -C $PKGMK_SOURCE_DIR/$name clean -f
        git -C $PKGMK_SOURCE_DIR/$name reset --hard origin/$2
    else
        git -C $PKGMK_SOURCE_DIR clone --depth=1 $1 -b $2 $name
    fi
    cp -r $PKGMK_SOURCE_DIR/$name $PKGMK_WORK_DIR/src/$name
}

build() {
    download_git https://github.com/ruby/ruby master
    cd ruby-scm

    ./configure --prefix=/usr
    make V=1
    make DESTDIR=$PKG install
}
```

**"Daily Updates"**:
If the installed version is outdated, `pkgman(1)` flags it during
`pkgman diff`, prompting updates:

```sh
pkgman diff
```

Expected output:

```
-- Differences between installed packages and packages sources tree
ruby-scm                        20250216-1          20250401-1
```

This approach is ideal for development but unsuitable for production
environments.

#### Subversion Repository Download Function

For Subversion-based builds, use a download function like this:

```sh
download_svn() {
    if [ -d $PKGMK_SOURCE_DIR/$name ]; then
        svn cleanup $PKGMK_SOURCE_DIR/$name
        svn up $PKGMK_SOURCE_DIR/$name
    else
        svn co $1 $PKGMK_SOURCE_DIR/$name
    fi
    cp -r $PKGMK_SOURCE_DIR/$name $PKGMK_WORK_DIR/src/$name
}
```

Example usage in a `Pkgfile`:

```sh
download_svn https://svn.project.org/svn/program/trunk
```

Add `subversion` to dependencies for compatibility.
Unlike `git`, which resides in `pkgsrc-core`, `subversion` requires
explicit declaration.

#### Best Practices

- Use pinned commits or snapshots for stability in production.
- Reserve bleeding-edge builds for testing and development.
- Include download functions (`download_git` or `download_svn`)
  directly in `Pkgfile` for portability.

## Tips and Best Practices

### Renicing Builds

Package builds can reduce system responsiveness due to high CPU and
I/O usage.
Mitigate this by adjusting process priorities using `nice(1)` and
`ionice(1)`:

- `nice(1)`: Lowers CPU priority (higher number = lower priority).
- `ionice(1)`: Adjusts I/O priority (class 2, priority 6 is commonly
  used).

Update the `makecommand` in `/etc/pkgman.conf`:

```
makecommand sudo -H -u pkgmk nice -n10 ionice -c2 -n6 fakeroot pkgmk
```

Explanation:

- `nice -n10`: Reduces CPU priority (10 = relatively low).
- `ionice -c2 -n6`: Reduces I/O priority (class 2, priority 6).

These changes help the build process interfere less with interactive
tasks, improving system responsiveness.

### RAM Builds for Faster Package Compilation

Using RAM for temporary build files (`tmpfs`) can significantly speed
up package compilation in Zeppe-Lin.

#### Enable RAM Builds in Zeppe-Lin

1. Uncomment this line in `/etc/fstab`:

   ```
   pkgmk /var/cache/pkgmk/work tmpfs size=<SIZE>,uid=<UID>,defaults 0 0
   ```

   Replace `SIZE` (e.g., `16G`).
   The `UID` for the `pkgmk` user is preconfigured.

2. Mount `tmpfs`:

   ```sh
   # as root
   mount pkgmk
   ```

3. Remove `-pipe` from `CFLAGS` and `CXXFLAGS` in `/etc/pkgmk.conf`.

#### RAM Build Configuration (Educational)

For users interested in customizing the setup:

1. Creating a dedicated build user:

   ```sh
   # as root
   useradd -b /var/cache/ -m -s /bin/false -U pkgmk
   ```

2. Setting up build directories and assigning ownership:

   ```sh
   # as root
   mkdir -p /var/cache/pkgmk/{sources,packages,work}
   chown -R pkgmk:pkgmk /var/cache/pkgmk/{sources,packages,work}
   ```

3. Configuring `tmpfs` in `/etc/fstab`:

   ```
   pkgmk /var/cache/pkgmk/work tmpfs size=<SIZE>,uid=<UID>,defaults 0 0
   ```

4. Setting the work directory in `/etc/pkgmk.conf`:

   ```sh
   PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name"
   ```

5. Removing `-pipe` from `CFLAGS` and `CXXFLAGS` in `/etc/pkgmk.conf`.

### Unprivileged Builds in Zeppe-Lin

Zeppe-Lin builds packages as an unprivileged user (typically `pkgmk`)
by default.
This secure and modular setup isolates the build process to mitigate
risks.
**If you are using Zeppe-Lin, these steps are already configured out
of the box.**
**There is no need to repeat them.**

However, this guide is provided for educational purposes, to show how
it was achieved, or for users wanting to adapt this approach for other
distributions or customizations.

1. Create a Dedicated Build User.
   A restricted user is used to perform package builds securely:

   ```sh
   # as root
   useradd -b /var/cache/ -m -s /bin/false -U pkgmk
   ```

   This creates a user and group named `pkgmk` with limited shell
   access.

2. Set Up Build Directories.
   Directories for sources, packages, and temporary files are created
   and assigned ownership to the `pkgmk` user:

   ```sh
   # as root
   mkdir -p /var/cache/pkgmk/{sources,packages,work}
   chown -R pkgmk:pkgmk /var/cache/pkgmk/{sources,packages,work}
   ```

3. Configure `pkgmk`.
   In `/etc/pkgmk.conf`, the paths for these directories are defined:

   ```sh
   PKGMK_SOURCE_DIR="/var/cache/pkgmk/sources"
   PKGMK_PACKAGE_DIR="/var/cache/pkgmk/packages"
   PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name-$$"
   ```

4. Integrate `pkgman`.
   In `/etc/pkgman.conf`, the `makecommand` variable is updated to run
   `pkgmk(8)` as the unprivileged `pkgmk` user via `sudo(8)` and
   `fakeroot(1)`:

   ```
   makecommand sudo -H -u pkgmk fakeroot pkgmk
   ```

This structure ensures package builds are securely isolated while
remaining flexible for adaptations.

---

# CONFIGURATION

## Generating Locales

In Zeppe-Lin, `glibc` package includes a minimal set of locales by
default, with `C.UTF-8` generated for compatibility with `pkgmk(8)`.
To create additional locales, replace `en_US` with your desired locale
and run:

```sh
# as root
localedef -i en_US -f UTF-8 en_US.UTF-8
```

Set the system default locale by adding it to `/etc/profile`:

```sh
export LANG=en_US.UTF-8
```

This ensures consistent locale settings across your system.

## System Initialization and Configuration

Zeppe-Lin uses a lightweight BSD-style init system to manage startup,
services, and shutdown.
This system relies on shell scripts located in `/etc` and `/etc/rc.d`,
offering an efficient and flexible way to control processes.

### System States (Runlevels)

Runlevels define the operating state of the system, such as halting,
rebooting, or normal operation.
Zeppe-Lin's runlevels are configured in `/etc/inittab`:

| Runlevel | State            | Purpose                                   |
| -------- | ---------------- | ----------------------------------------- |
| 0        | Halt             | Shut down the system completely           |
| 1 (S)    | Single-User Mode | Maintenance mode with minimal setup       |
| 2        | Multi-User Mode  | Full system operation with multiple users |
| 3-5      | Unused           | Reserved for custom use                   |
| 6        | Reboot           | Restart the system                        |

By default, Zeppe-Lin boots into multi-user mode (runlevel **2**),
which enables all services and user access.
Single-user mode (runlevel **1** or **S**) is ideal for system
maintenance, providing a minimal environment.

### Core Init Scripts

Zeppe-Lin's init system uses the following scripts to manage system
processes:

| File/Directory   | Purpose                                                           |
| ---------------- | ----------------------------------------------------------------- |
| /etc/rc          | Main system boot script, invoked by `init(8)`                     |
| /etc/rc.modules  | Kernel module initialization, invoked by `/etc/rc`                |
| /etc/rc.single   | Single-user mode script for maintenance tasks                     |
| /etc/rc.multi    | Multi-user mode script for normal operation                       |
| /etc/rc.local    | Custom commands executed after `/etc/rc.multi` during normal boot |
| /etc/rc.d        | Directory containing scripts to control individual services       |
| /etc/rc.shutdown | Script invoked by `shutdown(8)` to gracefully stop services       |

Customize system behavior by modifying `/etc/rc.local` for personal
commands or `/etc/rc.modules` to load specific kernel modules.

See `rc(8)` for details.

### Configuring Runlevels and Init Behavior

The `/etc/inittab` file determines actions for each runlevel.
Each entry follows this format: `id:runlevel:action:command`

Key Components:

* `id`: Unique entry identifier.
* `runlevel`: Runlevels the command applies to.
* `action`: Specifies when the command runs (e.g., on boot, shutdown).
* `command`: The script or program to execute.

Example `/etc/inittab` Configuration:

```sh
# Set default runlevel to multi-user mode
id:2:initdefault:

# Core startup scripts
rc::sysinit:/etc/rc         # Main boot script
rs:S1:wait:/etc/rc.single   # Single-user mode startup
rm:2:wait:/etc/rc.multi     # Multi-user mode startup
rd:06:wait:/etc/rc.shutdown # Graceful shutdown

# Virtual console login prompts
c1:2:respawn:/sbin/agetty --noclear 38400 tty1 linux
c2:2:respawn:/sbin/agetty 38400 tty2 linux
```

This configuration ensures a smooth startup, runtime, and shutdown
process.
See `inittab(5)` for configuration details.

### Configuring System Behavior (/etc/rc.conf)

The `/etc/rc.conf` file centralizes system configuration settings,
such as hostname, timezone, and services.
Example:

```sh
HOSTNAME="myhostname"
TIMEZONE="Europe/Berlin"
SERVICES="lo crond sshd"
```

Services listed in `SERVICES` correspond to scripts in `/etc/rc.d/`,
which are started by `/etc/rc.multi` and stopped by `/etc/rc.shutdown`
(in reverse order).

See `rc.conf(5)` for additional configuration settings.

### Service Control Scripts (/etc/rc.d/)

The `/etc/rc.d/` directory contains individual scripts to manage
services.
Each script supports commands like:

* `start`: Activate the service.
* `stop`: Terminates the service.
* `restart`: Stop and then start the service.
* `status`: Check if the service is running.

Example usage:

```sh
# as root
/etc/rc.d/sshd start
/etc/rc.d/sshd status
```

See `rc.d(7)` for more information.

### Kernel Module Management (/etc/rc.modules)

The `/etc/rc.modules` script is used to initialize kernel modules at
boot.
It begins by running `/sbin/depmod -a` to refresh the module
dependency map, ensuring correct load order.

After this, `rc.modules` delegates to the standalone `modules-load(8)`
utility.
This utility reads configuration files from the following directories:

- `/etc/modules-load.d` --- administrator overrides
- `/run/modules-load.d` --- runtime configuration
- `/lib/modules-load.d` --- vendor defaults

Files must end with `.conf` and contain one module name per line.
Empty lines and lines beginning with `#` are ignored.
An empty or comment-only file in `/etc/modules-load.d` disables vendor
or runtime lists of the same name.

Example configuration file `/etc/modules-load.d/virtio.conf`:

```sh
# Load virtio drivers at boot
virtio-net
virtio-blk
```

> **Note:**  
> For the design reasoning behind `modules-load` and its configuration
> directories, see
> [RATIONALE.md](https://github.com/zeppe-lin/modules-load/blob/master/RATIONALE.md)
> in the source tree.

For modules requiring parameters, configure them in `/etc/modprobe.d/`
for persistent management.  
For example, to set options for the `snd_hda_intel` module, create
`/etc/modprobe.d/snd_hda_intel.conf`:

```sh
# Example: limit snd_hda_intel probing to a specific device
# (probe_mask is hardware-dependent; 8 is only an example)
options snd_hda_intel probe_mask=8
```

This ensures parameters are automatically applied whenever the module
is loaded, avoiding manual specification and following best practice.

Custom one-off module commands may still be added directly to
`/etc/rc.modules` after the `modules-load` call, e.g.:

```sh
# Example: load loopback block device support at boot
/sbin/modprobe loop

# Example: force-load Intel HDA sound driver at boot
# (normally auto-loaded; shown here for illustration)
/sbin/modprobe snd_hda_intel
```

The `/etc/rc.modules` script itself is invoked by `/etc/rc` during the
boot process.

### Custom Startup Commands (/etc/rc.local)

User-defined actions are added to `/etc/rc.local`, executed as last
step of a normal boot (invoked by `/etc/rc.multi`).
Example:

```sh
# Start a monitoring app
/usr/bin/my_monitoring_app &
```

### From Boot to Login: System Startup Sequence

Here's the sequence from power-up to login.
It differs slightly with or without `initramfs`.

#### Without Initramfs

1. Power On: System starts.
2. Bootloader: Loads the kernel into memory.
3. Kernel starts: Initializes hardware and memory.
4. `/sbin/init` starts: The first user-space process (PID 1).
5. `/etc/inittab` is read: `init` gets its instructions.
6. `/etc/rc` runs: The main boot script executes.
7. Runlevel is set: The default runlevel (usually **2**) is chosen.
8. `/etc/rc.multi` starts services:
   Services from `/etc/rc.conf` are launched.
9. `/etc/rc.local` runs: Your custom commands are executed.
10. Login prompts: The system is ready for you.

#### With Initramfs

1. Power On: System starts.
2. Bootloader: Loads kernel and initramfs into memory.
3. Kernel starts: Initializes basic hardware.
4. `initramfs` mounts: A temporary root filesystem in RAM.
5. `/init` from `initramfs` runs:
   Performs early setup (e.g., storage drivers).
6. Real root mounts: Your main filesystem is mounted.
7. Root is switched: System moves from initramfs to your real root.
8. `/sbin/init` on real root starts:
   The init process from your main system.
9. *(Steps 5-10 from [Without Initramfs](#without-initramfs) follow).*

### Minimal Mode (Single-User Mode)

Runlevel **1** or **S** boots the system with a minimal setup for
maintenance.
It runs `/etc/rc.single`, providing a root shell for troubleshooting.

### Graceful Shutdown Procedure

When shutting down or rebooting, `/etc/rc.shutdown` is invoked to stop
services, unmount filesystems, and safely power off the system.

## Networking

### Hostname Configuration

The hostname identifies your system on the network.

To set it temporarily, use:

```sh
# as root
hostname <new_hostname>
```

For a permanent setting, edit `/etc/rc.conf` and set:

```sh
HOSTNAME='<new_hostname>'
```

For proper network function, edit `/etc/hosts` and add your hostname
to the loopback lines:

```
127.0.0.1 localhost <new_hostname>
::1       localhost <new_hostname>
```

This ensures your system recognizes its own name.

### Static Address

To configure a static IP, edit `/etc/rc.d/net`.
Set the network interface, IP, subnet mask, and gateway.
For example:

```sh
DEV=enp11s0
ADDR=192.168.1.100
MASK=24
GW=192.168.1.1
```

Set DNS in `/etc/resolv.conf`:

```
search <your internal domain>
nameserver <your DNS server>
```

Start, stop or restart the service via:

```sh
# as root
/etc/rc.d/net [start|stop|restart]
```

> **Important:**
>
> To auto-start service at boot, add `net` to the `SERVICES` line in
> `/etc/rc.conf`.

### Dynamic Address

To get an IP address automatically via DHCP, install the `dhcpcd`
package and edit `/etc/rc.d/dhcpcd` to specify the network interface
(e.g., `enp5s0`):

```sh
DEV=enp5s0
```

Start, stop, or restart the service via:

```sh
# as root
/etc/rc.d/dhcpcd [start|stop|restart]
```

Check `dhcpcd`'s README for potential issues:

```sh
pkgman readme dhcpcd
```

> **Important:**
>
> To auto-start service at boot, add `dhcpcd` to the `SERVICES` line
> in `/etc/rc.conf`.

### Wireless Network

Ensure the wireless interface isn't blocked.
Use `rfkill(8)`:

```sh
rfkill list

# as root
rfkill unblock <ID|TYPE>
```

Install the `wpa-supplicant` package and edit
`/etc/rc.d/wpa_supplicant` to set the wireless interface:

```sh
DEV=wlp1s0
```

Update `/etc/wpa_supplicant.conf` based on your network settings.
Common security configurations follow.

#### WPA-PSK (Pre-Shared Key)

Generate a key with `wpa_passphrase(8)`:

```sh
wpa_passphrase <MYSSID> <PASSPHRASE>
```

Example `/etc/wpa_supplicant.conf`:

```
network={
    ssid="YOUR_NETWORK_NAME"
    psk="THE_GENERATED_KEY"
}
```

#### WPA-EAP (Enterprise)

Generate a password hash:

```sh
echo -n <PASSPHRASE> | iconv -t utf16le | openssl md4
```

Example `/etc/wpa_supplicant.conf`:

```
network={
    ssid="YOUR_NETWORK_NAME"
    key_mgmt=WPA-EAP
    identity="YOUR_USERNAME"
    password=hash:<YOUR_PASSWORD_HASH>
}
```

#### WEP

Example `/etc/wpa_supplicant.conf` for WEP:

```
network={
    ssid="YOUR_NETWORK_NAME"
    key_mgmt=NONE
    wep_key0="YOUR_WEP_KEY"
    wep_tx_keyidx=0
    auth_alg=SHARED
}
```

For automatic IP, ensure the wireless interface is set in
`/etc/rc.d/dhcpcd`.
Start the services:

```sh
# as root
/etc/rc.d/wpa_supplicant start
/etc/rc.d/dhcpcd start
```

> **Important:**
>
> To auto-start service at boot, add `wpa_supplicant` (and `dhcpcd` if
> using dynamic IP) to the `SERVICES` line in `/etc/rc.conf`.

## Time and Date Configuration

### Timezone Setup

Select your timezone from `/usr/share/zoneinfo` (e.g.,
`Europe/Berlin`).

Set the timezone immediately:

```sh
# as root
ln -sfn /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

To make it persistent, add the timezone to `/etc/rc.conf`:

```sh
TIMEZONE="Europe/Berlin"
```

### System Clock Setup

Manually set the system clock using the `MMDDhhmmYYYY.ss` format:

```sh
# as root

# Example: March 27, 05:35, 2025
date 032705352025.00
```

> **Important:**
>
> Manual configuration is temporary.
> Use NTP for continuous synchronization (described next).

### Network Time Protocol (NTP) Configuration

> **Note:**
>
> Accurate time via NTP is crucial for time-sensitive things like OTP.

Use an NTP client, such as `chrony`, to synchronize the system clock.

After installing `chrony`, start, stop, or restart the service via:

```sh
# as root
/etc/rc.d/chrony [start|stop|restart]
```

> **Important:**
>
> To enable automatic startup, add `chrony` to the `SERVICES` line in
> `/etc/rc.conf`.

## User Authentication and Environment

This section explains Zeppe-Lin's approach to user authentication,
environment setup, and PAM (Pluggable Authentication Modules).

### Password Management

Zeppe-Lin uses `libxcrypt` to provide the `crypt(3)` API for password
hashing.

The default hash algorithm is **SHA-512**, ensuring strong security.
**Legacy algorithms** (MD5, traditional DES) are supported for
compatibility, but their use is discouraged.

Programs that authenticate users via `crypt(3)` must link against
`libxcrypt` (`-lcrypt`).

System-wide password policies are defined in `/etc/login.defs`.
Key parameters include:

- `PASS_MAX_DAYS` --- Maximum password age.
- `PASS_MIN_DAYS` --- Minimum password age.
- `PASS_WARN_AGE` --- Days before expiration to warn users.

Use `passwd(1)` to set or change user passwords.
SHA-512 is recommended for all accounts.

### User Environment

User accounts are created via `useradd(8)` according to
`/etc/login.defs`.

Home directories created with `useradd -m` are empty by default.
To provide default files, use `/etc/skel`.

The default shell `PATH` is defined in `/etc/profile`:

```sh
/sbin:/usr/sbin:/bin:/usr/bin
```

This allows access to administrative commands without specifying full
paths.

### Pluggable Authentication Modules (PAM)

Zeppe-Lin uses PAM for authentication, session management, and
resource control.

PAM configuration files are located in `/etc/pam.d`.
Each file corresponds to a specific service
(e.g., `login`, `su`, `sshd`).
Key modules included:

- `pam_dumb_runtime_dir.so`  
  Creates `XDG_RUNTIME_DIR` on login.
  Required for Wayland, PipeWire, and other XDG-compliant
  environments.

- `pam_env.so`  
  Exports environment variables from `/etc/security/pam_env.conf` and
  `/etc/environment`, enabling system-wide settings for users.

- `pam_limits.so`  
  Enforces resource limits (max processes, open files) defined in
  `/etc/security/limits.conf`.

For advanced configurations, consult module-specific man pages
(e.g., `pam_dumb_runtime_dir(8)`, `pam_env(8)`, `pam_limits(8)`,
`pam_exec(8)`).

---

# APPENDICES

## Appendix A: Licensing & Legal

This appendix summarizes the licensing and legal terms applicable to
Zeppe-Lin, including software components, build scripts, website
content, and artwork.

### Software & Packages

Zeppe-Lin is composed entirely of free and open-source software
obtained from publicly available upstream projects.

Each package retains its original upstream license
(including GPL, BSD, MIT, Apache, and others).
Zeppe-Lin does not relicense, restrict, or replace upstream licensing
terms.

The distributed root filesystem and any binary packages are built from
these sources without the inclusion of proprietary software.
Patches applied during the build process are limited to correctness,
portability, or security fixes and do not alter licensing conditions.

Redistribution and use of binaries are governed solely by the licenses
of the upstream projects from which they originate.

### Build Scripts

Build scripts and related tooling are derived from CRUX and extended
by the Zeppe-Lin project.

- © 2000-2021 [Per Lidén](mailto:per@fukt.bth.se)
  and the [CRUX Team](https://crux.nu)
- © 2022-2026 [Alexandr Savca](mailto:alexandr.savca89@gmail.com)
  and [Zeppe-Lin Team](https://github.com/zeppe-lin)

These scripts are licensed under the
[GNU General Public License version 3 or later (GPLv3+)](https://gnu.org/licenses/gpl.html).

### Website & Artwork

Website content and visual assets, including documentation text,
branding, and release artwork, are maintained by the Zeppe-Lin
project.

- © 2022-2026 [Alexandr Savca](mailto:alexandr.savca89@gmail.com)
  and [Zeppe-Lin Team](https://github.com/zeppe-lin)

This material is licensed under the
[Creative Commons Attribution-ShareAlike 3.0 Unported License (CC-BY-SA 3.0)](https://creativecommons.org/licenses/by-sa/3.0/).

This license applies only to website content and artwork.
Source code, packages, and build scripts are governed by their
respective licenses.

Artwork repository: <https://github.com/zeppe-lin/artwork>  
Website repository: <https://github.com/zeppe-lin/zeppe-lin.github.io/>

### Disclaimer

Zeppe-Lin is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Use it at YOUR OWN RISK.

## Appendix B: Troubleshooting

This appendix collects solutions to common issues in Zeppe‑Lin.
Topics are grouped by area for easier navigation.

### dhcpcd Networking Issues

#### Overview

Covers common problems with `dhcpcd`, including carrier loss, client
ID mismatches, and noncompliant routers.
Edit `/etc/dhcpcd/dhcpcd.conf` to apply fixes.

#### Carrier Lost

If `dhcpcd` logs show messages like:

```
dhcpcd[852]: enp0s31f6: carrier lost
```

or

```
dhcpcd[852]: enp0s31f6: waiting for carrier
dhcpcd[852]: carrier acquired
dhcpcd[852]: soliciting an IPv6 router
dhcpcd[852]: no global addresses for default route
dhcpcd[852]: timed out
```

You may try adding the following options to `/etc/dhcpcd/dhcpcd.conf`:

```sh
nolink   # Ignore carrier status messages (for buggy drivers)
noipv6   # Disable IPv6 router advertisements
```

#### Client ID Issues

If your DHCPv4 network filters Client IDs by MAC address, change:

```
duid
```

To:

```
clientid
```

This forces `dhcpcd` to use the hardware MAC address for DHCPv4,
avoiding issues with RFC4361-style identifiers.
See [RFC 4361](https://tools.ietf.org/html/rfc4361) for details.

#### Noncompliant Routers

Some routers reject requests unless you comment out:

```
require dhcp_server_identifier
```

This is safe unless you have multiple DHCP servers on the same network.
See [Microsoft Technet](https://technet.microsoft.com/en-us/library/cc977442.aspx)
for background.

#### Quick Summary

- Use `nolink` and `noipv6` to handle carrier loss.

- Switch from `duid` to `clientid` for DHCPv4 MAC-based networks.

- Comment out `require dhcp_server_identifier` for noncompliant
  routers.

## Appendix C: Frequently Asked Questions

This appendix collects common questions about Zeppe‑Lin.
Questions are grouped by topic for easier navigation.

### General

#### Why is the distribution named Zeppe-Lin? {.unnumbered}

The name is a deliberate nod to classic UNIX culture and the early era
of Linux experimentation.
It reflects the project's appreciation for engineering craft,
simplicity, and a certain irreverent independence.

The name carries no technical meaning and should not be
over-interpreted.

Or, if you prefer, you can consider it our "Whole Lotta Love" for
Linux and GNU --- just renamed!

#### Is Zeppe-Lin a fork of another distribution? {.unnumbered}

Yes.
Zeppe‑Lin is a fork of [CRUX](https://crux.nu/), a lightweight,
source‑based Linux distribution.

It inherits CRUX's minimalist philosophy and tooling, but evolves them
independently, with its own design decisions and policies.

#### What makes Zeppe-Lin different from CRUX or KISS Linux? {.unnumbered}

Zeppe-Lin focuses on **practical minimalism** rather than extreme
reduction or strict preservation of legacy behavior.

Compared to CRUX, Zeppe-Lin actively refactors core tooling instead of
keeping it unchanged for compatibility's sake.
Package management, build utilities, and system tools are reorganized
for clarity, consistency, and long-term maintainability.

Compared to KISS Linux, Zeppe-Lin favors clear structure and explicit
behavior over minimal code size.
It is willing to use more capable implementations when they improve
correctness, auditability, or usability.

Across the system, Zeppe-Lin generally favors:

- POSIX-compliant sh(1p) instead of Bash
- Explicit configuration over implicit behavior
- Manual pages as a primary interface
- Removal of obsolete or redundant mechanisms
- Readable, structured implementations rather than ad-hoc scripts

Zeppe-Lin does not aim to be the smallest possible system.
It aims to remain understandable and controllable as it evolves.

#### Is Zeppe-Lin suitable for beginners? {.unnumbered}

No.
Zeppe-Lin assumes prior Linux experience.
Users are expected to be comfortable with the command line, manual
configuration, and building software from source.

It is not designed to be beginner-friendly, automated, or "hands-off".

### Installation

#### I can't find the Zeppe‑Lin installation CD/DVD.  Did I miss something? {.unnumbered}

No installation media exists.
Zeppe-Lin is installed using a minimal root filesystem tarball.
Installation is performed from a live environment of your choice.

#### Why is there no installer? {.unnumbered}

An installer would obscure system layout and behavior behind
automation.

Zeppe-Lin intentionally exposes system setup so users understand what
is installed, how it is configured, and why it works.
This approach aligns with the project's emphasis on clarity and
control.

### Configuration

#### Does Zeppe-Lin use systemd? {.unnumbered}

No.
Zeppe-Lin uses a traditional, script-based init system.

Service management is explicit and readable, and does not rely on a
monolithic service manager.

### Packages and Features

#### Where is the package or feature I need? {.unnumbered}

Zeppe-Lin is community-driven.
If a package or feature is missing, users are encouraged to add it.

Follow the `packaging(7)` guidelines and submit a pull request to the
appropriate repository.

The system evolves through user contributions rather than centralized
curation.

#### Why are some familiar CRUX tools missing or replaced? {.unnumbered}

Some tools were removed or replaced because their original design
goals no longer aligned with Zeppe-Lin's direction.

When this happens, replacements are chosen to be simpler, more
explicit, or easier to maintain.
Each major tool includes documentation explaining its design and
differences.

### Maintenance

#### How often does Zeppe-Lin release new versions? {.unnumbered}

Zeppe-Lin follows a **semi-rolling release model**.

The toolchain (compiler, libc, and related components) is kept
stable for extended periods.
Userland packages evolve on top of this stable base.

When accumulated changes make the existing toolchain a limiting
factor, the toolchain is updated, userland is rebuilt and polished,
and a new **major version** is released.

Between major releases, **minor versions** (e.g., v1.1, v1.2) are
published when enough non-toolchain changes accumulate to justify a
new root filesystem.

There is no fixed schedule.
Releases happen when they are ready.

#### Is Zeppe-Lin stable? {.unnumbered}

Zeppe-Lin prioritizes correctness and predictability over rapid
change.

While it is source-based and expects user involvement, care is taken
to avoid unnecessary breakage, especially within a stable toolchain
cycle.

Important packaging changes, required manual interventions, and security
updates are announced on the <zeppe-lin@freelists.org> mailing list.
Users are strongly encouraged to subscribe and follow these notices.

### Support and Community

#### How can I report bugs or issues? {.unnumbered}

See [Appendix D: Reporting Issues](#appendix-d-reporting-issues).
Report issues in the repository corresponding to the affected
component (packages, tools, website, or artwork).
Include version, logs, steps to reproduce, and any relevant local
modifications.

#### Can I contribute? {.unnumbered}

Yes.
Contributions can include:

- New packages or updates to existing ones
- Tool improvements or bug fixes
- Documentation enhancements
- Artwork or visual identity improvements

Follow repository guidelines, and submit a pull request to the
appropriate repository.

### Philosophy

#### Is Zeppe-Lin trying to compete with other distributions? {.unnumbered}

No.
Zeppe-Lin exists to satisfy its own design goals and the needs of its
users.

It does not aim to replace other distributions or appeal to a broad
audience.

## Appendix D: Reporting Issues

This appendix explains how to report problems with Zeppe‑Lin.
Clear, well-structured reports help the team respond efficiently.

### Where to Report

Submit issues in the repository that corresponds to the type of
problem:

- **Package-related problems**  
  Open an issue in the relevant `pkgsrc-*` repository.

- **Tool issues**  
  Report in the specific tool repository,
  e.g., `pkgman`, `pkgmk`, `pkgutils`, `rejmerge`, `revdep`.

- **Website or documentation**  
  Report in the
  [`zeppe-lin.github.io`](https://github.com/zeppe-lin/zeppe-lin.github.io/)
  repository.

- **Artwork or visual assets**  
  Report in the [`artwork`](https://github.com/zeppe-lin/artwork/)
  repository.

- **Upstream software bugs**  
  Report directly to the upstream project, not in Zeppe-Lin repos,
  unless it affects packaging.

You can subscribe to or report via mailing list:

- **General user discussion / small issues:**
  `zeppe-lin@freelists.org`

- **Development, commits, tool updates:**
  `zeppe-lin-dev@freelists.org`

### What to Include

Provide as much relevant information as possible:

- Zeppe-Lin version or snapshot
- Clear description of the problem
- Steps to reproduce
- Relevant error messages, logs, or outputs
- Local modifications that may affect behavior

### Reporting Guidelines

- Verify that the issue is reproducible before reporting.
- Search existing issues to avoid duplicates.
- Keep reports factual, concise, and structured.
- Do **not** assume the cause unless you have evidence.
- Reference related issues, commits, or upstream bugs where applicable.

> **Tip:**
>
> Well-prepared reports get faster responses and make troubleshooting
> easier for both users and developers.
