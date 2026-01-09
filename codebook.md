---
title: Zeppe-Lin Codebook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

Zeppe-Lin Codebook.  
*Because even pirates need a map to find the treasure  
(and avoid the kraken).*

This Codebook documents the development and release process of
Zeppe‑Lin.
It is intended for maintainers and contributors who need a reliable
reference for building, updating, and releasing the system.

Its purpose is to reduce bus factor, preserve institutional knowledge,
and ensure reproducible releases.

---

# INTRODUCTION

Zeppe‑Lin is a source-based Linux distribution with a structured
workflow for package updates and releases.
This Codebook defines the steps and rules that keep the system
consistent, traceable, and manageable over time.

## Releases, Branches, and Versioning

Zeppe-Lin organizes development around
**release types**, **branches**, **and version numbers**.
These concepts are closely related and define how the system evolves.

### Release Types

- **Patch release**  
  Small fixes, relbumps, or urgent hotfixes.

- **Minor release**  
  Significant updates to userland; toolchain remains stable.

- **Major release**  
  Toolchain or system structure changes (ABI updates, structural
  shifts).

Releases are discrete events; rolling releases are not used.

### Branch Structure

- Each major series has a **stable branch** (e.g., `1.x`, `2.x`) where
  all release work occurs.

- **Master branch** exists for reference only; it is not used for
  releases.


Branches allow multiple series to coexist while maintaining stability
and predictability.

## Versioning Rules

- **Major (X.0)**  
  Toolchain baseline, ABI or structural changes.

- **Minor (X.Y)**  
  Significant updates such as toolchain refresh or accumulated changes
  are big enough.

- **Patch (X.Y.Z)**  
  Small fixes, relbumps, or critical hotfixes.

Version history must remain linear and predictable.

---

# UPDATING PACKAGES

Package updates follow a strict order to maintain a consistent and
working system.
All updates in `pkgsrc-core` must be completed first, starting with
the toolchain.

## pkgsrc-core Collection

### Toolchain

The toolchain must be updated before any other packages.
Order is critical:

1. `glibc` / `glibc-32`
2. `binutils`
3. `gcc`
4. `libtool`
5. rebuild `binutils`
6. rebuild `glibc` / `glibc-32`
7. rebuild `libtool`

