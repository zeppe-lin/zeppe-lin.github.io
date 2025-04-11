# Zeppe-Lin Handbook

## PREFACE

Zeppe-Lin Handbook. *Because figuring it out yourself is overrated*.

This guide gives you everything you need to install, configure, and
maintain your Zeppe-Lin system.

Build the Zeppe-Lin system you need. This handbook shows you how
(*because nobody else will*).

## 1. INTRODUCTION

### 1.1. About Zeppe-Lin

#### 1.1.1. What is Zeppe-Lin?

Zeppe-Lin is a lightweight, source-based GNU/Linux distro for x86-64,
forked from CRUX. Rooted in KISS and UNIX ideals, it gives you the
simplicity and control to build a clear, transparent system.

#### 1.1.2. Who is Zeppe-Lin For?

Zeppe-Lin is for the Linux user who understands the elegance of Plan 9's
philosophy but still prefers a POSIX-compliant environment they can
build themselves, brick by digital brick.

### 1.2. Principles

Guiding our philosophy:

1. **Keep It Simple (KISS)**: Design and code with minimalism. No
   fluff -- just what's necessary.

2. **Respect the UNIX Spirit**: Craft small, focused tools with
   text-based, modular configurations.

3. **Stay Transparent**: Keep everything clear and understandable.
   Avoid needless abstraction.

4. **Give You the Keys**: Enable full user control. Provide flexible
   tools for true customization.

5. **Build on a Minimal Base**: Start lean. Only add what is
   absolutely required.

These principles ensure Zeppe-Lin remains simple, clear, and true to
UNIX.

## 2. INSTALLATION

### 2.1. Supported Hardware

Zeppe-Lin Linux supports x86-64 processors (e.g., AMD Athlon 64, Intel
Core, Intel Atom). Older architectures, such as i686, are incompatible.

### 2.2. Boot a Live System

Zeppe-Lin is distributed as a compiled tarball containing a root
filesystem. To install it, first boot your computer using a Linux-based
"Live CD/DVD/USB" system.

Launch your preferred Live system, open a terminal, and gain root
privileges (e.g., `sudo su`).

### 2.3. Disk Partitions and Filesystems

This section describes "UEFI and LVM on LUKS" installation.
Additional partitions/filesystems schemes may be added in the future.

#### 2.3.1. UEFI and LVM on LUKS

Set up Zeppe-Lin on a fully encrypted disk (excluding the bootloader
partition) using `dm-crypt` with LUKS and an LVM container inside the
encrypted partition.

**Important:**
Ensure these packages are installed on your Live system:
- `parted`: Create and manage partitions.
- `dosfstools`: Format the boot partition as FAT32 for UEFI.
- `cryptsetup`: Encrypt partition with LUKS.
- `lvm2`: Create and manage the LVM container.

##### 2.3.1.1. Partition Scheme

Example device: `/dev/sda`. Replace with your actual device (e.g.,
`/dev/sdb`, `/dev/nvme0n1`).

| Partition | Filesystem | Size             | Description    |
| --------- | ---------- | :--------------- | :------------- |
| /dev/sda1 | fat32      | 512MB            | boot partition |
| /dev/sda2 | luks       | rest of the disk | luks partition |

**For UEFI systems**, the boot partition should be an ESP (512 MiB
recommended).

##### 2.3.1.2. Create Partitions

Use `parted(8)` to partition the disk:

    # parted /dev/sda
    (parted) mklabel gpt
    (parted) mkpart ESP fat32 1MiB 513MiB
    (parted) set 1 boot on
    (parted) name 1 efiboot
    (parted) mkpart primary 513MiB 100%
    (parted) name 2 luks
    (parted) quit

Encrypt `/dev/sda2` with LUKS and map it:

    # cryptsetup luksFormat /dev/sda2
    # cryptsetup luksOpen /dev/sda2 crypt

##### 2.3.1.3. Create LVM Inside LUKS

Create a physical volume and volume group (e.g., "zpln"):

    # pvcreate /dev/mapper/crypt
    # vgcreate zpln /dev/mapper/crypt

Logical volume scheme:

| Volume name | Filesystem | Size             | Description |
| ----------- | ---------- | :--------------- | :---------- |
| swap        | swap       | 2 x RAM          | swap area   |
| root        | ext4       | rest of the disk | root fs     |

Check RAM size: `# free -m`. Create volumes:

    # lvcreate -L 8G -n swap zpln
    # lvcreate -l 100%FREE -n root zpln

##### 2.3.1.4. Create Filesystems

Format partitions and volumes:

    # mkfs.vfat -F32 /dev/sda1
    # mkfs.ext4 /dev/zpln/root
    # mkswap /dev/zpln/swap
    # swapon /dev/zpln/swap

##### 2.3.1.5. Mount Partitions

The `/mnt` directory is used as the default mount point in this
handbook.

Mount the root volume:

    # mount /dev/zpln/root /mnt

Mount the boot partition:

    # mkdir /mnt/boot
    # mount /dev/sda1 /mnt/boot

### 2.4. Install Base System

Prepare the base system by downloading, verifying, and extracting the
rootfs tarball.

#### 2.4.1. Download Rootfs Tarball

As mentioned, `/mnt` is the default mount point for the system.
Download the rootfs tarball directly into this directory to avoid
using live CD/DVD/USB RAM.

You can find the download URL for the latest rootfs tarball on the
Zeppe-Lin releases page:
<https://github.com/zeppe-lin/pkgsrc-core/releases>.

Alternatively, you can use the following commands, replacing version
`v1.0` with the desired release version (e.g., `v1.0`, `v1.1`, etc):

    # cd /mnt
    # VERSION=v1.0
    # URL=https://github.com/zeppe-lin/pkgsrc-core/releases/download/
    # wget -c ${URL}/${VERSION}/rootfs-${VERSION}-x86_64.tar.xz{,.sig}

#### 2.4.2. Verify Downloaded Tarball

The Zeppe-Lin rootfs tarball is signed using GPG. Verifying the
authenticity and integrity of downloaded files is highly encouraged for
security purposes but not strictly required. If `gpg(1)` is available,
you can verify the tarball using the following commands. Make sure to
replace `${VERSION}` with the version you downloaded:

    # gpg --keyserver keyserver.ubuntu.com --recv-keys 59ec1986fbd902cf
    # gpg --verify rootfs-${VERSION}-x86_64.tar.xz{.sig,}

#### 2.4.3. Extract Rootfs Tarball

Once the rootfs tarball is downloaded and verified, extract its contents
using the following command. Make sure to replace `${VERSION}` with
the version you downloaded:

    # tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
        rootfs-v1.0-x86_64.tar.xz

**Important:**
It is critical to use all the specified options to ensure proper
extraction. Here's what each option does:
* `--numeric-owner`
  Ensures numeric UIDs and GIDs from the tarball are preserved,
  avoiding mismatches caused by the UID/GID mappings on the live
  system.
* `--xattrs --xattrs-include='*'`
  Preserves filesystem extended attributes, which are used for Linux
  capabilities (e.g., allowing programs like `ping(8)` enhanced
  privileges without requiring `suid root`).
* `-xpf`
  Extracts (`x`), preserves permissions and ownership (`p`), and uses
  the specified file (`f`).

### 2.5. Chroot Into Base System

**Important:**
Copy the DNS configuration to ensure network access inside the
chroot, which is needed for updates and installing software:
`# cp /etc/resolv.conf /mnt/etc/resolv.conf`

Mount necessary pseudo-filesystems:

    # mount -B /dev /mnt/dev
    # mount -B /tmp /mnt/tmp
    # mount -B /run /mnt/run
    # mount -t proc proc /mnt/proc
    # mount -t sysfs none /mnt/sys
    # mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 devpts \
        /mnt/dev/pts

**For UEFI only**: Mount EFI variables:

    # mount -B /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars

Enter the chroot:

    # chroot /mnt /bin/bash

Set the `SHELL` variable to `/bin/bash` to ensure tools like Vim work
properly:

    (chrooted) # export SHELL=/bin/bash

### 2.6. Configure Base System

Set the root password:

    (chrooted) # passwd root

Ensure proper ownership and permissions:

    (chrooted) # chown root:root /
    (chrooted) # chmod 755 /

