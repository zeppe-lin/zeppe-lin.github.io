---
title: Zeppe-Lin Codebook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

A release is built.

The packages compile.  
The root filesystem boots.  
The artifacts are uploaded.  
The signatures verify.

Six months later, another maintainer tries to repeat the work.

Nobody can say precisely why the toolchain was rebuilt in that order,
which branch was authoritative, whether the root filesystem was
assembled from clean packages, or which steps existed only in the
previous maintainer's shell history.

The release survived.

The process did not.

This Codebook exists for that gap.

Zeppe-Lin is maintained by people, but its development and release
model must not depend on one person's memory.
Branches, packages updates, rebuild order, rootfs construction,
signing, and publication must remain inspectable after the maintainer
who performed them has left the IRC, forgotten the sequence, or become
the historical authority everyone else is forced to summon.

The Codebook is the maintainer's operating doctrine.

It records how shared code may change, how a release becomes
authoritative, and which shortcuts must not be allowed to impersonate
a reproducible process.

It is not a substitute for judgement.
It exists so judgement begins from shared facts rather than inherited
ritual.

> A release procedure that exists only in memory is not a procedure.  
> It is a witness.

---

# INTRODUCTION

A maintainer may experiment on their own machine.

The moment that work enters a shared branch, becomes a package update,
or appears in a release artifact, it stops being private technique.

It becomes system state.

Zeppe-Lin is a source-based Linux distribution.
Its packages, toolchain, branches, root filesystems, and releases are
maintained through an explicit workflow because changes in one part of
the system do not remain there.

A toolchain update changes what can be built.  
A branch decides which history is authoritative.  
A package removal changes what users may depend upon.  
A rootfs records the state from which installation beings.  
A release turns all of these decisions into a public promise.

This Codebook governs those transitions.

It defines the development, update, and release model shared by
Zeppe-Lin repositories.
It records the order in which work is performed, the checks that must
succeed, and the evidence that must remain after the work is complete.

The document is normative.

When it says that something **must** be done, the requirements is part
of the project's operating model.

When it describes a procedure, that procedure is the established path.
A departure may be necessary, but it must be deliberate, justified,
and recorded.
An undocumented exception is not a new procedure.
It is missing history.

The Codebook does not remove maintainer judgement.

It defines where judgement ends and shared responsibility begins.

> Private work may depend on memory.  
> Shared state must explain itself.

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

### System Release Metadata

After the toolchain is verified, update `os-release` package.

Rules:

- Update `VERSION`, `VERSION_ID`, and related fields to match the
  target release in `os-release` file.

- Do not update other core packages until `os-release` is correct.

### Other Core Packages

After the toolchain is verified and system release metadata is
updated, the remaining packages in `pkgsrc-core` may be updated.

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

## Package Deprecation and Removal

Packages may be deprecated when no active maintainer exists or when
upstream support has ceased.

Rules:

- Deprecation must be performed on the current stable branch.
  - Set the Maintainer field in the Pkgfile to UNMAINTAINED.
  - Commit message must use the form:

    ```
    [notify] <package-name>: marked UNMAINTAINED
    Maintainer set to UNMAINTAINED. Package scheduled for
    removal in the next release unless a new maintainer steps in.
    ```

  - `[notify]` commits ensure mailing lists and IRC are informed.

- Removal must be performed in the next release branch.
  - Commit message must use the form:

    ```
    [notify] <package-name>: removed (unmaintained)
    Package was marked UNMAINTAINED in the previous branch and has
    now been removed for release hygiene.
    ```

- This two‑step process ensures:
  - Users of the current branch are warned before removal.
  - The package disappears only when upgrading to the next release
    series.
  - Transparency and predictability are preserved across branches.

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

chroot $ROOTFS_STAGE2 revdep
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
    --output rootfs-$VERSION-x86_64.tar.xz.sig \
    rootfs-$VERSION-x86_64.tar.xz

gpg --detach-sign --armor \
    --output binpkgs-$VERSION-x86_64.tar.xz.sig \
    binpkgs-$VERSION-x86_64.tar.xz
```
