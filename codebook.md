---
title: Zeppe-Lin Codebook
---

[Back to Index](index.html)

# PREFACE {.unnumbered}

> **Important:**
>
> This Codebook is currently a draft.
> The material here represents early ideas, structure, and notes — a
> working skeleton of what Zeppe-Lin’s development practices, system
> internals, and workflow might look like.  
> 
> Expect gaps, rough edges, and unfinished sections.
> Some things may be reorganized, clarified, or rewritten in future
> iterations — polished when the stars align, or whenever inspiration
> strikes.  
>
> Think of this as a living document, a companion for those curious
> enough to explore the foundations before the polish.
> Your feedback, experiments, and discoveries are part of its evolution.

Zeppe-Lin Codebook.
*Because even pirates need a map to find the treasure
(and avoid the kraken).*

This guide is your blueprint to shape the future of Zeppe-Lin.  It's
simple, efficient, and free of extra complexity -- designed to
streamline coding, contributing, and releasing.  Clarity lights the
way so you can work without fuss.

# Introduction

Hello, Zeppe-Linauts!  Whether you're cleaning up code, fixing bugs,
or planning the next release, this codebook keeps things lean and
focused.  Zeppe-Lin stands for clean code and honest collaboration.
So grab your tools, set your course, and let's keep it sharp and
simple.

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

### Preparing the Root Filesystem Image

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

