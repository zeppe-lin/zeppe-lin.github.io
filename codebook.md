---
title: Zeppe-Lin Codebook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

Zeppe-Lin Codebook.  
*Because even pirates need a map to find the treasure  
(and avoid the kraken).*

This Codebook defines the development, update, and release model of
Zeppe-Lin.
It is a reference document for maintainers and contributors
responsible for building, maintaining, and publishing the system.

Its goals are to reduce the bus factor, preserve institutional
knowledge, and ensure that all releases remain reproducible,
traceable, and predictable.

---

# INTRODUCTION

Zeppe-Lin is a source-based Linux distribution developed through a
deliberate, rule-driven workflow.
This Codebook documents the models and procedures that govern how the
system evolves over time.

The document is intentionally normative.  
Where it describes rules, they are mandatory.  
Where it describes procedures, they reflect the expected operational
practice.

---

# RELEASE MODEL

This section defines the rules governing releases, branches, and
versioning.
These rules apply uniformly across all repositories and collections.

## Release Types

Zeppe-Lin publishes discrete releases.
Rolling releases are not used.

* **Patch release**  
  Small fixes, relbumps, or urgent hotfixes.

* **Minor release**  
  Accumulated updates to userland with a stable toolchain.

* **Major release**  
  Toolchain changes or structural system updates, including ABI changes.

## Release Series and Branches

Each major release series is developed on a dedicated stable branch,
for example `1.x` or `2.x`.

All release work occurs exclusively on stable branches.  
The `master` branch is unused.

This structure allows multiple release series to coexist while
preserving stability and predictability.

## Versioning Scheme

Zeppe-Lin uses semantic versioning with the following meaning:

* **Major (X.0)**  
  Toolchain baselines, ABI changes, or structural shifts.

* **Minor (X.Y)**  
  Significant accumulated changes that do not alter the system
  structure.

* **Patch (X.Y.Z)**  
  Small fixes, relbumps, or critical hotfixes.

Version history must remain linear and explicit.

---

# PACKAGE UPDATE POLICY

Package updates follow a strict, ordered policy to preserve system
consistency.
All updates begin in `pkgsrc-core`.

## Core Collection (pkgsrc-core)

### Toolchain Update Order

The toolchain must be updated before any other packages.
The order below is mandatory:

1. `glibc` / `glibc-32`
2. `binutils`
3. `gcc`
4. `libtool`
5. rebuild `binutils`
6. rebuild `glibc` / `glibc-32`
7. rebuild `libtool`

