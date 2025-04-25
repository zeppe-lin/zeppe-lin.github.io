# Zeppe-Lin Codebook

## PREFACE

Zeppe-Lin Codebook.
*Because even pirates need a map to find the treasure (and avoid the kraken).*

This guide is your essential blueprint for building the future of
Zeppe-Lin.  Simple, efficient, and stripped of needless complexity --
it's designed to streamline coding, contributing, and releasing.
Clarity is our north star, helping you get things done without fuss.

## 1. Introduction

Hello, Zeppe-Linauts!  Whether you're tidying up code, squashing bugs,
or charting the next release, this codebook keeps things lean and
laser-focused.  Zeppe-Lin lives and breathes clean code and honest
collaboration.  So, grab your tools, set your course, and let's keep
it sharp and delightfully simple.

## 2. Zeppe-Lin Release Process (Overview)

Releasing a new version of Zeppe-Lin is like preparing an airship for
its next journey.  Here's the streamlined process:

- **Branching:** Create new release branches in package source
  repositories.
- **Toolchain Update:** Refresh and rebuild core build tools in
  pkgsrc-core.
- **Package Updates:** Update software sources in pkgsrc-system,
  pkgsrc-xorg, and pkgsrc-desktop.
- **Rootfs Assembly:** Use mkrootfs to build and verify the operating
  system image.
- **Finalize Assets:** Sign the rootfs image and create the Git tag
  for the release version.
- **Prepare Announcements:** Draft release notes and create website
  assets (banner, release notes file).
- **Publish Release:** Announce and publish the release on GitHub and
  the Zeppe-Lin website.
- **Post-Release Tasks:** Update documentation, announce on
  discussions, monitor feedback.

**Key Repositories:**

- **Software sources collections:**
  - `pkgsrc-core.git`
  - `pkgsrc-system.git`
  - `pkgsrc-xorg.git`
  - `pkgsrc-desktop.git`
- **Website & announcements:**
  - `zeppe-lin.github.io.git`
- **Release visuals:**
  - `artwork.git`

This codebook will guide you through each step.
Let's get Zeppe-Lin ready for takeoff!

## 3. Creating a Zeppe-Lin Release

### 3.1. Preparation

#### 3.1.1. Branching Strategy for Package Source Repositories

Before updating the toolchain or package sources for a new release,
create new branches to keep changes isolated and protect stable
releases.  This applies to the main repositories:

- `pkgsrc-core.git`
- `pkgsrc-system.git`
- `pkgsrc-xorg.git`
- `pkgsrc-desktop.git`

The branching strategy is generally followed for unofficial
repositories as well.

**General Approach:**

- **For versions 1.x (pre-2.0):** Create a branch named `1.x` to
  handle all 1.x releases (e.g., 1.0, 1.1, 1.2).
- **For versions 2.x and beyond:** Create a branch named after the
  major version (e.g., `2.x`).

**Creating a New Branch:**

1. Identify the target major version (e.g., 1.0).

2. From the current stable branch, run:

        git checkout <current_stable_branch>
        git checkout -b <new_branch>
        git push origin <new_branch>

   For example, if the last stable release is 0.9 (and `0.x` is
   current stable branch for 0.9), create branch `1.x`:

        git checkout 0.x
        git checkout -b 1.x
        git push origin 1.x

All updates for the `1.x` series will now be done on the `1.x` branch,
keeping ongoing work isolated from stable releases.  This strategy
ensures stable releases remain unaffected while development stays
organized.

#### 3.1.2 Using pkgsrcfeeds to Track Package Updates (Optional)

The `pkgsrcfeeds.git` repository aggregates updates from all Zeppe-Lin
pkgsrc collections via an Atom feed (`urls.opml`).  Use any Atom feed
reader (like the command-line tool `snownews`) to quickly spot new or
changed packages while updating packages in the following steps.

If a package update reveals a missing dependency, add it to the
appropriate pkgsrc repository and update the `urls.opml` feed
accordingly.  The repository also offers scripts to verify feed
consistency and flag missing or outdated entries (details in the
`README.md`).

In short, `pkgsrcfeeds` lets you keep tabs on package updates without
the extra fuss, aiding the update process in Section 3.2.