Generate necessary locales
(see [8.1. Generating Locales](#81-generating-locales)).

Edit `/etc/fstab` to configure filesystems (see `fstab(5)`).
Example for [2.3.1. UEFI and LVM on LUKS](#231-uefi-and-lvm-on-luks):

    /dev/zpln/root  /      ext4  defaults,noatime,nodiratime  1 2
    /dev/sda1       /boot  vfat  defaults,noatime,nodiratime  1 2
    /dev/zpln/swap  swap   swap  defaults                     0 0

**Note:**
Use `UUID=...` instead of `/dev/*` for better reliability on
multi-disk systems. Find UUIDs with:
`# blkid -o value -s UUID <DEVICE>`

Uncomment `/var/cache/pkgmk/work` to build packages in RAM
(**if desired**).

Mount necessary filesystems:

Shared memory, required for some builds (e.g., `python3`):

    (chrooted) # mount /dev/shm

EFI variables (**UEFI setup only**):

    (chrooted) # mount /sys/firmware/efi/efivars

If using `tmpfs(5)` for `/tmp`:

    (chrooted) # mount /tmp

For building packages in RAM (if enabled):

    (chrooted) # mount /var/cache/pkgmk/work

**Important:**
Mount `/var/cache/pkgmk/work` only if you have enough RAM and intend
to build packages there.

Edit `/etc/rc.conf` (see `rc.conf(5)`) to configure system settings
like font, keyboard, timezone, hostname, and services.

Configure network settings in `/etc/rc.d/net`, `/etc/hosts`, and
`/etc/resolv.conf` (see [8.3. Networking](#83-networking)).

Add a regular user (set a specific user ID now if needed):

    (chrooted) # useradd --shell /bin/bash --create-home  \
        --groups audio,video,scanner,cdrom,input,users    \
        --uid 1000 --user-group <USERNAME>

Set a password for the new user:

    (chrooted) # passwd <USERNAME>

To make this user privileged (e.g., as Ubuntu does), first, you need
to add your `USERNAME` to the `wheel` group:

    (chrooted) # usermod -aG wheel USERNAME

And second, grant the users in the `whell` group to be root:

    # /etc/sudoers.d/00_wheel: grant users in the wheel group to be root
    %wheel ALL=(ALL:ALL) ALL
    # End of file.

### 2.7. Prepare the Pkgsrc Collections

Packages' sources are organized into collections
(see [7.2.2. Collections](#722-collections) for details).

Clone the necessary collections, keeping in mind that each depends on
the previous one:

    (chrooted) # cd /usr/src/
    (chrooted) # git clone https://github.com/zeppe-lin/pkgsrc-core    \
                    --branch 1.x
    (chrooted) # git clone https://github.com/zeppe-lin/pkgsrc-system  \
                    --branch 1.x
    (chrooted) # git clone https://github.com/zeppe-lin/pkgsrc-xorg    \
                    --branch 1.x
    (chrooted) # git clone https://github.com/zeppe-lin/pkgsrc-desktop \
                    --branch 1.x

Where `--branch 1.x` corresponds to the current Zeppe-Lin release
branch.

Edit `/etc/pkgman.conf` (see `pkgman.conf(5)` for more information)
and enable the cloned collections. By default, only `pkgsrc-core` is
enabled. Additionally, consider editing `/etc/pkgmk.conf` (see
`pkgmk.conf(5)` for more information).

### 2.8. Update Base System

Before installing any packages, it is highly recommended to update the
freshly installed system.

**Warning:**
This warning applies if you are installing Zeppe-Lin version earlier
than 1.0 or upgrading from an older version. Starting from version
6.0, `pkgutils` has introduced backward-incompatible changes for
generating footprint files. Therefore, it's recommended to update
`pkgmk` and `pkgutils` first:
`(chrooted) # pkgman update -f pkgmk pkgutils`

To perform a system update with dependency handling and sorting, and
stop if the installation of at least one package fails:

    (chrooted) # pkgman sysup --deps --depsort --group

After the system update, merge any files that were rejected during
updates:

    (chrooted) # rejmerge

Check for broken packages, and if any are identified, rebuild them:

    (chrooted) # pkgman update -fr --depsort $(revdep)

Here, `revdep(1)` checks for broken dependencies, and if any are
reported, `pkgman update -fr` rebuilds the affected packages.

### 2.9. Install Essential Packages

Install the necessary packages for setting up a workstation:

    (chrooted) # pkgman install --deps --group \
        cryptsetup e2fsprogs dosfstools grub2 grub2-efi iw gnupg \
        lvm2 pinentry wireless-tools wpa-supplicant dhcpcd iputils

This is a generic setup; users can add any additional packages they
require based on their specific needs.

**Note:**
For network setup and configuration details, see
[8.3. Networking](#83-networking). If you set up a networking bridge,
ensure you specify the bridge interface in the `/etc/rc.d/dhcpcd`
and/or `/etc/rc.d/wpa_supplicant` service scripts.

### 2.10. Kernel Setup

Follow one of the two methods below to install and configure the Linux
kernel.

#### 2.10.1. Kernel Package

Build and install Linux kernel:

    (chrooted) # pkgman install --deps --group \
        --config-append="runscripts no" linux

The linux package includes a post-install script that runs
`mkinitramfs(8)` and updates the GRUB config. This script is
disabled here for manual execution later.

**Important:**
When you update the linux package through the package manager, the
old kernel and its modules are removed as part of the update
process. This can cause issues if the system is still using the old
kernel while the new one is being installed. For example:

* If the new kernel fails to install correctly, the system may be left
  without a working kernel.

* The running system might encounter issues due to missing modules
  after the update, as the kernel modules corresponding to the old
  kernel are removed.

To avoid these problems, it is recommended to lock the linux package
from automatic updates and handle kernel updates separately using
`pkgman-update(8)`. This ensures that the current working kernel
remains intact until the new one is fully installed and tested. For
more details, see `pkgman-lock(8)`.
If you installed the kernel using this method, proceed to
[2.11. Kernel Firmware](#211-kernel-firmware) if your system requires
additional firmware, or [2.12. Initramfs](#212-initramfs) otherwise.

#### 2.10.2. Manual Kernel Compilation

This method suits those wanting a minimal kernel or needing sources
for driver building (e.g., Nvidia, VirtualBox).

**Important:**
Use the kernel version from Zeppe-Lin's package sources for best
compatibility. Other versions might cause issues.

##### 2.10.2.1. Download and Unpack

Download the kernel source (only download, don't install):

    (chrooted) # pkgman install -do linux

(Source is typically in `/var/cache/pkgmk/sources`).

Unpack to `/usr/src/`:

    (chrooted) # KV=$(pkgman printf %v --filter=linux)
    (chrooted) # tar -xvf \
        /var/cache/pkgmk/sources/linux-${KV}.tar.?z -C /usr/src/

##### 2.10.2.2. Apply Zeppe-Lin Patches (Optional)

For better Zeppe-Lin integration, apply patches (if any). First, check
for errors:

    (chrooted) # cd linux-${KV}
    (chrooted) # for p in $(pkgman path linux)/*.patch; do \
        [ -f "$p" ] && patch --dry-run -Np1 -i $p; done

If no errors, apply them:

    (chrooted) # for p in $(pkgman path linux)/*.patch; do \
        [ -f "$p" ] && patch -Np1 -i $p; done

##### 2.10.2.3. Configure the Kernel

Custom:

    (chrooted) # make menuconfig

Package Default:

    (chrooted) # cp $(pkgman path linux)/x86_64-dotconfig .config
    (chrooted) # make olddefconfig

##### 2.10.2.4. Build and Install

Compile:

    (chrooted) # make -j$(nproc) all

Install:

    (chrooted) # KV=$(pkgman printf %v --filter=linux)
    (chrooted) # cp arch/x86/boot/bzImage /boot/vmlinuz-${KV}
    (chrooted) # cp .config /boot/config-${KV}
    (chrooted) # make modules_install

Next steps:

Firmware needed? See [2.11. Kernel Firmware](211-kernel-firmware).

No firmware needed? Go to [2.12. Initramfs](212-initramfs).

### 2.11. Kernel Firmware

Some hardware (like certain Wi-Fi or graphics cards) needs extra
firmware.

Install non-free firmware if required:

    (chrooted) # pkgman install --deps --group linux-firmware

Skip this if you prefer a completely free software system.

### 2.12. Initramfs

First, install mkinitramfs:

    (chrooted) # pkgman install --deps --group mkinitramfs

The mkinitramfs configuration file (`/etc/mkinitramfs/config`) defines
settings like the root device and filesystem. Here's an example for
[3.3.1. UEFI and LVM on LUKS](331-uefi-and-lvm-on-luks):

    # /etc/mkinitramfs/config
    hostonly=1 #(optional, creates smaller initramfs)
    compress="gzip --fast"
    hooks="eudev luks lvm resume"
    root=/dev/zpln/root
    root_type=ext4
    resume=/dev/zpln/swap
    luks_name=crypt
    luks_root=/dev/sda2
    # End of file.

See `mkinitramfs.config(5)` for more information.

**Important:**
`hostonly` creates a smaller initramfs with only necessary modules.
If you move the drive to different hardware later, it might not boot.

**Note:**
For multi-disk systems, using `UUID=...` instead of `/dev/*` in the
config can prevent boot issues.
Find UUIDs with: `# blkid -o value -s UUID <DEVICE>`.

Now, prepare an initramfs. If you installed the `linux` kernel
manually, you have already set `KV` variable to kernel version.
Otherwise, fetch the kernel version from the package source:

    (chrooted) # KV=$(pkgman printf %v --filter=linux)

Finally, generate the initramfs image:

    (chrooted) # mkinitramfs -o /boot/initramfs-${KV}.img -k ${KV}

### 2.13. Bootloader

This section covers installing GRUB2 as your bootloader.
Support for other bootloaders may be added later.

#### 2.13.1. GRUB2

Create `/etc/default/grub` with:

    # /etc/default/grub
    # Set the delay before booting.
    GRUB_TIMEOUT=3
    # Show ZPLN in the GRUB menu.
    GRUB_DISTRIBUTOR=ZPLN
    # Set kernel parameters (quiet boot, swap for hibernation)
    GRUB_CMDLINE_LINUX_DEFAULT="quiet resume=/dev/zpln/swap"
    # End of file.

**Important:**
For better reliability on multi-disk systems, use `UUID=...` instead
of `/dev/*` for the resume partition.
Find the UUID with: `# blkid -o value -s UUID <DEVICE>`.

Next, install GRUB2 on your target drive.

For UEFI systems (adjust `/dev/sda` if needed):

    (chrooted) # grub-install --target=x86_64-efi \
        --efi-directory=/boot /dev/sda

For BIOS systems (adjust `/dev/sda` if needed):

    (chrooted) # grub-install --target=i386-pc /dev/sda

Finally, generate the GRUB2 configuration file based on
`/etc/default/grub` and detected kernels:

    (chrooted) # grub-mkconfig -o /boot/grub/grub.cfg

### 2.14. Post-installation Tasks

#### 2.14.1. Install Xorg and Drivers

To find video and input drivers, run:

    # pkgman search -vv xf86-

Common video drivers include `xorg-xf86-video-intel` (Intel),
`xorg-xf86-video-amdgpu`/`xorg-xf86-video-ati` (AMD), and
`xorg-xf86-video-nouveau` (NVIDIA). For NVIDIA, consider also building
`nouveau-firmware` for better support.

For input, modern drivers like `xorg-xf86-input-libinput` and
`xorg-xf86-input-evdev` are recommended. Legacy options like
`xorg-xf86-input-keyboard` and `xorg-xf86-input-mouse` are also
available.

After selecting drivers for your hardware, install xorg with:

    # pkgman install --deps --group xorg [DRIVERS]

Replace `[DRIVERS]` with the ones matching your system.

#### 2.14.2. Install a Window Manager

Zeppe-Lin focuses on lightweight and efficient window managers rather
than complex desktop environments like GNOME or KDE. This approach
avoids unnecessary dependencies and simplifies configuration.

##### 2.14.2.1. Ratpoison

Currently, the `pkgsrc-desktop` repository provides the ratpoison
window manager. You can install it with:

    # pkgman install --deps --group ratpoison

##### 2.14.2.2. Optional: Window Maker

For users interested in a retro, intuitive window manager, you can
install Window Maker from the unofficial `pkgsrc-wmaker` repository.

**Warning:**
Using unofficial repositories means the packages might not follow the
same update schedule or quality standards as the official
repositories. **Use with caution.**

To install Window Maker, first clone the repository:

    # cd /usr/src
    # git clone https://github.com/zeppe-lin/pkgsrc-wmaker \
        --branch 1.x

Next, you need to tell `pkgman(1)` about this new repository by
adding the following line to `/etc/pkgman.conf`:

    pkgsrcdir /usr/src/pkgsrc-wmaker

Then, install it with:

    # pkgman install --deps --group wmaker

Optional meta-packages for Window Maker include `wmaker-dockapps` for
added functionality and `wmaker-themes` for customization.

If neither of these options meets your needs, you are welcome to
create package sources for other desktop environments (DEs) or window
managers that better suit your preferences.

### 2.15. Reboot

Exit the chroot, unmount all filesystems, and reboot:

    (chrooted) # exit
    # cd /
    # umount -R /mnt
    # shutdown -r now

The GRUB menu should appear, allowing you to boot into Zeppe-Lin
Linux.

## 3. UPGRADING

**WARNING! THIS SECTION IS UNDER DEVELOPMENT AND CANNOT BE USED AS A
MANUAL!**

Upgrading Zeppe-Lin requires careful planning. This section outlines
methods for updating your system. Follow the steps as presented to
ensure a reliable upgrade.

Upgrade methods:

1. Quick binary upgrade (core components).
2. Full update from sources.

Before starting, read the release notes for the target version and
back up important data.

### 3.1. Release Notes

Read the release notes for the new Zeppe-Lin version. They contain
essential details about new features, removed packages, and
compatibility issues. The latest release notes you can obtain
[here](https://zeppe-lin.github.io/index.html#latest-release).

### 3.2. Set Release And Sync

Synchronize your local pkgsrc collections to match the new release
branch. Replace `1.x` with the specific release you are upgrading to:

    git -C /usr/src/pkgsrc-core    switch 1.x
    git -C /usr/src/pkgsrc-system  switch 1.x
    git -C /usr/src/pkgsrc-xorg    switch 1.x
    git -C /usr/src/pkgsrc-desktop switch 1.x

### 3.3. Binary Upgrade

Use precompiled binary packages for faster core system upgrades,
especially to avoid build issues during initial updates.

**Important:**
Upgrades may cause file conflicts, such as a file being reassigned
between packages. To prevent issues, read the release notes for the
target Zeppe-Lin version. They detail package changes like removals,
merges, or renames that may require manual intervention.

#### 3.3.1. Download and Extract binpkgs

**Note:**
Verify the integrity of the downloaded binpkgs tarball before
extracting it. It is signed using the same method as the Zeppe-Lin
root filesystem image.

Download the tarball and its signature for your upgrade, replacing
`v1.0` with the target version:

    $ URL=https://github.com/zeppe-lin/pkgsrc-core/releases/download
    $ wget -c ${URL}/v1.0/binpkgs-v1.0-x86_64.tar.xz{,.sig}

Verify the tarball with `gpg(1)`:

    $ gpg --keyserver keyserver.ubuntu.com --recv-keys 59ec1986fbd902cf
    $ gpg --verify binpkgs-v1.0-x86_64.tar.xz{.sig,}

Extract the tarball after successful verification:

    $ mkdir -p ~/tmp/binpkgs
    $ tar -xf binpkgs-v1.0-x86_64.tar.xz -C ~/tmp/binpkgs

#### 3.3.2. Upgrade Core Packages

Navigate to the directory and upgrade core packages:

    $ cd ~/tmp/binpkgs
    $ for pkg in *.pkg.tar.gz; do sudo pkgadd -u $pkg; done

`pkgadd -u` upgrades each package. New, non-upgradable packages will
return an error, which the loop skips, ensuring all upgradeable
packages are updated.

#### 3.3.3. Install New Core Packages

Install new core packages introduced in the release:

    $ cd ~/tmp/binpkgs
    $ for pkg in *.pkg.tar.gz; do sudo pkgadd $pkg; done

`pkgadd` installs each package. Already installed packages return an
error, which the loop skips to ensure all new packages are installed.

## 6. PACKAGE MANAGEMENT

### 6.1. Introduction

Zeppe-Lin's package management system revolves around packages and
package sources. Low-level tools handle atomic operations like
installation and building, while the high-level tool pkgman bridges
these workflows into system-wide and Pkgsrc-based management.

- Packages:
  Compressed archives (e.g., `tar.gz`) containing pre-built software.

- Package Sources:
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

###  6.2. What is a Package?

A Zeppe-Lin package is a compressed archive (e.g., `tar.gz`) that
contains only the software files. It avoids any kind of embedded
metadata, ensuring simplicity and transparency in its structure.

#### 6.2.1. Package Naming

Zeppe-Lin packages follow a clear naming convention:

    name#version-release.pkg.tar.gz

Components:
- `name`: Package name.
- `version`: Version number.
- `release`: Build revision.

Example:

    ed#1.21-1.pkg.tar.gz

The extension `.pkg.tar.gz` denotes a Zeppe-Lin package. Other common
compression formats like `tar.bz2`, `tar.xz`, and `tar.zst` are also
supported.

#### 6.2.2. Package Database

The package database, located at `/var/lib/pkg/db`, tracks installed
packages and their contents. Each package entry follows this format:

    <name>                 # Package name
    <version>-<release>    # Version and release
    <dir>/                 # Top-level directory
    <dir>/<subdir>         # Subdirectory
    <dir>/<subdir>/<file>  # File within subdirectory
    (Blank line)           # Separates package entries

Example entry for ed:

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

**Note:**
This database enables essential operations like installation
(`pkgadd(8)`), removal (`pkgrm(8)`), and inspection (`pkginfo(8)`).

### 6.3. Low-level Tools: pkgutils

`pkgutils` provides the core utilities to handle packages:

- `pkgadd(8)`: Installs or upgrades packages.
- `pkgrm(8)`: Removes packages.
- `pkginfo(1)`: Displays package details.

#### 6.3.1. Using pkgutils

##### 6.3.1.1. Installing a Package

Install a package file with `pkgadd(8)`:

    # pkgadd bash#5.0.18-1.pkg.tar.gz

By default, `pkgadd(8)` prevents overwriting existing files. Use
`-f` or `--force` to override this behavior (use with caution!):

    # pkgadd -f bash#5.0.18-1.pkg.tar.gz

##### 6.3.1.2. Upgrading a Package

Upgrade a package with the `-u` or `--upgrade` option:

    # pkgadd -u bash#5.0.18-1.pkg.tar.gz

This replaces the installed package. If the package is not installed,
it will return an error. You can even "upgrade" to an older version.

Files that should not be upgraded (based on `/etc/pkgadd.conf`) are
placed in `/var/lib/pkg/rejected/`.

##### 6.3.1.4. Removing a Package

To remove a package, use `pkgrm(8)` followed by the package name:

    # pkgrm bash

This removes all files owned by the package without confirmation. Be
cautious!

##### 6.3.1.5. Inspecting Packages

Use `pkginfo(1)` to get information about packages.

List installed packages and versions:

    $ pkginfo -i

List files in a package:

    $ pkginfo -l bash

List files in a package archive (before installing):

    $ pkginfo -l grep#2.5-1.pkg.tar.gz

Find which package owns a file:

    $ pkginfo -o /usr/bin/ls

See `pkgadd(8)`, `pkgrm(8)`, and `pkginfo(1)` for details.

#### 6.3.4. Configuring pkgadd

You can customize `pkgadd(8)` behavior during package upgrades
using `/etc/pkgadd.conf`. Rules define whether files should be
upgraded or preserved.

##### 6.3.4.1. Rule Format

Each rule in `/etc/pkgadd.conf` follows this format:

    EVENT   PATTERN   ACTION

- `EVENT`: Currently, only `UPGRADE` is supported.
- `PATTERN`: A regular expression matching filenames in the package.
- `ACTION`: `YES` to upgrade files, `NO` to preserve them.

Rules are processed sequentially, with the last matching rule taking
priority.

##### 6.3.4.2. Example

Example `/etc/pkgadd.conf`:

    # /etc/pkgadd.conf
    UPGRADE   ^etc/.*$              NO
    UPGRADE   ^var/log/.*$          NO
    UPGRADE   ^etc/X11/xorg.conf$   YES

This setup will:

- Keep all files in `/etc` and its subdirectories.
- Keep all files in `/var/log` and its subdirectories.
- Upgrade `/etc/X11/xorg.conf` specifically (overrides the `/etc`
  rule).

**Caution:**
Patterns match filenames inside the package, not full system paths.
Do not use `/` at the start!

See `pkgadd.conf(5)` for details.

### 6.4. Low-level Tools: rejmerge

`rejmerge(8)` resolves files rejected during upgrades using `pkgadd
-u`.  Rejected files are moved to `/var/lib/pkg/rejected/` for manual
handling, while `rejmerge(8)` provides a way to manage these files
semi-automatically.

#### 6.4.1. Using rejmerge

If files are present in `/var/lib/pkg/rejected`, `rejmerge(8)`
prompts you to decide their fate. For each file, you can choose:

    =======> file
    (diff output between installed file and rejected file)
    [K]eep [U]pgrade [M]erge [D]iff [S]kip

Legend:

- `[K]eep`: Retain the current file as it is.
- `[U]pgrade`: Replace the current file with the new version.
- `[M]erge`: Combine changes from the current and new versions.
- `[D]iff`: Display differences between the current and new versions.
- `[S]kip`: Defer the decision and revisit it later.

See `rejmerge(8)` for details.

#### 6.4.2. Configuring rejmerge

Configurations for `rejmerge(8)` can be adjusted in
`/etc/rejmerge.conf`.  Key settings:

- `rejmerge_diff`: Defines how differences are displayed.
- `rejmerge_merge`: Controls how files are merged.
- `EDITOR`: Specifies the editor for merges.
- `PAGER`: Specifies the pager for differences.

##### 6.4.2.1. Example

Use unified, colorized output for differences:

    rejmerge_diff() { diff -u --color=always $1 $2 > $3 ; }

Use `sdiff` for merging files:

    rejmerge_merge() { sdiff -o $3 $1 $2 ; }

See `rejmerge.conf(5)` for more details.

### 6.5. Low-level Tools: pkgmk

`pkgmk(8)` builds Zeppe-Lin packages (compressed archives) from source
files using a `Pkgfile`. These files, along with the supporting
directory, form a Package Source -- a self-contained unit that
includes all files needed to build and install software.

A Package Source typically contains:

- `Pkgfile`: Defines metadata and build steps.
- `.md5sum`: Ensures the integrity of downloaded files.
- `.footprint`: Lists expected files in the final package.

A Package Source is the basic unit of software organization in
Zeppe-Lin. While this chapter introduces Package Sources in the
context of building packages, Chapter 7 explores their organization
into Collections and Repositories for broader software management
workflows.

#### 6.5.1. Pkgfile Format

The Pkgfile defines:

- `name`, `version`, `release`: Package identity.
- `source`: URL to download the software's source code.
- `build()`: Instructions to compile and package the software.

##### 6.5.1.1. Example

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

See `Pkgfile(5)` for details.

#### 6.5.2. Using pkgmk

##### 6.5.2.1. Building a Package

To build a package, create a directory named after the package, `cd`
into this directory, place the `Pkgfile` inside, and run:

    $ fakeroot pkgmk -d -cf /dev/null

`fakeroot`: Always use to avoid system risks.
`-d`: Downloads missing source files.
`-cf /dev/null`: Ignores `/etc/pkgmk.conf` and uses defaults.

On the first build, `pkgmk(8)` generates:

- `.footprint`: Tracks package contents.
- `.md5sum`: Ensures source files integrity.

The final package (e.g., `hello#2.12.1-1.pkg.tar.gz`) will be in the
current directory.

#### 6.5.3. Configuring pkgmk

Customize `pkgmk(8)` with `/etc/pkgmk.conf`. Key settings:

- `CFLAGS`, `CXXFLAGS`: Compiler optimization flags.
- `PKGMK_SOURCE_MIRRORS`: Backup URLs for source archives.
- `PKGMK_SOURCE_DIR`: Directory for source archives.
- `PKGMK_PACKAGE_DIR`: Directory for built packages.
- `PKGMK_WORK_DIR`: Temporary build directory.

##### 6.5.3.1. Example

Define backup URLs:

    PKGMK_SOURCE_MIRRORS="http://fileserver.intranet/sources/
                          http://mirror2/sources/"

Set a unique work directory:

    PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name-$$"

Using `$name` (package name) and `$$` (process ID) avoids conflicts
during simultaneous builds.

**Note:**
Although unique directories avoid build conflicts, `pkgadd(8)` locks
the database, so simultaneous installations may fail.

See `pkgmk.conf(5)` for full options.

### 6.6. High-level Tool: pkgman

`pkgman(1)` serves as a versatile interface for managing Zeppe-Lin's
package ecosystem. Building on tools like `pkgutils` and `pkgmk`, it
unifies and simplifies workflows while supporting a wide range of
package management tasks.

`pkgman(1)` empowers users to:

- Handle dependencies and system updates efficiently.
- Automate and streamline build processes.
- Extend functionality with dynamic features and workflows.

With its adaptable design, `pkgman(1)` integrates seamlessly into
diverse system management scenarios, making it an indispensable tool
for maintaining and customizing Zeppe-Lin.

#### 6.6.1. Using pkgman

##### 6.6.1.1. List Installed Packages

List installed packages:

     $ pkgman list

Include versions:

    $ pkgman list -v

Include versions and descriptions:

    $ pkgman list -vv

##### 6.6.1.2. Query Package Information

Display detailed package information:

    $ pkgman info acl

Example output:

    Name:         acl
    Path:         /usr/src/pkgsrc-core
    Version:      2.3.1
    Release:      1
    Description:  Access Control List filesystem support
    URL:          http://savannah.nongnu.org/projects/acl
    Dependencies: attr

##### 6.6.1.3. Search Package Sources

Search by name:

    $ pkgman search -vv glibc

Search using regular expressions:

    $ pkgman search -vv --regex '^(glib)c?$'

Search by description:

    $ pkgman dsearch -vv archive

##### 6.6.1.4. Query Dependencies

Show direct dependencies:

    $ pkgman dep vim

Show recursive dependencies:

    $ pkgman dep vim --recursive

Show detailed dependency tree:

    $ pkgman dep vim --recursive --tree

##### 6.6.1.5. Build and Install Packages

Build and install a package with dependencies (recommended):

    # pkgman install --deps --group xterm

Use `--group` to stop installation if a dependency fails. Retry failed
installations:

    # pkgman install --deps --group --force xterm

`--force` skips already installed packages during the retry.

##### 6.6.1.6. Update Installed Packages

Identify outdated packages:

    $ pkgman diff --deps --full

Update a single package:

    $ pkgman update --deps --group bind

Upgrade all packages in the system:

    $ pkgman sysup --deps --depsort --group

#### 6.6.2. Configuring pkgman

`pkgman(1)` is configured via `/etc/pkgman.conf`. Key settings:

- `pkgsrcdir`
  Defines directories for package source collections (you can list
  multiple). The `pkgsrc-core` collection is enabled by default. See
  [7.2.2. Collections](#722-collections) for additional collections.

  Details about `pkgsrcdir` and how it is used to configure
  Collections and Repositories are explored in Chapter 7.

- `runscripts`
  Enables `pre-install`, `post-install`, `pre-remove`, and
  `post-remove` scripts during operations. **Enable this option.**

- `logfile`
  Specifies the log file for `pkgman(8)` operations.

See `pkgman.conf(5)` for more details.

### 6.6. The Essentials (outro)

This chapter introduced Zeppe-Lin's tools for managing individual
packages and basic system updates.

In the next chapter, we introduce Collections of Package Sources -- a
modular approach to organizing and managing software -- with pkgman
serving as the central orchestration tool.

## 7. PACKAGE SOURCES AND COLLECTIONS

### 7.1. Introduction

Zeppe-Lin organizes software sources into three key components:

- Package Sources:
  Self-contained directories that include all files and instructions
  needed to build and install software. These are the foundation of
  Zeppe-Lin's software management.

- Collections:
  Logical groupings of Package Sources, organized by purpose (e.g.,
  core, system tools, desktop applications). Collections simplify
  software organization and provide modularity.

- Repositories:
  Distributed storage systems that host one or more Collections.
  Repositories enable versioning, collaboration, and synchronization
  across systems.

These components provide a structured approach to building, managing,
and distributing software on Zeppe-Lin. Tools like `pkgmk(8)` and
`pkgman(1)` are used to interact with these components, supporting
workflows such as dependency management, package building, and system
updates.

### 7.2. Organizing Package Sources

#### 7.2.1. Package Source: The Core Unit

In Zeppe-Lin, a Package Source is the fundamental unit for building
software. Each one represents a single application, library, or
utility, organized as a directory with all the necessary files to
build and install the software.

Essential files include:

- `Pkgfile`:
  The main build script. It defines the package's metadata (name,
  version, dependencies) and includes the steps for downloading,
  compiling, and packaging the software using `pkgmk(8)`.

- `.md5sum`:
  This file contains checksums for verifying the integrity of
  downloaded source files. It ensures that the files have not been
  altered or corrupted during transfer.

- `.footprint`:
  Used for build verification, it lists the files expected in the
  final package. This helps maintain consistency in builds.

Some Package Sources may include additional files to support custom
builds or configurations:

- Patch files (`*.patch`): Modify the source code before building.

- Configuration files for scheduled tasks (`cron.*`): Useful for
  automating processes.

- Scripts for managing services (`rc.*`): Enable or disable services
  automatically.

- PAM configuration files (`pam.*`): Handle user authentication.

Together, these files create a self-contained environment for building
and managing software.

#### 7.2.2. Collections

Collections are logical groupings of Package Sources. A collection is
simply a directory containing multiple Package Sources with a shared
purpose, like system utilities or desktop applications.

Example Collection structure:

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

This logical organization enables modular software management. Instead
of dealing with individual packages in isolation, Collections provide
a structured approach to grouping and managing related sets of
software.

Common Collections in Zeppe-Lin:

- `pkgsrc-core`: Core packages for a minimal system.
- `pkgsrc-system`: Utilities and system-specific tools.
- `pkgsrc-xorg`: X Window System and related tools.
- `pkgsrc-desktop`: Desktop applications.

These Collections form the foundation of Zeppe-Lin's software
ecosystem, allowing users to selectively enable the software they
need.

#### 7.2.3. Repositories: Distributing and Versioning Collections

Collections are organized into Repositories, hosted on systems like
Git. It's important to note that while a repository **can** contain
multiple collections, Zeppe-Lin's official repositories adopt a
strategy where each repository primarily focuses on a single
collection. This design choice is driven by the benefits of allowing
users to selectively clone only the collections they need.
Repositories provide:

- Versioning: Branches manage package sources for specific Zeppe-Lin
  releases (e.g., `1.x`, `2.x`), ensuring compatibility.

- Distribution: Users can clone repositories to access collections and
  package sources.

The official Zeppe-Lin repositories, following this
one-collection-per-repository approach, include:

- `pkgsrc-core.git`: Core packages for a minimal system.
- `pkgsrc-system.git`: Utilities and system-specific tools.
- `pkgsrc-xorg.git`: X Window System and related tools.
- `pkgsrc-desktop.git`: Desktop applications.

Repositories ensure that collections are both modular and manageable,
allowing users to selectively clone only the collections they need.

### 7.3. Managing Package Sources

#### 7.3.1. Setting Up Collections

To access software for installation in Zeppe-Lin, download the
official package source collections and enable them for `pkgman(1)`.

##### 7.3.1.1. Syncing Official Repositories

Clone the repositories from the Zeppe-Lin GitHub account:

    # cd /usr/src/
    # git clone https://github.com/zeppe-lin/pkgsrc-core    --branch 1.x
    # git clone https://github.com/zeppe-lin/pkgsrc-system  --branch 1.x
    # git clone https://github.com/zeppe-lin/pkgsrc-xorg    --branch 1.x
    # git clone https://github.com/zeppe-lin/pkgsrc-desktop --branch 1.x

Replace `1.x` with the branch matching your Zeppe-Lin release (e.g.,
`1.x` for version 1.0 or 1.1). Check the Zeppe-Lin website or release
notes for the correct branch.

##### 7.3.1.2. Enabling Collections in pkgman.conf

Edit `/etc/pkgman.conf` to enable package sources collections. For
example:

    # /etc/pkgman.conf
    pkgsrcdir /usr/src/pkgsrc-core
    pkgsrcdir /usr/src/pkgsrc-system
    pkgsrcdir /usr/src/pkgsrc-xorg
    pkgsrcdir /usr/src/pkgsrc-desktop

For detailed configuration options, see `pkgman.conf(5)`.

##### 7.3.1.3. Verify Your Setup

Confirm that `pkgman(1)` recognizes the collections:

    $ pkgman list --all

This lists all package sources from enabled collections.

#### 7.3.2. Exploring and Installing Packages

With collections enabled, you can explore and install packages using
`pkgman(1)`.

##### 7.3.2.1. Listing Available Packages

List all package sources:

    $ pkgman list --all

Example output:

    -- list ([i] = installed)
    [i] acl
    [i] bash
    [ ] vim
    [ ] zathura
    ...

Legend:

- `[i]`: The package is already installed.
- `[ ]`: The package is available but not installed.

To display the full path of each package source (helpful for
identifying which collection a package belongs to), use the `--path`
option:

    $ pkgman list --all --path

Example output:

    [i] /usr/src/pkgsrc-core/acl
    [ ] /usr/src/pkgsrc-system/vim

##### 7.3.2.2. Searching for Packages

If you're looking for specific software, use the `search` command. For
example, to search for packages related to `alsa`:

    $ pkgman search alsa

Example output:

    -- search ([i] = installed)
    [ ] alsa-lib
    [ ] alsa-ucm-conf
    [i] alsa-utils

The output indicates which packages are installed and available.

For a detailed search that includes collection paths, add the `--path`
option:

    $ pkgman search --path alsa

##### 7.3.2.3. Building and Installing Packages

Build and install a package with dependencies:

    # pkgman install --deps --group <package_name>

Example:

    # pkgman install --deps --group vim

Build and install multiple packages:

    # pkgman install --deps --group vim zathura

**Tip:** Use `pkgman search` to locate package names.

Customize installations:

- Verbose output (`-vv`):

    # pkgman install --deps -vv vim

- Dry Run (`--test`):

    # pkgman install --deps --test vim

Run `pkgman install --help` or see `pkgman-install(1)` for all
installation options.

#### 7.3.3. Keeping Your System Up-to-Date

Maintaining your Zeppe-Lin system involves two primary tasks:

1. Sync your Repositories regularly to stay up-to-date.
2. Updating installed packages to their latest versions.

##### 7.3.3.1. Synchronizing Local Collections

Regularly sync local collections with remote repositories using
`git pull`:

    # git -C /usr/src/pkgsrc-core     pull
    # git -C /usr/src/pkgsrc-system   pull
    # git -C /usr/src/pkgsrc-xorg     pull
    # git -C /usr/src/pkgsrc-desktop  pull

Include unofficial collections if applicable.

Automate Syncing: Set up a cron job with `crond(8)`:

    # Weekly sync at 3:00 AM on Sundays
    0 3 * * 0 /root/pkgsrc-sync.sh

Example script (/root/pkgsrc-sync.sh):

    #!/bin/sh
    LOCKFILE="/var/lock/pkgsrc-sync.lock"
    exec 9>"$LOCKFILE"
    if ! flock -n 9; then
        echo "Another sync in progress."
        exit 1
    fi
    git -C /usr/src/pkgsrc-core     pull
    git -C /usr/src/pkgsrc-system   pull
    git -C /usr/src/pkgsrc-xorg     pull
    git -C /usr/src/pkgsrc-desktop  pull
    echo "Repositories synced."

For logging, replace `echo` with `logger`.

##### 7.3.3.2. Checking for Package Updates

Identify outdated packages with pkgman diff:

    $ pkgman diff --deps --full

Example output:

```
-- Differences between installed packages and packages sources tree
Package         Installed      Available
feh             3.7.2-1        3.7.2-2
tmux            3.3a-1         3.3a-2
...

-- Packages not found in the packages sources tree
Package         Installed      Required by
libncurses      6.2-1          vim
```

Review this output to determine which packages need updates. Packages
in the "not found" section may have been removed from the collection
or installed manually from other sources.

##### 7.3.3.3. Updating Packages

Use `pkgman sysup` for a system upgrade:

**Step 1: Download Source Files**

Download all required source files first:

    # pkgman sysup -do

This ensures that all necessary files are retrieved before the upgrade
begins, avoiding interruptions during the build process.

**Step 2: Upgrade Packages**

    # pkgman sysup --deps --depsort --group

These options ensure proper dependency handling and upgrade order.

##### 7.3.3.4. Updating Specific Packages

Update individual packages with pkgman update. For example:

    # pkgman update --deps --depsort --group tmux feh

This command updates only the specified packages while resolving their
dependencies.

#### 7.3.4. Advanced Package Management

##### 7.3.4.1. Detecting Broken Dependencies with revdep(1)

`revdep(1)` checks installed packages for missing or incorrect shared
libraries. Use it to verify system stability and identify packages
needing a rebuild after updates.

Examples:

- Check system-wide for broken libraries:

    revdep

- Rebuild affected packages:

    pkgman update -fr $(revdep)

- Inspect a specific package:

    revdep bash

- Add non-standard library directories:
  Create a file in `/etc/revdep.d/` named after the package.
  Example:

    /usr/lib/firefox

Run `revdep` regularly after updates or repository syncs to ensure all
packages remain functional.

##### 7.3.4.1. Ignoring Packages During Updates

Prevent updates to specific packages during system upgrades with
`--ignore`. Example:

    # pkgman sysup --deps --depsort --group --ignore=vim,tmux

Regularly revisit ignored packages to avoid security risks and
dependency conflicts.

##### 7.3.4.2. Locking Packages

Lock a package to prevent upgrades indefinitely:

    # pkgman lock vim

Unlock a package to resume updates:

    # pkgman unlock vim

Locked packages are useful for maintaining specific software versions
critical to workflows.

##### 7.3.4.3. Handling Lower Available Versions

Occasionally, a package source may revert to a lower version than the
one installed on your system. This often happens when maintainers roll
back to a stable release after issues with a newer version. By
default, `pkgman` does not prioritize installed versions over
available ones.

To override this behavior, enable the `preferhigher` option:

    # pkgman --config-set="preferhigher yes" sysup --deps --depsort

This ensures `pkgman` retains the higher installed version during
upgrades. Use this feature cautiously, as higher versions might be
less stable or unsupported.

##### 7.3.4.4. Practical Considerations

- Regularly review ignored and locked packages for security and
  compatibility.

- Avoid using `preferhigher` without understanding the implications of
  using potentially unstable software.

- Check dependency trees carefully to prevent system breakages.

### 7.4. Extending Software Sources

#### 7.4.1. Adding a Local Collection

This section explains how to create custom collections. A local
collection allows you to add new packages that are not available in
the official repositories.

##### 7.4.1.1. Creating the Collection Directory

Create your local collection directory in `/usr/src`, alongside
official Zeppe-Lin collections. Using directories with broader read
permissions ensures that unprivileged users like pkgmk can access the
collection.

Example:

    # cd /usr/src
    # mkdir mynewcollection

##### 7.4.1.2. Enabling the Collection in pkgman.conf

Add your collection to `/etc/pkgman.conf`. List it above official
collections to give it search priority:

    # /etc/pkgman.conf
    pkgsrcdir /usr/src/mynewcollection
    pkgsrcdir /usr/src/pkgsrc-core
    pkgsrcdir /usr/src/pkgsrc-system
    pkgsrcdir /usr/src/pkgsrc-xorg

Save the file and proceed to verify the setup.

##### 7.4.1.3. Verifying the Collection Setup

Verify that `pkgman(1)` recognizes your collection:

    $ pkgman dumpconfig

Check the "Packages sources directories" section for your collection:

    Packages sources directories: <n>
      /usr/src/mynewcollection <-- here
      /usr/src/pkgsrc-core
      /usr/src/pkgsrc-system
      /usr/src/pkgsrc-xorg
      ...

If it appears, the setup is complete, and you can start adding package
sources.

#### 7.4.2. Creating Custom Packages

After setting up your local collection, the next step is to add a
package source. This involves creating a directory for the package and
writing a `Pkgfile` with build instructions and metadata.

##### 7.4.2.1. Creating the Package Directory

Create a subdirectory for the new package in your local collection.
Ensure the directory name matches the package name in the `Pkgfile`:

    # mkdir /usr/src/mynewcollection/hello
    # cd /usr/src/mynewcollection/hello

**Important:**
Naming consistency is critical. A mismatch between the directory
name and name in the `Pkgfile` cause build error.

##### 7.4.2.2. Writing the Pkgfile

The `Pkgfile` serves two purposes:

1. Provides build instructions for `pkgmk(8)`.
2. Supplies metadata for `pkgman(1)` to enable dependency resolution,
   search, and queries.

Example `Pkgfile`:

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

##### 7.4.2.3. Key Metadata Headers for pkgman

Include these headers in the `Pkgfile` for optimal integration with
`pkgman(1)`:

- `# Description`: Brief summary of the package.
- `# URL`: Link to official documentation or website.
- `# Depends on`: List of dependencies. `pkgman(1)` resolves and
  installs these automatically.

Without these headers, `pkgman(1)` cannot display metadata or resolve
dependencies.

##### 7.4.2.4. Verifying the Package Source

Verify your package metadata with:

    $ pkgman info hello

Expected output:

    Name:         hello
    Path:         /usr/src/mynewcollection/hello
    Version:      2.12.1
    Release:      1
    Description:  Example package based on GNU hello
    URL:          https://www.gnu.org/software/hello/
    Depends on:   glibc

If metadata is missing, review the `Pkgfile` for errors.

#### 7.4.3. Building and Installing Custom Packages

After creating a custom package source, the next step is to build and
install the package using `pkgman(1)` and `pkgmk(8)`, addressing any
potential permission issues.

##### 7.4.3.1. Building the Package

Build your custom package with:

    # pkgman install --vv --deps hello

This command:

1. Downloads source files if not cached.
2. Builds the package using `pkgmk(8)`.
3. Installs the package with `pkgadd(8)`.

**Note:**
Warnings about missing `.md5sum` and `.footprint` files like
`/usr/bin/pkgmk: ... cannot create .md5sum: Permission denied`
occur because packages are built with the unprivileged `pkgmk` user,
which has not write permissions in `/usr/src/mynewcollection`.

##### 7.4.3.2. Resolving Permissions for Build Files

There are at least two options to resolve permissions case.

- 1. Manually Updating Files.
  Navigate to the package directory and generate the files:

      # cd /usr/src/mynewcollection/hello
      # pkgmk -um   # Update .md5sum
      # pkgmk -uf   # Update .footprint

- 2. Adjusting Permissions.
  Grant write access to pkgmk using `setfacl(1)`:

      # setfacl -m u:pkgmk:rwx /usr/src/mynewcollection/hello

  Rebuild the package afterward:

      # pkgman update -fr hello

##### 7.4.3.3. Verifying Generated Files

After addressing warnings, confirm the presence of required files:

    $ ls -l /usr/src/mynewcollection/hello
    -rw-r--r--  1 pkgmk pkgmk  251 .footprint
    -rw-r--r--  1 pkgmk pkgmk   54 .md5sum
    -rw-r--r--  1 root  root   359 Pkgfile

##### 7.4.3.4. Verifying the Installation

Ensure the package is installed on your system:

    $ pkgman isinst hello

Expected output:

    package 'hello' is installed

Run:

    $ hello

Expected output:

    Hello, world!

#### 7.4.4. Building Packages from Bleeding-Edge Sources

Some packages need to be built directly from version control systems
(VCS) like Git or Subversion, instead of fixed release archives. This
section outlines two approaches: a stable approach and a bleeding-edge
approach.

##### 7.4.4.1. Stable Commit Approach

For production, pinning to a specific commit ensures consistent
builds. Example:

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

Pinning builds guarantees stability and shields against upstream
changes.

##### 7.4.4.2. Bleeding-Edge Approach

For testing, dynamically set the version to the current date
(`YYYYMMDD`) to track upstream changes. Example:

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

"Daily Updates": If the installed version is outdated, `pkgman(1)`
flags it during `pkgman diff`, prompting updates:

    $ pkgman diff
      
    -- Differences between installed packages and packages sources tree
    ruby-scm                        20250216-1          20250401-1

This approach is ideal for development but unsuitable for production
environments.

##### 7.4.4.3. Subversion Repository Download Function

For Subversion-based builds, use a download function like this:

    download_svn() {
        if [ -d $PKGMK_SOURCE_DIR/$name ]; then
            svn cleanup $PKGMK_SOURCE_DIR/$name
            svn up $PKGMK_SOURCE_DIR/$name
        else
            svn co $1 $PKGMK_SOURCE_DIR/$name
        fi
        cp -r $PKGMK_SOURCE_DIR/$name $PKGMK_WORK_DIR/src/$name
    }

Example usage in a `Pkgfile`:

    download_svn https://svn.project.org/svn/program/trunk

Include `subversion` in dependencies to ensure compatibility.
`subversion` is not part of `pkgsrc-core`, and must be declared
explicitly.

##### 7.4.4.4. Best Practices

- Use pinned commits or snapshots for stability in production.
- Reserve bleeding-edge builds for testing and development.
- Include download functions (`download_git` or `download_svn`)
  directly in `Pkgfiles` for portability.

### 7.5. Tips and Best Practices

#### 7.5.1. Renicing Builds

Package builds can reduce system responsiveness due to high CPU and
I/O usage. Mitigate this by adjusting process priorities using
`nice(1)` and `ionice(1)`:

- `nice(1)`: Lowers CPU priority (higher number = lower priority).
- `ionice(1)`: Adjusts I/O priority (class 2, priority 6 is commonly
  used).

Update the `makecommand` in `/etc/pkgman.conf`:

    makecommand sudo -H -u pkgmk nice -n10 ionice -c2 -n6 fakeroot pkgmk

Explanation:

- `nice -n10`: Reduces CPU priority (10 = relatively low).
- `ionice -c2 -n6`: Reduces I/O priority (class 2, priority 6).

These changes help the build process interfere less with interactive
tasks, improving system responsiveness.

#### 7.5.2. RAM Builds for Faster Package Compilation

Using RAM for temporary build files (tmpfs) can significantly speed up
package compilation in Zeppe-Lin.

##### 7.5.2.1. Enable RAM Builds in Zeppe-Lin

1. Uncomment this line in `/etc/fstab`:

    pkgmk /var/cache/pkgmk/work tmpfs size=<SIZE>,uid=<UID>,defaults 0 0

   Replace `SIZE` (e.g., `16G`). The `UID` for the `pkgmk` user is
   preconfigured.

2. Mount tmpfs:

     # mount pkgmk

3. Remove `-pipe` from `CFLAGS` and `CXXFLAGS` in `/etc/pkgmk.conf`.

##### 7.5.2.2. RAM Build Configuration (Educational)

For users interested in customizing the setup:

1. Creating a dedicated build user:

       # useradd -b /var/cache/ -m -s /bin/false -U pkgmk

2. Setting up build directories and assigning ownership:

       # mkdir -p /var/cache/pkgmk/{sources,packages,work}
       # chown -R pkgmk:pkgmk /var/cache/pkgmk/{sources,packages,work}

3. Configuring `tmpfs` in `/etc/fstab`:

       pkgmk /var/cache/pkgmk/work tmpfs size=<SIZE>,uid=<UID>,defaults 0 0

4. Setting the work directory in `/etc/pkgmk.conf`:

       PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name"

5. Removing `-pipe` from `CFLAGS` and `CXXFLAGS` in `/etc/pkgmk.conf`.

#### 7.5.3. Unprivileged Builds in Zeppe-Lin

Zeppe-Lin builds packages as an unprivileged user (typically `pkgmk`)
by default. This secure and modular setup isolates the build process
to mitigate risks. **If you are using Zeppe-Lin, these steps are
already configured out of the box. There is no need to repeat them.**

However, this guide is provided for educational purposes, to show how
it was achieved, or for users wanting to adapt this approach for other
distributions or customizations.

1. Create a Dedicated Build User.
   A restricted user is used to perform package builds securely:

       # useradd -b /var/cache/ -m -s /bin/false -U pkgmk

   This creates a user and group named `pkgmk` with limited shell
   access.

2. Set Up Build Directories.
   Directories for sources, packages, and temporary files are created
   and assigned ownership to the `pkgmk` user:

       # mkdir -p /var/cache/pkgmk/{sources,packages,work}
       # chown -R pkgmk:pkgmk /var/cache/pkgmk/{sources,packages,work}

3. Configure `pkgmk`.
   In `/etc/pkgmk.conf`, the paths for these directories are defined:

       PKGMK_SOURCE_DIR="/var/cache/pkgmk/sources"
       PKGMK_PACKAGE_DIR="/var/cache/pkgmk/packages"
       PKGMK_WORK_DIR="/var/cache/pkgmk/work/$name-$$"

4. Integrate `pkgman`.
   In `/etc/pkgman.conf`, the `makecommand` variable is updated to run
   `pkgmk(8)` as the unprivileged `pkgmk` user via `sudo(8)` and
   `fakeroot(1)`:

       makecommand sudo -H -u pkgmk fakeroot pkgmk

This structure ensures package builds are securely isolated while
remaining flexible for adaptations.

## 8. CONFIGURATION

### 8.1. Generating Locales

In Zeppe-Lin, `glibc` package includes a minimal set of locales by
default, with `C.UTF-8` generated for compatibility with `pkgmk(8)`.
To create additional locales, replace `en_US` with your desired locale
and run:

    # localedef -i en_US -f UTF-8 en_US.UTF-8

Set the system default locale by adding it to `/etc/profile`:

    export LANG=en_US.UTF-8

This ensures consistent locale settings across your system.

### 8.2. Initialization Scripts

Zeppe-Lin uses a BSD-style init system to manage startup, services,
and shutdown. It relies on shell scripts in `/etc` and `/etc/rc.d`,
configured through files like `/etc/rc.conf` and `/etc/inittab`,
offering a simple and efficient way to control processes.

#### 8.2.1. Runlevels

Runlevels define the system's operating state and are configured in
`/etc/inittab`. Zeppe-Lin uses these runlevels:

| Runlevel | Description      |
| -------- | ---------------- |
| 0        | Halt             |
| 1 (S)    | Single-User Mode |
| 2        | Multi-User Mode  |
| 3-5      | (Not Used)       |
| 6        | Reboot           |

Runlevels manage system states during startup, runtime, and shutdown.
See `inittab(5)` for details.

#### 8.2.2. Layout

Zeppe-Lin uses a BSD-style init system with these key files:

| File             | Description                     |
| ---------------- | ------------------------------- |
| /etc/rc          | System boot script              |
| /etc/rc.single   | Single-user startup script      |
| /etc/rc.multi    | Multi-user startup script       |
| /etc/rc.modules  | Module initialization script    |
| /etc/rc.local    | Local multi-user startup script |
| /etc/rc.shutdown | System shutdown script          |
| /etc/rc.conf     | System configuration file       |
| /etc/rc.d/       | Service start/stop directory    |
| /etc/inittab     | System runlevel configuration   |

Customize system behavior by editing:

- `/etc/rc.local`: Add custom commands for multi-user mode.
- `/etc/rc.modules`: Manage kernel module loading during boot.
- `/etc/rc.conf`: Configure hostname, timezone, services, etc.

See `rc.conf(5)` and `rc(8)` for more information.

#### 8.2.3. The Role of `/etc/inittab`

The foundation of Zeppe-Lin's init system lies in the traditional
SysVinit, configured through the `/etc/inittab` file.  This file
directs the `init` process, the first process started by the kernel,
on how to manage the system at various operational stages.

Before we examine the specific entries in Zeppe-Lin's `/etc/inittab`,
it's helpful to understand the general format of each line. An entry
typically follows this structure: `id:runlevels:action:command`.

* `id`: A unique identifier for the entry (usually 2-4 characters).
* `runlevels`: Specifies the runlevels in which the command should be
  executed (can be a single digit, multiple digits, or special
  characters like `S`).
* `action`: Defines when the command should be executed (e.g.,
  `sysinit` for system initialization, `wait` to wait for the command
  to complete, `respawn` to restart the command if it terminates).
* `command`: The command to be executed.

Here's a typical configuration found in Zeppe-Lin:

    #
    # /etc/inittab: system runlevel description
    #
    # See inittab(5) for more information.
    #
    
    # Runlevels:
    #  0     Halt
    #  1(S)  Single-user
    #  2     Multi-user
    #  3-5   Not used
    #  6     Reboot
    
    # id:runlevels:action:command
    
    id:2:initdefault:
    
    rc::sysinit:/etc/rc
    rs:S1:wait:/etc/rc.single
    rm:2:wait:/etc/rc.multi
    rd:06:wait:/etc/rc.shutdown
    su:S:wait:/sbin/sulogin -p
    
    c1:2:respawn:/sbin/agetty --noclear 38400 tty1 linux
    c2:2:respawn:/sbin/agetty 38400 tty2 linux
    c3:2:respawn:/sbin/agetty 38400 tty3 linux
    c4:2:respawn:/sbin/agetty 38400 tty4 linux
    c5:2:respawn:/sbin/agetty 38400 tty5 linux
    c6:2:respawn:/sbin/agetty 38400 tty6 linux
    #s1:2:respawn:/sbin/agetty 38400 ttyS0 vt100
    
    ca::ctrlaltdel:/sbin/shutdown -t3 -r now
    pf::powerfail:/sbin/shutdown -t3 -h now
    
    # vim: ft=inittab nospell
    # End of file.

These key entries in `/etc/inittab` define the following system's
behavior:

* `id:2:initdefault`: Sets the default runlevel to `2` (Multi-user
  mode), the standard operating state for Zeppe-Lin.

* `rc::sysinit:/etc/rc`: Executes the primary system initialization
  script, `/etc/rc`, once at boot.  This script orchestrates the
  subsequent boot process.

* `rs:S1:wait:/etc/rc.single`: Defines the actions for single-user
  mode (runlevel `1` or `S`), executing `/etc/rc.single` and waiting
  for its completion.

* `rm:2:wait:/etc/rc.multi`: Defines the actions for multi-user mode
  (runlevel `2`), executing `/etc/rc.multi`, which is responsible for
  starting most system services.

* `rd:06:wait:/etc/rc.shutdown`: Defines the actions for shutdown
  (runlevel `0`) and reboot (runlevel `6`), executing
  `/etc/rc.shutdown` to manage service termination.

* `su:S:wait:/sbin/sulogin -p`: Provides a login prompt for the root
  user in single-user mode.

* `c1-c6:2:respawn:/sbin/agetty ...`: Sets up virtual consoles (TTYs)
  accessible via Ctrl+Alt+F1 through F6, ensuring a login prompt
  (`agetty`) is always available.

* `ca::ctrlaltdel:/sbin/shutdown -t3 -r now`: Configures the system to
  reboot after a 3-second delay when Ctrl+Alt+Delete is pressed.

* `pf::powerfail:/sbin/shutdown -t3 -h now`: Configures the system to
  halt after a 3-second delay upon detecting a power failure.

#### 8.2.4. Automatic Kernel Module Loading

Zeppe-Lin loads kernel modules at boot via `/etc/rc.modules`. This
script runs `/sbin/depmod -a` first to manage dependencies.

To load modules automatically, add `/sbin/modprobe` commands to
`/etc/rc.modules`. For example:

    /sbin/modprobe virtio_net

##### 8.2.4.1. Specifying Module Parameters

You can add parameters directly in `/etc/rc.modules` using
`/sbin/modprobe`. Example:

    /sbin/modprobe snd_hda_intel probe_mask=8

If reloading manually after boot, include parameters:

    # modprobe -r snd_hda_intel
    # modprobe snd_hda_intel probe_mask=8

Alternatively, define parameters in `/etc/modprobe.d/` (e.g.,
`/etc/modprobe.d/snd-hda-intel.conf`):

    options snd_hda_intel probe_mask=8

When using `/etc/modprobe.d/`, reloading is simpler as parameters are
applied automatically:

    # modprobe -r snd_hda_intel
    # modprobe snd_hda_intel

Using `/etc/modprobe.d/` ensures consistent parameter management
across boot and manual reloading. Changes to `/etc/rc.modules` and
`/etc/modprobe.d/` take effect on the next boot.

### 8.3. Networking

#### 8.3.1. Hostname Configuration

The hostname identifies your system on the network.

To set it temporarily, use:

    # hostname <new_hostname>

For a permanent setting, edit `/etc/rc.conf` and set:

    HOSTNAME='<new_hostname>'

For proper network function, edit `/etc/hosts` and add your hostname
to the loopback lines:

    # /etc/hosts
    127.0.0.1 localhost <new_hostname>
    ::1 localhost <new_hostname>

This ensures your system recognizes its own name.

#### 8.3.2. Static Address

To configure a static IP, edit `/etc/rc.d/net`. Set the network
interface, IP, subnet mask, and gateway. For example:

    DEV=enp11s0
    ADDR=192.168.1.100
    MASK=24
    GW=192.168.1.1

Set DNS in `/etc/resolv.conf`:

    search <your internal domain>
    nameserver <your DNS server>

Start, stop or restart the service via:

    # /etc/rc.d/net [start|stop|restart]

**Important:**
To auto-start service at boot, add `net` to the `SERVICES` line in
`/etc/rc.conf`.

#### 8.3.3. Dynamic Address

To get an IP address automatically via DHCP, install the `dhcpcd`
package and edit `/etc/rc.d/dhcpcd` to specify the network interface
(e.g., `enp5s0`):

    DEV=enp5s0

Start, stop, or restart the service via:

    # /etc/rc.d/dhcpcd [start|stop|restart]

Check `dhcpcd`'s README for potential issues:

    $ pkgman readme dhcpcd

**Important:**
To auto-start service at boot, add `dhcpcd` to the `SERVICES` line in
`/etc/rc.conf`.

#### 8.3.4. Wireless Network

Ensure the wireless interface isn't blocked. Use `rfkill(8)`:

    $ rfkill list
    # rfkill unblock <ID|TYPE>

Install the `wpa-supplicant` package and edit
`/etc/rc.d/wpa_supplicant` to set the wireless interface:

    DEV=wlp1s0

Update `/etc/wpa_supplicant.conf` based on your network:

##### 8.3.4.1. WPA-PSK (Pre-Shared Key)

Generate a key with `wpa_passphrase(8)`:

    # wpa_passphrase <MYSSID> <PASSPHRASE>

Example `/etc/wpa_supplicant.conf`:

    network={
        ssid="YOUR_NETWORK_NAME"
        psk="THE_GENERATED_KEY"
    }

##### 8.3.4.2. WPA-EAP (Enterprise)

Generate a password hash:

    # echo -n <PASSPHRASE> | iconv -t utf16le | openssl md4

Example `/etc/wpa_supplicant.conf`:

    network={
        ssid="YOUR_NETWORK_NAME"
        key_mgmt=WPA-EAP
        identity="YOUR_USERNAME"
        password=hash:<YOUR_PASSWORD_HASH>
    }

##### 8.3.4.3. WEP

Example `/etc/wpa_supplicant.conf` for WEP:

    network={
        ssid="YOUR_NETWORK_NAME"
        key_mgmt=NONE
        wep_key0="YOUR_WEP_KEY"
        wep_tx_keyidx=0
        auth_alg=SHARED
    }

For automatic IP, ensure the wireless interface is set in
`/etc/rc.d/dhcpcd`. Start the services:

    # /etc/rc.d/wpa_supplicant start
    # /etc/rc.d/dhcpcd start

**Important:**
To auto-start service at boot, add `wpa_supplicant` (and `dhcpcd` if
using dynamic IP) to the `SERVICES` line in `/etc/rc.conf`.

###  8.4. Time and Date Configuration

#### 8.4.1. Timezone Setup

Identify your timezone from `/usr/share/zoneinfo` (e.g.,
`America/New_York`).

Set the timezone immediately:

    # ln -sfn /usr/share/zoneinfo/<Your_Timezone> /etc/localtime

Verify the symbolic link:

    # ls -l /etc/localtime

To make it persistent, add the timezone to `/etc/rc.conf`:

    TIMEZONE='<Your_Timezone>'

#### 8.4.2. System Clock Setup

Manually set the system clock:

    # date MMDDhhmmYYYY.ss

Example:

    # date 032705352025.00

For accuracy, use NTP (described next).

#### 8.4.3. Network Time Protocol (NTP) Configuration

**Note:**
Accurate time via NTP is crucial for time-sensitive things like OTP.

Use an NTP client, such as `chrony`, to synchronize the system clock.

After installing `chrony`, start the service:

    # /etc/rc.d/chrony start

**Important:**
To enable automatic startup, add `chrony` to the `SERVICES` line in
`/etc/rc.conf`.

### 8.5. User Authentication and Environment

This section explains Zeppe-Lin's approach to user authentication,
environment setup, and PAM (Pluggable Authentication Modules).

#### 8.5.1. Password Management

Zeppe-Lin uses strong password encryption with `SHA512` for secure
user accounts.

Applications requiring user authentication via `crypt(3)` must link
against libcrypt (`-lcrypt`). Zeppe-Lin's `libcrypt` supports `SHA512`
and older encryption methods like `DES`.

#### 8.5.2. User Environment Configuration

User account creation via `useradd(8)` is governed by
`/etc/login.defs`.  Key settings include:

- `CREATE_HOME`: Determines whether a home directory is created for
  new users.
- `USERGROUPS_ENAB`: Controls how group memberships are managed for
  new users.

Zeppe-Lin follows a minimalist approach -- home directories created
with `useradd -m` are empty by default. Customize user environments
by:

- Using `/etc/skel` for default home directory contents.
- Changing the default shell.
- Modifying the `PATH` or environment variables.

Default shell `PATH` (via `/etc/profile`) is set to
`/sbin:/usr/sbin:/bin:/usr/bin`.  This allows access to administrative
commands (e.g., `sudo(8)`) without specifying full paths.

#### 8.5.3. Pluggable Authentication Modules (PAM)

Zeppe-Lin uses PAM (`linux-pam` package) for flexible user
authentication. PAM's configuration files are in `/etc/pam.d/`, where
each file corresponds to a specific login service.

Common PAM modules include:

- `pam_dumb_runtime_dir.so`: Creates `XDG_RUNTIME_DIR` for desktop
  apps (freedesktop.org). Ensure it's active in
  `/etc/pam.d/common-session` during system upgrades.

- `pam_env.so`: Sets and exports environment variables at login.

- `pam_limits.so`: Configures resource limits (e.g., max open files).

For advanced configurations, consult module-specific man pages (e.g.,
`man pam_env`).

## 9. FAQ

1. Why is the distribution named Zeppe-Lin?

   It's our 'Whole Lotta Love' for Linux and GNU, just renamed!

2. I've looked everywhere, but I can't find the Zeppe-Lin installation
   CD/DVD. Did I miss something?

   Ah, the elusive Zeppe-Lin installation disc! Fear not, intrepid
   user, your eyesight is likely just fine. You see, Zeppe-Lin is so
   cutting-edge, so **minimal**, that it decided to ditch physical
   media altogether!

   Instead of hunting for a shiny disc, you embark on a digital
   treasure hunt to download the root filesystem. Think of it as our
   way of saving trees... or maybe we just figured you already have a
   perfectly good Live CD lying around.

   So, no, you didn't miss it. There's no disc. Now, about that rootfs
   download...
   (See [2.4.1. Download Rootfs Tarball](#241-download-rootfs-tarball))

## 10. REPORTING BUGS

For bug reports regarding this handbook, please use the issue tracker
at <https://github.com/zeppe-lin/zeppe-lin.github.io/issues>.

## Appendix A: Legal Notices

This appendix outlines the legal and licensing information for
Zeppe-Lin, including copyrights, licenses, and disclaimers.

### A.1 Software Licenses

Zeppe-Lin integrates open-source software projects, each with its own
license. For licensing details, consult the source code of the
respective packages included in your system.

### A.2 Build Scripts Licensing

Zeppe-Lin build scripts retain their original licensing structure and
are attributed to:

- Copyright (C) 2000-2021 by Per Lidén <mailto:per@fukt.bth.se> and
  the CRUX Team <http://crux.nu>.

- Copyright (C) 2022-2025 by Alexandr Savca
  <mailto:alexandr.savca89@gmail.com> and the Zeppe-Lin Team
  <https://zeppe-lin.github.io>.

These scripts are released under the GNU General Public License
version 3 or later (GPLv3+) <https://gnu.org/licenses/gpl.html>.

### A.3 Handbook Licensing

The Zeppe-Lin Handbook, an original work by Alexandr Savca and the
Zeppe-Lin Team, is licensed under the
Creative Commons Attribution-ShareAlike 3.0 Unported License
<https://creativecommons.org/licenses/by-sa/3.0/>.

### A.4 Disclaimer

Zeppe-Lin and its documentation are distributed "AS IS" without
warranty of any kind. This includes, but is not limited to, implied
warranties of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. All
usage is at your own risk.