> **Note:**
> 0. `linux-headers` (when we'll be ready to split `glibc`)

Rebuild each package before moving to the next.
Do not update other packages until the toolchain is verified.

### Other Core Packages

Once the toolchain is verified, update the remaining packages in
`pkgsrc-core`:

- Apply minimal patches; prefer upstream fixes.
- Rebuild all packages.
- Regenerate checksums and footprints.
- Verify dependencies with `revdep(1)`.

## Other Collections

Update collections in this order:

1. `pkgsrc-system`
2. `pkgsrc-xorg`
3. `pkgsrc-desktop`

Fix failures immediately; do not defer.

---

# ROOT FILESYSTEM CREATION

The root filesystem is built in two stages to ensure reproducibility
and verification.

- **Stage 1**  
  Obtain an initial rootfs (build locally or download).

- **Stage 2**  
  Chroot into Stage 1, build core packages into Stage 2, verify with
  `revdep`, and assemble the final rootfs.

Commands are detailed in Appendix A.

---

# RELEASE ARTIFACTS

Each release produces:

- `rootfs-$VERSION-x86_64.tar.xz`
- `binpkgs-$VERSION-x86_64.tar.xz`

Sign with GPG.  
Tag release in Git (`v$VERSION`).  

---

# PUBLISHING

Publishing ensures that releases are accessible to users and
contributors.

## GitHub

- Draft a release in `pkgsrc-core`.  
- Select the tag `v$VERSION`.  
- Upload tarballs and signatures.  

## Artwork

If artwork exists, add it to `artwork.git`.  

## Website

Update `zeppe-lin.github.io`:  

- Add release notes as `v<VERSION>.md`.  
- Update `index.md` (mandatory).  
- Reference artwork in `v<VERSION>.md` and `index.md` if present.  
- Update Handbook and Codebook references if needed.  

---

# POST‑RELEASE

- Announce on mailing list.  
- Monitor early reports.  
- Apply hotfixes only if critical.  
- Release is complete after initial validation by users.  

---

# APPENDICES

## Appendix A: Creating a New Major Release Branch

**Purpose:**
prepare repositories for a new major release series
(e.g., `1.x` → `2.x`).  
*Minor and patch releases do not require new branches.*

**Steps:**

1. Identify the target major version (e.g., 2.0).
2. From the current stable branch, create a new branch in each
   repository:
   ```sh
   git checkout <current_stable_branch>
   git checkout -b <new_branch>
   git push origin <new_branch>
   ```

**Example for 2.x release:**

```sh
cd /usr/src
for x in core system xorg desktop; do
    git -C pkgsrc-$x checkout 1.x
    git -C pkgsrc-$x checkout -b 2.x
    git -C pkgsrc-$x push origin 2.x
done
```

Repositories involved:

- `pkgsrc-core.git`
- `pkgsrc-system.git`
- `pkgsrc-xorg.git`
- `pkgsrc-desktop.git`

This isolates major release work from existing stable series.

## Appendix B: Rootfs Build Procedure

### Stage 1: Initial Rootfs

Build locally:

```sh
ROOTFS_STAGE1=/mnt/rootfs-stage1

# as root (switch to fakeroot?)
mkdir -p $ROOTFS_STAGE1/var/lib/pkg
touch $ROOTFS_STAGE1/var/lib/pkg/db
pkgman install --root=$ROOTFS_STAGE1 \
  --config-append="runscripts no" --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")
```

Or extract published rootfs from
[pkgsrc-core releases page](https://github.com/zeppe-lin/pkgsrc-core/releases/latest):

```sh
tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
  rootfs-${VERSION}-x86_64.tar.xz -C $ROOTFS_STAGE1
```

### Entering the Chroot

```sh
# as root

cp /etc/resolv.conf $ROOTFS_STAGE1/etc/resolv.conf
mount -B /dev $ROOTFS_STAGE1/dev
mount -B /run $ROOTFS_STAGE1/run
mount -t proc proc $ROOTFS_STAGE1/proc
mount -t sysfs none $ROOTFS_STAGE1/sys
mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 devpts \
$ROOTFS_STAGE1/dev/pts

chroot $ROOTFS_STAGE1 /bin/bash
```

### Stage 2: Build and Assemble

Build all core packages into Stage 2 directory:

```sh
# in chroot, as root

# clone pkgsrc-core first
cd /usr/src/
git clone https://github.com/zeppe-lin/pkgsrc-core --branch 1.x

# prepare stage2 dir
VERSION=1.2 # New release VERSION
ROOTFS_STAGE2=/tmp/rootfs-${VERSION}-x86_64
mkdir -p $ROOTFS_STAGE2/var/lib/pkg
touch $ROOTFS_STAGE2/var/lib/pkg/db

# build and install core packages into stage dir
pkgman install --root=$ROOTFS_STAGE2 \
  --config-append="runscripts no" --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")

# verify with revdep
revdep
```

Compress artifacts:  
```sh
tar -cJf $ROOTFS_STAGE2.tar.xz -C $ROOTFS_STAGE2 .

tar -cJf /tmp/binpkgs-$VERSION-x86_64.tar.xz \
  -C /var/cache/pkgmk/packages .
```

Cleanup:  
```sh
exit
umount -R $ROOTFS_STAGE1/dev
umount -R $ROOTFS_STAGE1/proc
umount -R $ROOTFS_STAGE1/sys
umount -R $ROOTFS_STAGE1/run
```

## Appendix C: Signing Artifacts

```sh
cd $ROOTFS_STAGE1/tmp
gpg --detach-sign --armor rootfs-$VERSION-x86_64.tar.xz
gpg --detach-sign --armor binpkgs-$VERSION-x86_64.tar.xz
```