### 3.2 Updating Pkgsrc Repositories and Building the Core System

#### 3.2.1 Core Toolchain Update (pkgsrc-core)

Updating the core toolchain is the first mandatory step before
modifying any other packages. This ensures a fresh, stable base for
Zeppe-Lin.  Follow this strict build order:

**Build Order:**

- `linux-headers` (skip, it's bundled with `glibc` now)
- `glibc` and `glibc-32`
- `binutils`
- `gcc`
- `libtool`
- Rebuild `binutils`
- Rebuild `glibc` and `glibc-32`
- Rebuild `libtool`

**Why This Order?**
`gcc` depends on `binutils`, and both rely on the system libraries
from `glibc`.  Multiple passes guarantee that every component is built
against its latest dependencies.

**Steps to Update and Build:**

1. **Navigate to pkgsrc-core:**
   Open your terminal and head to your local clone.

2. **Checkout the Release Branch:**
   Switch to your release branch (e.g., `1.x`).

3. **Update Package Definitions:**
   Update the `Pkgfile`, `.md5sum`, and `.footprint` files for
   `glibc`, `glibc-32`, `binutils`, `gcc`, and `libtool` with the new
   versions.

4. **Build the Toolchain:**
   Execute:

       pkgman update -fr -d --group \
           glibc{,-32} binutils gcc libtool \
           binutils glibc{,-32} libtool

   This command respects the build order listed above.

5. **Test Extensively:** After the build, compile other core packages
   or create a rootfs archive to ensure everything runs smoothly.

**Potential Issues:** Expect that you may encounter build failures,
linker errors, or subtle runtime issues.  Check the logs, ask for
help, and consult relevant resources (e.g., Linux From Scratch
documentation).

#### 3.2.2. Standard Package Updates

After the toolchain update, refresh the remaining package definitions
in your pkgsrc repositories. Begin with updating `pkgsrc-core` -- this
ensures that the core system packages reflect the new upstream
changes. Once `pkgsrc-core` is up-to-date, proceed to update the
remaining repositories in the following order: `pkgsrc-system`, then
`pkgsrc-xorg`, and finally `pkgsrc-desktop`.

For each package:
- Update the version, checksums, footprint, and any necessary patches
  to match the new upstream release.
- Commit your changes using a clear message (e.g.,
  `<package>: <old_version> -> <new_version>`) and push the commits to
  the remote repository.

#### 3.2.3 Preparing the Root Filesystem Image

With our toolchain and packages updated, the next step is to create
Zeppe-Lin’s core: the root filesystem image. This image, used for
chroot installations, forms the foundation of our OS.

##### 3.2.3.1. Introducing mkrootfs

`mkrootfs` is a streamlined utility that automates the creation of a
customized root filesystem for Zeppe-Lin. It performs two main tasks:

- **Package Installation:** It calls `pkgman(1)` to build and install
  packages into a designated working directory.

- **Integrity Check:** It then uses `revdep(1)` to scan for broken
  shared libraries, ensuring that every dependency is correctly
  resolved.

This process is configured via `/etc/mkrootfs/config`, which defines
key parameters such as:

- `ROOTFS_DIR`: The working directory for the filesystem (default:
  `/tmp/rootfs-$(date +%F)-$(uname -m)/`).

- `PACKAGES`: The list of packages to install (defaults to the core
  set).

- `ROOTFS_TAR`: The output tarball filename (default:
  `$ROOTFS_DIR.tar.xz`).

Command-line options let you override these settings (see
`mkrootfs(8)`), so you can tailor the build process as needed.

In short, `mkrootfs` takes care of installation, dependency
resolution, and basic validation, providing a simple yet reliable way
to package Zeppe-Lin's system image.

##### 3.2.3.2. Step-by-Step Rootfs Creation

Now that we've been introduced to mkrootfs, let's get our hands
dirty and walk through the process of creating a Zeppe-Lin root
filesystem image.

1. **Configure:**
   Edit `/etc/mkrootfs/config` (as root) to set key parameters like:

   - `ROOTFS_DIR` (working directory)
   - `ROOTFS_TAR` (output tarball name)
   - `PACKAGES` (default: all packages from `pkgsrc-core`)

   Save your changes.

2. **Build:**
   Run the command below to prepare the filesystem, check
   dependencies, and create the tarball:

       sudo mkrootfs -BCT

   This invocation instructs mkrootfs to:

   - Build the filesystem directory (`-B`)
   - Check library dependencies via revdep (`-C`)
   - Compress the directory into a tarball (`-T`)

3. **Verify:**
   Review the build log (as defined by `ROOTFS_LOG`) to ensure no
   errors or broken library links.

4. **Result:** The finished root filesystem tarball will be located at
   the path specified by `ROOTFS_TAR`.

Alternatively, you can override configuration settings on the fly
using command-line options (refer to `mkrootfs(8)` for details).

Once complete, you'll have a verified root filesystem image ready for
the next release steps.

##### 3.2.3.3. Optional Cleanup

Once mkrootfs finishes and you've verified the output files, you might
want to clear out temporary build artifacts to keep your system neat.
This step is optional but can free up valuable space and reduce
clutter.

For example, after confirming that the root filesystem tarball
(defined by `ROOTFS_TAR`) is intact, you can remove the working
directory (specified by `ROOTFS_DIR`) and any log files you don't
need:

    sudo rm -rf /tmp/rootfs-*-$(uname -m){,.log}

**When Might You Skip Cleanup?**

- **Debugging:** If errors occurred during the mkrootfs process,
  leaving the working directory intact lets you inspect build logs and
  filesystem contents to diagnose issues.

- **Incremental Builds (Advanced):** For minimal changes, you might
  reuse parts of the already built filesystem to speed up subsequent
  builds. (This approach diverges from the standard workflow and
  requires manual intervention.)

For most standard release preparations, once your root filesystem
tarball is verified, it's best to clean up to conserve disk space.

### 3.3 Finalizing Release Assets

#### 3.3.1 Signing the Rootfs Tarball

Digitally sign your root filesystem tarball to assure users of its
authenticity and integrity. We'll use GPG for this purpose.

**Prerequisites:**

- Install GPG if you haven't yet
  (e.g., `sudo pkgman install --deps --group gnupg`).
- Ensure you have your official Zeppe-Lin private key, secured with a
  strong passphrase.

**Steps:**

- **Navigate to the Tarball Directory:** Go to the directory where
  your tarball (e.g., `rootfs-v1.0-x86_64.tar.xz`) resides.

- **Sign the Tarball:** Create a detached, ASCII-armored signature:

      gpg --detach-sig --armor --output   \
            rootfs-v1.0-x86_64.tar.xz.sig \
            rootfs-v1.0-x86_64.tar.xz

  You'll be prompted for your key’s passphrase.

3. **Verify the Signature (Optional):** Confirm the signature is
   valid:

      gpg --verify rootfs-v1.0-x86_64.tar.xz.sig \
                   rootfs-v1.0-x86_64.tar.xz


You will now have the signed tarball and its `.sig` file, ready for
distribution.

#### 3.3.2 Creating a Git Tag in pkgsrc-core

Once all package updates, configuration changes, and build scripts for
the release are committed and pushed to your release branch (e.g.,
`1.x`) in `pkgsrc-core` and other relevant repositories, mark the
release by creating an immutable Git tag in `pkgsrc-core`.  This tag
serves as the permanent reference for the Zeppe-Lin release and is
required for the GitHub release step.

**Steps:**

1. **Switch to the Release Branch:** Make sure you're on and
   up-to-date with your release branch in the `pkgsrc-core` repository:

       git checkout 1.x # Replace 1.x with your release branch
       git pull origin 1.x

   *Ensure all commits relevant to this release have been pushed to
   this branch.*

2. **Create an Annotated Tag:** Create a tag with a clear message.
   Include the version number and ideally a brief note or a
   placeholder for the release notes link (which will be finalized
   later). For example:

       git tag -a v1.0 -m "Zeppe-Lin v1.0 - The Maiden Voyage! ..."

3. **Push the Tag:** Push the new tag to the remote repository:

       git push origin v1.0

   Or push all local tags (be cautious with this command if you have
   other local tags):

       git push origin --tags

**Notes:**

- Use a consistent naming convention (e.g., prefix with `v` followed
  by the version number).
- The tag message should be informative. The full release notes link
  can be added to the GitHub Release description later.
- Once pushed, tags are considered immutable -- review carefully
  before tagging.

With these steps, the exact source code state for your release is
officially marked in the source history.

### 3.4 Preparing and Publishing Announcements

#### 3.4.1 Drafting Release Notes Content

Release notes are your guide for users, outlining what's new, what's
changed, and how to upgrade. Draft the content for these notes. This
draft will be used for the official release notes file on the website
and the GitHub Release description.

Essential Contents:

- **Introduction:** Briefly describe the release (version, date, and
  theme).

- **Incompatible Changes:** List any breaking changes or adjustments
  needed for upgrades.

- **New Features:** Highlight new functionalities and improvements.

- **Package Changes:** Summarize package updates for each repository
  (added, removed, updated).

- **Artwork:** Describe the release's visual design, including a link
  and licensing info if necessary (mention the banner created in
  4.4.2.2).

- **Kernel & Toolchain:** Specify the Linux kernel version and list
  core toolchain components (e.g., glibc, gcc, binutils). Include X11
  details if relevant.

- **Changelogs:** Provide links to detailed changelogs for each pkgsrc
  repository.

- **Downloads & Checksums:** Supply direct download links for the
  signed tarball and signature file, along with checksum values (e.g.,
  SHA256). (Make sure these links and checksums are accurate based on
  your generated files).

- **Installation/Upgrade Instructions:** Offer or link to clear
  instructions for installing or upgrading (usually point to the
  handbook, which you will update later in 4.5.1).

- **Contributors:** Acknowledge those who contributed to the release.

Draft your release notes content in a temporary file. This content
will be formatted and published in the following steps.

#### 3.4.2 Creating Website Announcement Files and Assets

For Zeppe-Lin, we manage official release notes and related assets in
the `zeppe-lin.github.io` repository — our website's home. This
involves creating the Markdown file for the full notes and preparing
the release banner.

##### 3.4.2.1 Creating the Markdown Release Notes File (relnotes)

1. **Access the Repository:** Open your local clone of
   `zeppe-lin.github.io.git`.

2. **Navigate to /relnotes/:** This directory stores our release notes
   in Markdown.

3. **Create the Markdown File:** Create a file named
   `relnotes-v<VERSION>.md` (e.g., `relnotes-v1.0.md`) and paste/adapt
   the content drafted in 4.4.1 into it, formatting it in Markdown.

4. **Reference the Banner:** Include a link (or embed code, typically
   referencing an HTML include if your static site generator supports
   it) to display your release banner within this Markdown file. The
   banner file will be created in the next step.

##### 3.4.2.2 Creating the Release Banner (Cover Artwork)

A distinct release banner helps your audience instantly recognize the
new Zeppe-Lin release. It appears on both the release notes page and
the main website.

1. **Design and Store Artwork:** Create a web-friendly image (e.g.,
   PNG or JPEG) that reflects this release's theme. Place the artwork
   file(s) in the artwork repository and push them.

2. **Prepare the Release Banner File:** In the `/relnotes/` directory
   of the zeppe-lin.github.io repository, create a file named
   `banner-v<VERSION>.html` (e.g., `banner-v1.0.html`). This HTML file
   should contain the code (e.g., an <img> tag referencing the artwork
   in the artwork repo) to display the banner.

3. **Update Main Website Banner Pointer (Optional - can be done
   Post-Release):** Once the release is official, you will need to
   edit `/index/banner.html` on the `zeppe-lin.github.io` website so
   that its hero image points to the new artwork.  This step can be
   done just before or after publishing the main website updates.

#### 3.4.3 Publishing the Release

Now that the release assets (signed tarball, signature, Git tag) are
ready and announcement content/files are drafted, it's time to make
the release public.

##### 3.4.3.1 Announcing on GitHub Releases

Use GitHub's Releases feature to link your Git tag to a dedicated
release page, providing a central hub for the release.

**Steps:**

1. **Open the Repository:** Navigate to the Zeppe-Lin `pkgsrc-core`
   repository on GitHub.

2. **Go to Releases:** Click the "Releases" tab (or section).

3. **Draft a Release:** Click "Create a new release" (or "Draft a new
   release").

4. **Select Your Tag:** In the "Tag version" dropdown, choose your Git
   tag created in 4.3.2 (e.g., `v1.0`).

5. **Set the Title and Description:**

   - **Title:** Enter a release title
     (e.g., `Zeppe-Lin v1.0: The Maiden Voyage`).

   - **Description:** Copy/paste the summary and key highlights from
     your drafted release notes (4.4.1). **Crucially, include a link to
     the full release notes page on the Zeppe-Lin website** (this page
     will become live once you push the website changes).

6. **Attach Files:** Upload the signed root filesystem tarball
   (`rootfs-v1.0-x86_64.tar.xz`) and its signature
   (`rootfs-v1.0-x86_64.tar.xz.sig`) generated in 4.3.1.

7. **Pre-release Option:** If applicable, mark the release as a
   pre-release; otherwise, leave it unchecked.

8. **Publish:** Click "Publish release" to make it official on GitHub.

##### 3.4.3.2 Updating the Zeppe-Lin Website

Publish the release notes and banner on the official Zeppe-Lin
website.

1. **Commit and Push Website Changes:** In your local clone of
   `zeppe-lin.github.io`, commit the changes for:

   - The new release notes Markdown file
     (`/relnotes/relnotes-v<VERSION>.md`) created in 4.4.2.1.

   - The new banner HTML file (`/relnotes/banner-v<VERSION>.html`)
     created in 4.4.2.2.

   - (If you didn't do it in 4.4.2.2) The update to
     `/index/banner.html` to point to the new artwork.

   - The update to `/index/index.md` so that the latest release
     version and its corresponding links (e.g., to the release notes
     page) are correctly displayed. Push these changes to the remote
     `zeppe-lin.github.io` repository.

2. **Verify Website Build:** Our CI/CD pipeline will detect the new
   and changed files, convert the Markdown (using `smu(1)`), and
   publish the updated website.  Verify that the new release notes
   page (e.g., `https://zeppe-lin.github.io/relnotes-v1.0.html`) and
   the main page are displaying correctly and linking to the new
   release information.

With your release published on GitHub and the website, the community
can quickly find, review, and download the new Zeppe-Lin release.

### 3.5 Post-Release Tasks

After successfully publishing the new version of Zeppe-Lin, complete
these steps to keep everything current and the community informed.

1. **Updating the User Handbook:** Review and update
   handbook/handbook.md in the zeppe-lin.github.io repository. Ensure
   that version data, installation/upgrade instructions, and download
   links reflect the new release. Commit and push these changes.

2. **Announcing on GitHub Discussions:** Create a new announcement
   thread in the GitHub Discussions Announcements category. Include
   the release name and version, a brief summary of key highlights, a
   link to the full release notes on the website, and download links
   (linking to the GitHub release is often best for downloads).

3. **Verifying Download Links:** Double-check all download links in
   the release notes file (`relnotes-v<VERSION>.md`) and on the
   website to ensure they accurately point to the signed root
   filesystem tarball, its signature, and any other release artifacts.

4. **Updating Documentation Links:** Review all documentation --
   including the user handbook and developer's codebook -- to update
   any links that reference older releases, pointing them to the new
   release where appropriate.

5. **Monitoring Feedback:** Keep an eye on GitHub Discussions and
   Issues for user feedback and bug reports. Address any critical
   issues through patch releases if necessary (which would follow a
   similar, albeit potentially abbreviated, process).

6. **Planning for the Next Release:** Begin planning the next release
   by discussing new features, improvements, and bug fixes based on
   community feedback and internal priorities.

### 3.6 Conclusion

Congratulations, Captain! You've navigated every key step—from
preparing our pkgsrc repositories and building the core system to
finalizing assets, publishing announcements, and completing
post-release tasks. By sticking to this guide, you're ensuring each
Zeppe-Lin release is stable, secure, and clearly communicated to our
community.

Fair winds and smooth sailing on your next release voyage!

