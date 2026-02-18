---
title: Zeppe-Lin Codebook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

> **Important:**
> This Codebook is a living draft.
> It represents early ideas, practices, and workflows for Zeppe-Lin
> development.
> Expect gaps, rough edges, and future refinements.

Zeppe-Lin Codebook.  
*Because even pirates need a map to find the treasure  
(and avoid the kraken).*

This document exists for maintainers and contributors who need to
understand how Zeppe-Lin is developed, built, and released.
It favors clarity over ceremony, and reproducibility over automation.

# Introduction

Zeppe-Lin is a source-based system that values simplicity, explicit
control, and technical honesty.

This Codebook describes:

- maintainer rules and boundaries
- how releases are prepared
- how the base system and root filesystem are built
- how releases are published

It intentionally avoids tooling abstractions that hide real work.
If a process can be done with standard tools, it should be.

# Maintainer Principles

All contributors to Zeppe‑Lin must follow these rules.
They are binding, enforceable, and exist to preserve simplicity,
transparency, and user control.

1. **Respect User Choice**  
   Pkgfiles, scripts, and automation must honor user configuration and
   environment.
   Mandatory tools, forced compiler flags, or hidden overrides outside
   the base system are prohibited.

2. **Transparency and Predictability**  
   All operations must be explicit, auditable, and reproducible.
   Hidden automation or background behavior is forbidden.

3. **Minimal and Practical Dependencies**  
   Only dependencies strictly required for correctness are allowed.
   Optional tools, extensions, or enhancements must never be imposed.

4. **Compartmentalization**  
   Changes in one layer (core, system, xorg, desktop)
   must not break others.
   Each collection has clear boundaries; cross-layer side effects are
   forbidden.

5. **Accountability**  
   Any maintainer violating these principles can be challenged by the
   team.
   Enforcement exists to keep the system understandable, maintainable,
   and reliable over time.

# Release Model and Versioning

XXX
This is a short conceptual chapter explaining:

    Semi-rolling model

    Toolchain-stable cycles

    Minor vs major releases

    “Released when ready”

This chapter answers “what kind of release am I preparing?” before any work begins.
XXX

Zeppe-Lin follows a semi-rolling model:

- The toolchain is kept stable for long periods.

- Userland evolves gradually on top of it.

- When accumulated changes become disruptive, a new minor release is
  made.

- When the toolchain must change, a new major release branch is
  created.

Releases happen when ready, not on a schedule.

# Release Preparation Workflow

A release consists of four clearly separated phases:

- Branching
- Toolchain update (if required)
- System rebuild and rootfs creation
- Publication and announcement

Each phase must complete cleanly before the next begins.

# Repository Branching

Before any release work begins, create release branches.

Repositories involved:

- `pkgsrc-core`
- `pkgsrc-system`
- `pkgsrc-xorg`
- `pkgsrc-desktop`

Branch naming:

- `1.x` for all 1.x releases
- `2.x` for all 2.x releases

Example:

```sh
git checkout 0.x    # current stable branch
git checkout -b 1.x # new branch
git push origin 1.x
```

All release-related commits must land on the release branch only.

# Toolchain Updates (When Required)

Toolchain updates only occur when necessary.

Required rebuild order:

1. `glibc` / `glibc-32`
2. `binutils`
3. `gcc`
4. `libtool`
5. rebuild `binutils`
6. rebuild `glibc` / `glibc-32`
7. rebuild `libtool`