> **Note:**
>
> 0. `linux-headers`  
>    Will be introduced once `glibc` is split accordingly
>    ([GH #6](https://github.com/zeppe-lin/pkgsrc-core/issues/6)).

Each package must be rebuilt and verified before proceeding.
Other packages must not be updated until the toolchain is confirmed
working.

### Other Core Packages

After the toolchain is verified, the remaining packages in
`pkgsrc-core` may be updated.

The following rules apply:

* Keep patches minimal; prefer upstream fixes.
* Rebuild all affected packages.
* Regenerate checksums and footprints.
* Verify dependencies using `revdep(1)`, `finddepslinked(1)`.

## Other Collections

Once `pkgsrc-core` is complete, update the remaining collections in
this order:

1. `pkgsrc-system`
2. `pkgsrc-xorg`
3. `pkgsrc-desktop`

Failures must be fixed immediately and must not be deferred.

---

# ROOTFS BUILD MODEL

The rootfs (root filesystem) is built in two formal stages to ensure
reproducibility and verification.

## Build Stages

* **Stage 1**  
  An initial rootfs obtained by local build or from a published
  artifact.

* **Stage 2**  
  A clean rootfs assembled by chrooting into Stage 1 and rebuilding
  core packages.

## Verification Requirements

Before a rootfs is considered valid:

* All core packages must be rebuilt in Stage 2.
* `revdep` must complete without unresolved failures.
* File ownership and extended attributes must be preserved.

Procedural details are provided in
[Appendix B](#appendix-b-rootfs-build-procedure).

---

# RELEASE PROCESS

This section defines the operational steps required to publish a
release.

## Release Artifacts

Each release produces the following artifacts:

* `rootfs-$VERSION-x86_64.tar.xz`
* `binpkgs-$VERSION-x86_64.tar.xz`

All artifacts must be signed with GPG.  
The release must be tagged in Git as `v$VERSION`.

## Publishing

### GitHub

* Draft a release in `pkgsrc-core`.
* Select the tag `v$VERSION`.
* Upload all artifacts and signatures.

### Artwork

If artwork exists, add it to `artwork.git`.

### Website

Update `zeppe-lin.github.io`:

* Add release notes as `v<VERSION>.md`.
* Update `index.md` (mandatory).
* Reference artwork where applicable.
* Update Handbook and Codebook references if required.

---

# POST-RELEASE OPERATIONS

After publishing:

* Announce the release on the mailing list.
* Monitor early user reports.
* Apply hotfixes only when critical.

A release is considered complete after initial validation by users.

---

# APPENDICES

## Appendix A: Major Release Branch Creation

**Purpose:**

Prepare repositories for a new major release series
(for example, `1.x` → `2.x`).
Minor and patch releases do not require new branches.

**Procedure:**

1. Identify the target major version.
2. From the current stable branch, create a new branch in each
   repository.

```sh
git checkout <current_stable_branch>
git checkout -b <new_branch>
git push origin <new_branch>
```

**Example: creating the `2.x` release series**

```sh
cd /usr/src
for x in core system xorg desktop; do
    git -C pkgsrc-$x checkout 1.x
    git -C pkgsrc-$x checkout -b 2.x
    git -C pkgsrc-$x push origin 2.x
done
```

Repositories involved:

* `pkgsrc-core.git`
* `pkgsrc-system.git`
* `pkgsrc-xorg.git`
* `pkgsrc-desktop.git`

## Appendix B: Rootfs Build Procedure

### Stage 1: Initial Rootfs

Build locally:

```sh
ROOTFS_STAGE1=/mnt/rootfs-stage1

# as root
mkdir -p $ROOTFS_STAGE1/var/lib/pkg
touch $ROOTFS_STAGE1/var/lib/pkg/db
pkgman install --root=$ROOTFS_STAGE1 \
  --config-append="runscripts no" --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")
```

Or extract a published rootfs:

```sh
tar --numeric-owner --xattrs --xattrs-include='*' -xpf \
  rootfs-${VERSION}-x86_64.tar.xz -C $ROOTFS_STAGE1
```

### Entering the Chroot

```sh
# as root
cp /etc/resolv.conf $ROOTFS_STAGE1/etc/resolv.conf
mount -B /dev  $ROOTFS_STAGE1/dev
mount -B /run  $ROOTFS_STAGE1/run
mount -t proc  proc $ROOTFS_STAGE1/proc
mount -t sysfs none $ROOTFS_STAGE1/sys
mount -t devpts -o noexec,nosuid,gid=tty,mode=0620 devpts \
  $ROOTFS_STAGE1/dev/pts

chroot $ROOTFS_STAGE1 /bin/bash
```

### Stage 2: Build and Assemble

```sh
# in chroot, as root

cd /usr/src
git clone https://github.com/zeppe-lin/pkgsrc-core --branch 1.x

VERSION=1.2 # new release version
ROOTFS_STAGE2=/tmp/rootfs-${VERSION}-x86_64

mkdir -p $ROOTFS_STAGE2/var/lib/pkg
touch $ROOTFS_STAGE2/var/lib/pkg/db

pkgman install --root=$ROOTFS_STAGE2 \
  --config-append="runscripts no" --force --deps --group -d \
  $(pkgman --config-set="pkgsrcdir /usr/src/pkgsrc-core" printf "%n\n")

revdep
```

Compress artifacts:

```sh
# in chroot, as root

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

## Appendix C: Artifact Signing

```sh
cd $ROOT_STAGE1/tmp

gpg --detach-sign --armor \
    --output rootfs-$VERSION-x86_64.tar.xz \
    rootfs-$VERSION-x86_64.tar.xz

gpg --detach-sign --armor \
    --output binpkgs-$VERSION-x86_64.tar.xz \
    binpkgs-$VERSION-x86_64.tar.xz
```