> **Note:**
>
> 0. `linux-headers` (when we'll be ready)

Command example:

```sh
pkgman update -fr -d --group \
    glibc{,-32} binutils gcc libtool \
    binutils glibc{,-32} libtool
```

Afterward, build and test several core packages to validate the
toolchain.

# Building the Zeppe-Lin Root Filesystem

Root filesystem images are built manually and explicitly.
No wrapper tools are used.

The build is always done in two stages.

## Stage 1: Base RootFS

Stage 1 provides a minimal, bootstrappable filesystem.

### Option A: Build from Existing Zeppe-Lin System

```sh
ROOTFS_STAGE1=/mnt/rootfs-stage1

# as root
mkdir -p $ROOTFS_STAGE1/var/lib/pkg
touch $ROOTFS_STAGE1/var/lib/pkg/db
pkgman install \
  --root=$ROOTFS_STAGE1 \
  --config-append="runscripts no" \
  --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")
```

### Option B: Use Published Stage 1 RootFS

Download from:  
<https://github.com/zeppe-lin/pkgsrc-core/releases/latest>

Extract:

```sh
tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
  rootfs-${VERSION}-x86_64.tar.xz -C $ROOTFS_STAGE1
```

## Entering the Chroot

```sh
cp /etc/resolv.conf $ROOTFS_STAGE1/etc/resolv.conf


mount -B /dev $ROOTFS_STAGE1/dev
mount -B /run $ROOTFS_STAGE1/run
mount -t proc proc $ROOTFS_STAGE1/proc
mount -t sysfs none $ROOTFS_STAGE1/sys
mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 devpts \
$ROOTFS_STAGE1/dev/pts


chroot $ROOTFS_STAGE1 /bin/bash
```

## Stage 2: Rebuild Core System

```sh
# in chroot, as root
cd /usr/src
git clone https://github.com/zeppe-lin/pkgsrc-core --branch 1.x


pkgman update -fr -d $(pkgman printf "%n\n")
```

Verify:

```sh
# in chroot, as root

# Zeppe-Lin Release Process (Overview)

Releasing a new version of Zeppe-Lin is like preparing an airship for
its next journey.  Here's the streamlined process:

- **Branching**:
  Create new release branches in package source repositories.

- **Toolchain Update**:
  Refresh and rebuild core build tools in `pkgsrc-core`.

- **Package Updates**:
  Update software sources in `pkgsrc-core`, `pkgsrc-system`,
  `pkgsrc-xorg`, and `pkgsrc-desktop`.

- **Rootfs Assembly**:
  Build and verify the system image using `mkrootfs`.

- **Finalize Assets**:
  Sign the rootfs image and tag the release in Git.

- **Prepare Announcements**:
  Prepare release notes and website assets.

- **Publish Release**:
  Announce and publish the release on GitHub and the Zeppe-Lin
  website.

- **Post-Release Tasks**:
  Update documentation, announce on discussions, monitor feedback.

**Key Repositories**:

- **Software sources collections**:
  - `pkgsrc-core.git`
  - `pkgsrc-system.git`
  - `pkgsrc-xorg.git`
  - `pkgsrc-desktop.git`
- **Website & announcements**:
  - `zeppe-lin.github.io.git`
- **Release visuals**:
  - `artwork.git`

This codebook will guide you through each step.
Let's get Zeppe-Lin ready for takeoff!

# Creating a Zeppe-Lin Release

## Preparation

### Branching Strategy for Package Source Repositories

Before updating your toolchain or other package sources, create new
branches in these repositories to keep changes separate from stable
releases:

- `pkgsrc-core.git`
- `pkgsrc-system.git`
- `pkgsrc-xorg.git`
- `pkgsrc-desktop.git`

This approach also applies to unofficial repositories.

**General Approach**:

- **For 1.x (pre-2.0) releases**:
  Name the branch `1.x` (for example, for releases 1.0, 1.1, 1.2).

- **For 2.x and later**:
  Name the branch after the major version (e.g., `2.x`).

**Creating a New Branch**:

1. Identify the target major version (e.g., 1.0).

2. From the current stable branch, run:

   ```sh
   git checkout <current_stable_branch>
   git checkout -b <new_branch>
   git push origin <new_branch>
   ```

   For example, if the last stable release is 0.9 on branch `0.x`,
   create branch `1.x` like this:

   ```sh
   git checkout 0.x
   git checkout -b 1.x
   git push origin 1.x
   ```

This strategy keeps the new release work isolated from stable code.

### Using pkgsrcfeeds to Track Package Updates (Optional)

The `pkgsrcfeeds.git` repository gathers update information from all
Zeppe-Lin pkgsrc collections into one helpful feed.  Use your favorite
feed reader (like `snownews`) to quickly spot new or changed packages.

If an update shows a missing dependency, add it to the appropriate
pkgsrc repository and update the helper repository accordingly.  It
also provides scripts to check for consistency and flag any issues.

In short, `pkgsrcfeeds` handles the tracking for you, letting you
focus on the software you want to update.

## Updating Pkgsrc Repositories and Building the Core System

### Core Toolchain Update (pkgsrc-core)

Before updating other packages, refresh the core toolchain for a
fresh, stable base.  Follow this build order:

- **Build**: `linux-headers` (skip, it's bundled with `glibc` at least now)
- **Build**: `glibc` and `glibc-32`
- **Build**: `binutils`
- **Build**: `gcc`
- **Build**: `libtool`
- **Rebuild**: `binutils`
- **Rebuild**: `glibc` and `glibc-32`
- **Rebuild**: `libtool`

**Why This Order**?
`gcc` depends on `binutils`, and both rely on the system libraries
from `glibc`.  Multiple passes guarantee that every component is built
against its latest dependencies.

**Steps to Update and Build**:

1. **Navigate to pkgsrc-core**:
   Open your terminal and head to your local clone.

2. **Checkout the Release Branch**:
   Switch to your release branch (e.g., `1.x`).

3. **Update Package Definitions**:
   Update the `Pkgfile`, `.md5sum`, and `.footprint` files for
   `glibc`, `glibc-32`, `binutils`, `gcc`, and `libtool` with the new
   versions.

4. **Build the Toolchain**:
   Run the following command, which follows the build order above:

   ```sh
   pkgman update -fr -d --group \
       glibc{,-32} binutils gcc libtool \
       binutils glibc{,-32} libtool
   ```

5. **Test Extensively**:
   After the build, compile other core packages or create a rootfs
   archive to ensure everything runs smoothly.

If you encounter any build failures, linker errors, or runtime issues,
review the logs and consult relevant resources for assistance (e.g.,
Linux From Scratch documentation).

### Standard Package Updates

Once the toolchain is updated, refresh package definitions across your
pkgsrc repositories.  Begin with `pkgsrc-core` to ensure core packages
reflect the latest upstream changes.  Then update `pkgsrc-system`,
followed by `pkgsrc-xorg`, and finally `pkgsrc-desktop`.

For each package, update the version, checksums, footprint, and any
needed patches.  Commit your changes with a clear message (e.g.,
`<package>: <old_version> -> <new_version>`) and push them to the
remote repository.

# Building a Zeppe-Lin Root Filesystem

This chapter describes how Zeppe-Lin root filesystem tarballs are
created. The same procedure is used for official releases and for
developer testing.

The process is intentionally simple and reproducible. No special build
tools are required beyond the standard Zeppe-Lin toolchain.

At a high level, the build consists of two stages:

- **Stage 1** creates or obtains a minimal root filesystem suitable
  for chrooting.

- **Stage 2** rebuilds the complete base system and produces release
  artifacts.

## Stage 1: Obtaining a Base RootFS

Stage 1 provides a bootstrappable environment with a valid package
database.
There are two supported approaches.

### Building Stage 1 from an Existing Zeppe-Lin System

On a working Zeppe-Lin installation:

```sh
# as root
ROOTFS_STAGE1=/mnt/rootfs-stage1

mkdir -p $ROOTFS_STAGE1
touch $ROOTFS_STAGE1/var/lib/pkg/db
```

Populate the root filesystem with the currently installed
`pkgsrc-core` packages:

```sh
# as root
pkgman install \
  --root=$ROOTFS_STAGE1 \
  --config-append="runscripts no" \
  --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")
```

This method is convenient for local development and testing.

### Using a Published Stage 1 RootFS

Official Stage 1 rootfs tarballs are published alongside `pkgsrc-core`
releases:

<https://github.com/zeppe-lin/pkgsrc-core/releases/latest>

Extract the tarball:

```sh
ROOTFS_STAGE1=/mnt/rootfs-stage1
sudo mkdir -p $ROOTFS_STAGE1

sudo tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
  rootfs-${VERSION}-x86_64.tar.xz -C $ROOTFS_STAGE1
```

This approach avoids dependency on a local Zeppe-Lin installation and
is preferred for reproducible release builds.

## Preparing the Chroot Environment

Before entering the rootfs, basic system services must be available
inside the chroot.

Copy DNS configuration to allow network access:

```sh
# as root
cp /etc/resolv.conf $ROOTFS_STAGE1/etc/resolv.conf
```

Mount required pseudo-filesystems:

```sh
# as root
mount -B /dev  $ROOTFS_STAGE1/dev
mount -B /run  $ROOTFS_STAGE1/run
mount -t proc  proc  $ROOTFS_STAGE1/proc
mount -t sysfs none  $ROOTFS_STAGE1/sys
mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 \
  devpts $ROOTFS_STAGE1/dev/pts
```

`/run` is not strictly mandatory, but recommended.
Several tools assume its presence and may fail or behave
inconsistently without it.

Enter the chroot:

```sh
# as root
chroot $ROOTFS_STAGE1 /bin/bash
```

Inside the chroot, set a root password and adjust the prompt for
clarity:

Inside the chroot, set a root password and adjust the prompt for
clarity:

```sh
# inside chroot, as root
passwd root
export PS1="(chrooted) $PS1"
```

## Stage 2: Rebuilding the Base System

Stage 2 rebuilds the entire base system inside the chroot, ensuring
that all binaries and libraries are produced in a controlled
environment.

Clone the `pkgsrc-core` collection:

```sh
# inside chroot, as root
cd /usr/src
git clone https://github.com/zeppe-lin/pkgsrc-core --branch 1.x
```

Rebuild all core packages:

```sh
# inside chroot, as root
pkgman update -fr -d $(pkgman printf "%n\n")
```

If a build fails, logs can be inspected in
`/var/log/pkgbuild/<package>`.

After the rebuild, verify that no shared library dependencies are
missing:

```sh
# inside chroot, as root
revdep
```

A clean Stage 2 build should report no unresolved dependencies.

## Assembling the Release RootFS

Once the system has been rebuilt successfully, a clean rootfs is
assembled from the rebuilt packages.

Initialize the release rootfs directory:

```sh
# inside chroot, as root
VERSION=v1.2 # New release version, example
ROOTFS_STAGE2=/tmp/rootfs-$VERSION-x86_64

mkdir -p $ROOTFS_STAGE2/var/lib/pkg
touch $ROOTFS_STAGE2/var/lib/pkg/db
```

Populate it using the rebuilt packages:

```sh
# inside chroot, as root
pkgman install \
  --root=$ROOTFS_STAGE2 \
  --config-append="runscripts no" \
  --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")
```

The install transaction must complete without errors.

## Create Release Artefacts

Compress the final root filesystem:

```sh
# inside chroot, as root
tar -cJf /tmp/rootfs-$VERSION-x86_64.tar.xz \
  -C $ROOTFS_STAGE2 .
```

The trailing dot is required to preserve the correct directory layout
inside the archive.

Create the binary package archive:

```sh
# inside chroot, as root
tar -cJf /tmp/binpkgs-$VERSION-x86_64.tar.xz \
  -C /var/cache/pkgmk/packages .
```

## Exiting the Chroot and Cleanup

Exit the chroot:

```sh
# inside chroot, as root
exit
```

Unmount all mounted filesystems:

```sh
# as root
umount -R $ROOTFS_STAGE1/dev
umount -R $ROOTFS_STAGE1/proc
umount -R $ROOTFS_STAGE1/sys
umount -R $ROOTFS_STAGE1/run
```

The resulting artifacts are now available in:

```sh
$ROOTFS_STAGE1/tmp/
```

- `rootfs-$VERSION-x86_64.tar.xz`
- `binpkgs-$VERSION-x86_64.tar.xz`

## Optional: Signing Release Files

For official releases, artifacts may be signed:

```sh
cd $ROOTFS_STAGE1/tmp

gpg --detach-sign --armor rootfs-$VERSION-x86_64.tar.xz
gpg --detach-sign --armor binpkgs-$VERSION-x86_64.tar.xz
```

### Building the Root Filesystem

This section describes how to build a Zeppe‑Lin root filesystem
(rootfs) in two stages.
You can either build directly on a running Zeppe‑Lin instance or
download a prebuilt rootfs tarball.

Once the toolchain and packages are updated, you can create the root
filesystem image -- Zeppe-Lin's core for chroot installations.

#### Introducing mkrootfs

`mkrootfs` automates building a custom root filesystem by:

- **Installing Packages**:
  It calls `pkgman(1)` to build and install the required packages.

- **Checking Integrity**:
  It calls `revdep(1)` to scan for broken shared libraries.

Configuration is handled in `/etc/mkrootfs/config`, where you can set:

- `ROOTFS_DIR`:
  The working directory (default: `/tmp/rootfs-$(date +%F)-$(uname -m)/`).

- `PACKAGES`:
  The list of packages to install (default: `pkgsrc-core` set).

- `ROOTFS_TAR`:
  The output tarball filename (default: `$ROOTFS_DIR.tar.xz`).

You can override these settings with command-line options (see
`mkrootfs(8)`).

##### Step-by-Step Rootfs Creation

1. **Configure**:
   Edit `/etc/mkrootfs/config` (as root) and set:

   - `ROOTFS_DIR` (working directory)
   - `ROOTFS_TAR` (output tarball name)
   - `PACKAGES` (default: all packages from `pkgsrc-core`)

   Save your changes.  Alternatively, you can override configuration
   settings on the fly using command-line options (refer to
   `mkrootfs(8)` for details).

2. **Build**:
   Run the command below to prepare the filesystem, check
   dependencies, and create the tarball:

   ```sh
   sudo mkrootfs -BCTv
   ```

   This does the following:

   - `-B`: Builds the filesystem directory.
   - `-C`: Scan for broken shared libraries.
   - `-T`: Compress the directory into a tarball.
   - `-v`: Be verbose.

##### Optional Cleanup

Once you've verified the tarball, you can remove temporary build
artifacts to save space.  For example:

```sh
sudo rm -rf /tmp/rootfs-*-$(uname -m){,.log}
```

Skip cleanup if you need to debug or perform incremental builds.

### Finalizing Release Assets

#### Signing the Rootfs Tarball

Sign your root filesystem tarball with GPG to prove its authenticity
and integrity.  Make sure GPG is installed (e.g., with
`sudo pkgman install --deps --group gnupg`) and that you have your
official Zeppe-Lin private key secured with a strong passphrase.

**Steps**:

1. **Navigate to the Tarball Directory**:
   Go to the directory where your tarball (e.g.,
   `rootfs-v1.0-x86_64.tar.xz`) resides.

2. **Sign the Tarball**:
   Create a detached, ASCII-armored signature:

   ```sh
   gpg --detach-sig --armor --output   \
         rootfs-v1.0-x86_64.tar.xz.sig \
         rootfs-v1.0-x86_64.tar.xz
   ```

   You'll be prompted for your key's passphrase.

3. **Verify the Signature (Optional)**:
   Confirm the signature is valid:

   ```sh
   gpg --verify rootfs-v1.0-x86_64.tar.xz.sig \
                rootfs-v1.0-x86_64.tar.xz
   ```

After these steps, your signed tarball and its signature file are
ready for distribution.

#### Creating a Git Tag in pkgsrc-core

Once all package updates, configuration changes, and build scripts for
the release are committed and pushed to your release branch (e.g.,
`1.x`) in `pkgsrc-core` and other relevant repositories, mark the
release with a Git tag.  This tag serves as the permanent reference
for the Zeppe-Lin release and is required for the GitHub release step.

**Steps**:

1. **Switch to the Release Branch**:
   Make sure you're on and up-to-date with your release branch:

   ```sh
   git checkout 1.x # Replace 1.x with your release branch
   git pull origin 1.x
   ```

   *Ensure all commits relevant to this release have been pushed to
   this branch.*

2. **Create an Annotated Tag**:

   ```sh
   git tag -a v1.0 -m "Zeppe-Lin v1.0 - The Maiden Voyage!"
   ```

3. **Push the Tag**:
   Push the new tag to the remote repository:

   ```sh
   git push origin v1.0
   ```

   Or push all local tags (be cautious with this command if you have
   other local tags):

   ```sh
   git push origin --tags
   ```

**Notes**:

- Use a consistent naming convention (e.g., prefix with `v` followed
  by the version number).
- Once pushed, tags are considered immutable -- review carefully
  before tagging.

This simple process officially marks the source code state for your
release.

### Preparing and Publishing Announcements

#### Drafting Release Notes Content

Release notes communicate what's new, changed, and required for
upgrading.  They will form the official website release notes and the
GitHub Release description.

Include the following:

- **Introduction**:
  A brief overview (version, date, theme).

- **Incompatible Changes**:
  List any breaking changes or adjustments needed for upgrades.

- **New Features**:
  Highlight new functionalities and improvements.

- **Package Changes**:
  Summarize package updates for each repository (added, removed,
  updated).

- **Artwork**:
  Describe the release's visual design, including a link and licensing
  info if necessary (see the banner created in 3.4.2.2).

- **Kernel & Toolchain**:
  Specify the Linux kernel version and list core toolchain components
  (e.g., `glibc`, `gcc`, `binutils`).  Include X11 details if
  relevant.

- **Changelogs**:
  Provide links to detailed changelogs for each pkgsrc collection.

- **Downloads & Checksums**:
  List direct download links for the signed tarball and its signature,
  along with checksum values (e.g., SHA256).

- **Installation/Upgrade Instructions**:
  Offer or link to clear installation/upgrade guidelines, often
  referencing the handbook.

- **Contributors**:
  Credit those who contributed.

Draft these notes in a temporary file.  This content will be formatted
and published in the following steps.

#### Creating Website Announcement Files and Assets

For Zeppe-Lin, we manage official release notes and related assets in
the `zeppe-lin.github.io` repository -- our website's home.  This
involves creating the Markdown file for the full notes and preparing
the release banner.

##### Creating the Markdown Release Notes File (relnotes)

1. **Access the Repository**:
   Open your local clone of `zeppe-lin.github.io.git`.

2. **Navigate to /relnotes/ Directory**:
   This is where all release notes in Markdown are stored.

3. **Create the File**:
   Make a file named `relnotes-v<VERSION>.md` (e.g.,
   `relnotes-v1.0.md`).  Paste and format your drafted release notes
   (from 3.4.1) in Markdown.

4. **Reference the Banner**:
   Include a link (or embed code, typically referencing an HTML
   include if your static site generator supports it) to display your
   release banner within this Markdown file.  The banner file will be
   created in the next step.

##### Creating the Release Banner (Cover Artwork)

A distinct release banner helps your audience instantly recognize the
new Zeppe-Lin release.  It appears on both the release notes page and
the main website.

1. **Design and Store Artwork**:
   Create a web-friendly image (e.g., PNG or JPEG) that reflects this
   release's theme.  Place the artwork file(s) in the `artwork.git`
   repository and push them.

2. **Prepare the Release Banner File**:
   In the `/relnotes/` directory of `zeppe-lin.github.io` repository,
   create a file named `banner-v<VERSION>.html` (e.g.,
   `banner-v1.0.html`).  This file should contain an `<img>` tag (or
   similar code) referencing the artwork in the `artwork.git`) to
   display the banner.

3. **Update Main Website Banner Pointer**
   (Optional - can be done Post-Release): Edit `/index/banner.html` on
   the `zeppe-lin.github.io` repository so that the release banner
   points to the new artwork.  This step can be done just before or
   after publishing the main website updates.

#### Publishing the Release

Once your assets (signed tarball, signature, Git tag) and announcement
files are ready, it's time to go public.

##### Announcing on GitHub Releases

1. **Open the Repository**:
   Navigate to the Zeppe-Lin
   [`pkgsrc-core` repository on GitHub](https://github.com/zeppe-lin/pkgsrc-core).

2. **Go to Releases**:
   Click the "Releases" tab (or section).

3. **Draft a Release**:
   Click "Create a new release" (or "Draft a new release").

4. **Select Your Tag**:
   In the "Tag version" drop-down, choose your Git tag created in
   3.3.2 (e.g., `v1.0`).

5. **Set the Title and Description**:

   - **Title**:
     Enter a release title (e.g., `Zeppe-Lin v1.0: The Maiden Voyage`).

   - **Description**:
     Copy/paste the summary and key highlights from your drafted
     release notes (3.4.1). **Crucially, include a link to the full
     release notes page on the Zeppe-Lin website** (this page will
     become live once you push the website changes).

6. **Attach Files**:
   Upload the signed root filesystem tarball
   (`rootfs-v1.0-x86_64.tar.xz`) and its signature
   (`rootfs-v1.0-x86_64.tar.xz.sig`) generated in 3.3.1.

7. **Pre-release Option**:
   If necessary, mark the release as a pre-release; otherwise, leave
   it unchecked.

8. **Publish**:
   Click "Publish release" to make it official on GitHub.

##### Updating the Zeppe-Lin Website

Publish the release notes and banner on the official Zeppe-Lin
website.

1. **Commit and Push Website Changes**:
   In your local clone of `zeppe-lin.github.io`, commit the changes
   for:

   - The new release notes Markdown file
     (`/relnotes/relnotes-v<VERSION>.md`) created in 3.4.2.1.

   - The new banner HTML file (`/relnotes/banner-v<VERSION>.html`)
     created in 3.4.2.2.

   - (If you didn't do it in 3.4.2.2) The change in
     `/index/banner.html` to point to the new artwork.

   - The update to `/index/index.md` so that the latest release
     version and links (like the one to the release notes page) are
     correctly displayed.  Push these changes to the remote
     `zeppe-lin.github.io` repository.

2. **Verify Website Build**:
   Our CI/CD pipeline will detect the new and changed files, convert
   the Markdown to HTML (using `smu(1)`), and publish the updated
   website.  Verify that the new release notes page (e.g.,
   `https://zeppe-lin.github.io/relnotes-v1.0.html`) and the main page
   display and link to the new release properly.

This process ensures that the release is prominently published on both
GitHub and the Zeppe-Lin website for the community to access.

# Post-Release Tasks

After successfully publishing the new version of Zeppe-Lin, complete
these steps to keep everything current and the community informed.

1. **Updating the User Handbook**:
   Review and update `handbook/handbook.md` in the
   `zeppe-lin.github.io` repository.  Ensure that version data,
   installation/upgrade instructions, and download links reflect the
   new release.  Commit and push these changes.

2. **Announcing on GitHub Discussions**:
   Create a new announcement thread in the GitHub Discussions
   Announcements category.  Include the release name and version, a
   brief summary of key highlights, a link to the full release notes
   on the website, and download links (linking to the GitHub release
   is often best for downloads).

3. **Verifying Download Links**:
   Double-check all download links in the release notes file
   (`relnotes-v<VERSION>.md`) and on the website to ensure they
   accurately point to the signed root filesystem tarball, its
   signature, and any other release artifacts.

4. **Updating Documentation Links**:
   Review all documentation -- including the user handbook and
   developer's codebook -- to update any links that reference older
   releases, pointing them to the new release where appropriate.

5. **Monitoring Feedback**:
   Keep an eye on GitHub Discussions and Issues for user feedback and
   bug reports.  Address any critical issues through patch releases if
   necessary (which would follow a similar, albeit potentially
   abbreviated, process).

6. **Planning for the Next Release**:
   Begin planning the next release by discussing new features,
   improvements, and bug fixes based on community feedback and
   internal priorities.

# Conclusion

Congratulations, Captain! You've navigated every key step -- from
preparing our pkgsrc repositories and building the core system to
finalizing assets, publishing announcements, and completing
post-release tasks.  By sticking to this guide, you're ensuring each
Zeppe-Lin release is stable, secure, and clearly communicated to our
community.

Fair winds and smooth sailing on your next release voyage!

