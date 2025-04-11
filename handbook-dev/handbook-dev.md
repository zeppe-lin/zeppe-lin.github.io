# Zeppe-Lin Developers Handbook

## PREFACE

Zeppe-Lin Developers Handbook.
*Because even pirates need a map to find the treasure (and avoid the kraken).*

This handbook outlines the procedures and best practices for
developers to contribute to and release new versions of Zeppe-Lin.

## 1. Introduction

Welcome, Zeppe-Linauts! Ready to launch the next release? This
handbook is your quick guide to navigating our open source,
KISS-driven release process.

From the depths of the source to the heights of a new version, we'll
chart the course together. Join the crew of code pirates and let's
make Zeppe-Lin soar!

## 2. Setting Up Your Development Environment

**FIXME**

## 3. Understanding the Zeppe-Lin Release Process (High-level overview)

Creating a new release of Zeppe-Lin is like preparing our trusty
airship for its next voyage. It involves several key stages, from
ensuring the engine (toolchain) is in top shape to charting the course
(release notes) and finally announcing our arrival to the world.

Here's a high-level overview of the journey:

1.  **Toolchain Tune-up:** We start by updating the core building
    tools within the `pkgsrc-core` repository. This ensures a solid
    foundation for all other packages. Think of it as upgrading the
    Zeppe-Lin's engine for better performance.

2.  **Package Pampering:** Next, we update the sources for various
    packages in repositories like `pkgsrc-system`, `pkgsrc-xorg`, and
    `pkgsrc-desktop`. This brings in the latest features and fixes for
    the software that makes up Zeppe-Lin.

3.  **Rootfs Assembly:** With the packages ready, we use the
    `mkrootfs` tool to assemble the actual operating system image –
    the core of our Zeppe-Lin airship.

4.  **Release Readiness:** This involves signing the assembled image
    to ensure its authenticity, preparing release notes that detail
    all the exciting changes, and creating a tag in the `pkgsrc-core`
    repository to mark this new version.

5.  **Announcing the Voyage:** Finally, we announce the new release to
    the Zeppe-Lin community through a release post on GitHub, an
    announcement on the Zeppe-Lin website, and by updating our
    documentation (like this very handbook!).

Throughout this process, we'll be working with several key
repositories:

* `pkgsrc-core`:
  The heart of the system, containing the core build tools.

* `pkgsrc-system`, `pkgsrc-xorg`, `pkgsrc-desktop`:
  Collections of various software packages.

* `zeppe-lin/zeppe-lin.github.io`:
  Where the website and release announcements live.

* `zeppe-lin/artwork`:
  For the visual banners that accompany our releases.

This handbook will guide you through each of these stages in detail,
providing the charts and compass you need to navigate the Zeppe-Lin
release process. So, buckle up, and let's prepare for launch!

## 4. Creating a Zeppe-Lin Release

### 4.1. Branching Strategy for Package Source Repositories

Before we begin updating package sources and the toolchain for a new
Zeppe-Lin release, it's crucial to establish the correct branches in
our core package source repositories. This allows us to isolate
changes for the upcoming release and maintain the stability of
previous versions.

This branching strategy especially applies to the following
repositories:

* `pkgsrc-core`
* `pkgsrc-system`
* `pkgsrc-xorg`
* `pkgsrc-desktop`

*(but usually, and other unofficial ones follow this)*

The general approach is to create a new branch for each major release
series. Here's how it works:

* **For versions 1.0 and above (before 2.0):** We create a branch
  named `1.x`. This branch will be the primary development branch for
  all releases within the 1.x series (e.g., 1.0, 1.1, 1.2, etc.).

* **For versions 2.0 and above:** Similarly, for the 2.x series, we
  create a branch named `2.x`, and so on for future major releases.

**Creating a New Branch:**

1.  **Identify the target major version** for the upcoming release
    (e.g., 1.0, 2.0).
2.  **Based on the current stable release branch**, create a new
    branch named according to the version series
    (e.g., `git checkout -b 1.x <current_stable_branch>`).
    For example, if the last stable release was `0.9`, you would
    branch `1.x` from `0.9`.

**Example:**

Let's say the current stable release is `0.9`, and we are preparing
for Zeppe-Lin `1.0`. You would perform the following steps in each of
the package source repositories mentioned above:

```bash
git checkout <0.9_branch_name>  # Ensure you are on the current stable branch
git checkout -b 1.x             # Create the new development branch for the 1.x series
git push origin 1.x             # Push the new branch to the remote repository
```

**Important Note:** All subsequent updates and changes for the `1.x`
release series will now be done on the `1.x` branch in each of these
repositories.

This branching strategy helps us keep our development organized and
ensures that stable releases remain unaffected by ongoing work on
newer versions.

### 4.2. Updating Package Sources

With the correct branches created in our package source repositories,
the next step is to update the actual package definitions to the
versions we want to include in the new release. This process ensures
we're building with the latest and greatest (or the specifically
chosen) software.

Here's a general outline of how this is typically done:

1. **Navigate to the Relevant Repository:** Depending on the package
   you want to update, navigate to the corresponding repository on
   your local machine (`pkgsrc-core`, `pkgsrc-system`, `pkgsrc-xorg`,
   or `pkgsrc-desktop`).

2. **Identify the Package to Update:** Locate the directory for the
   specific package you intend to update. Packages are usually
   organized into categories within these repositories.

3. **Update the Package Definition:** This is the core of the process
   and can involve several actions within the package's directory
   (often containing files like `Pkgfile`, `.footprint`, `.md5sum` and
   potentially patches):

   * **Bump the Version:** Modify the `version` variable in the
      `Pkgfile` to reflect the new upstream version.

   * **Update the `.md5sum` File:** This file contains checksums of
     the source tarballs. When the version changes, you'll need to
     update these checksums. `pkgmk -um` is available to help with
     this.

   * **Update the `.footprint` File:** This file lists expected files
     in the final package. `pkgmk -uf` is available to help with this.

   * **Apply Necessary Patches:** If there are any patches applied to
     the package to make it work correctly within Zeppe-Lin, you might
     need to update these patches if the upstream code has changed
     significantly, or you might need to create new patches.

   * **Review Dependencies:** Check if the package's dependencies have
     changed in the new version and update them in the `Pkgfile` if
     necessary.

4. **Toolchain Updates in `pkgsrc-core`:** When updating core
   toolchain components (like `glibc`, `binutils`, `gcc`) in
   `pkgsrc-core`, this process requires extra care and thorough
   testing due to their fundamental role in the system. You'll likely
   be working with specific build scripts and configurations within
   those package directories.

5. **Commit Your Changes:** Once you've updated the package
   definition, commit your changes to the Git repository with a clear
   and informative commit message (e.g.,
   `<package_name>: <old_version> -> <new_version>`).

6.  **Push Your Changes:** Finally, push your committed changes to the
    remote repository on GitHub.

**Important Considerations:**

* **Consult Upstream Documentation:** Always refer to the upstream
  project's release notes and documentation to understand the changes
  in the new version and any potential compatibility issues.
* **Test Thoroughly:** After updating a package, especially core
  system packages, it's crucial to build and test it to ensure it
  functions correctly and doesn't introduce any regressions.

#### 4.2.1. Working with the `pkgsrcfeeds` Repository

The `pkgsrcfeeds` repository (available at
`github.com/zeppe-lin/pkgsrcfeeds.git`) is an essential tool for
staying informed about updates to package sources across all the
Zeppe-Lin package collections (`pkgsrc-core`, `pkgsrc-system`,
`pkgsrc-xorg`, `pkgsrc-desktop`).

**Contents and Usage:**

* **Atom Feed (`urls.opml`):** The core of this repository is an Atom
  feed file (`urls.opml`). This feed lists recent updates to packages
  in the various `pkgsrc-*` repositories.
* **Feed Readers:** You can use any Atom feed reader to explore this
  file and see which packages have had changes or new versions
  committed upstream. A command-line feed reader like `snownews`
  (available in the `pkgsrc-desktop` collection) is a convenient
  option for developers.
* **Identifying Packages for Update:** By regularly checking the
  `pkgsrcfeeds` Atom feed, you can easily identify packages in the
  Zeppe-Lin repositories that have newer versions available and might
  need to be updated for the next release.

**Adding New Dependencies:**

If, while updating a package source, you find that it requires a new
dependency that is not currently present in the Zeppe-Lin `pkgsrc`
collections (and therefore not in `pkgsrcfeeds`), it's good practice
to:

1. First, add the new dependency to the appropriate `pkgsrc-*`
   repository.
2. Then, ensure that the `pkgsrcfeeds` repository is updated to
   include information about this new package. This usually involves
   modifying the `urls.opml` file.

**Verification and Consistency Scripts:**

The `pkgsrcfeeds` repository also contains scripts (you might want to
list the specific script names here) that are used to:

* **Verify Consistency:** These scripts can check the `urls.opml` file
  for consistency and ensure that the listed updates are valid and
  correctly formatted.
* **Identify Missing Feeds:** They can detect if there are any
  packages in the `pkgsrc-*` repositories that have updates but are
  not yet reflected in the `urls.opml` feed.
* **Identify Redundant Feeds:** Conversely, they can find entries in
  the `urls.opml` that might no longer be relevant (e.g., for packages
  that have been removed).

It's recommended to run these verification scripts regularly to
maintain the accuracy and integrity of the `pkgsrcfeeds` repository.
Instructions on how to use these scripts (e.g., any specific commands
or prerequisites) you can find in `README.md` file.

By utilizing the `pkgsrcfeeds` repository and its associated tools,
Zeppe-Lin developers can efficiently track and manage package updates
for new releases.

### 4.2.2. Updating and Building the Toolchain in `pkgsrc-core`

A fundamental part of preparing a new Zeppe-Lin release is updating
and rebuilding the core toolchain within the `pkgsrc-core` repository.
This ensures that we have a modern and consistent base for building
all other packages. Due to the intricate dependencies between these
components, they must be updated and built in a specific order.

**Important Build Order:**

The following packages within `pkgsrc-core` constitute the core
toolchain and must be built in this precise sequence:

0. ~`linux-headers`~ *(not really)*
1. `glibc` and `glibc-32` *(This package also includes the `linux-headers`)*
2. `binutils`
3. `gcc`
4. `libtool`
5. `binutils` *(built again)*
6. `glibc` and `glibc-32` *(built again)*
7. `libtool` *(built again)*

**Why this Order Matters:**

This specific build order is essential due to the dependencies between
these core components. For instance, `gcc` relies on `binutils` for
assembling and linking, and both depend on the fundamental system
libraries provided by `glibc`. The multiple build passes ensure that
each component is built and linked against the newly updated versions
of its dependencies.

**Steps to Update and Build the Toolchain:**

1. **Navigate to `pkgsrc-core`:** Open your terminal and navigate to
   your local clone of the `pkgsrc-core` repository.
2. **Checkout the Release Branch:** Ensure you are on the correct
   release branch you created earlier (e.g., `1.x`).
3. **Update Package Definitions:** Following the process outlined in
   the previous section, update the `Pkgfile` and related files (like
   `.md5sum`, `.footprint`) for `glibc`, `glibc-32`, `binutils`,
   `gcc`, and `libtool` to the desired new versions.
4. **Build the Toolchain in the Specified Order:** Use the `pkgman`
   command to build and install each component individually, strictly
   adhering to the order listed above. For example:

       pkgman update -fr -d --group \
           glibc{,-32} binutils gcc libtool binutils glibc libtool

5. **Thorough Testing:** After the toolchain has been built, it is
   absolutely critical to perform extensive testing. This involves
   building other core packages and potentially a rootfs archive
   to ensure the new toolchain is stable and functioning correctly.

**Potential Pitfalls:**

Updating the toolchain can be a complex and time-consuming process. Be
prepared to encounter build failures, linker errors, or subtle runtime
issues. Carefully review build logs and don't hesitate to seek help
from the Zeppe-Lin community if you run into problems, and look at
Linux From Scratch guys how they resolved it.

### 4.3. Preparing the Root Filesystem Image

With the toolchain updated and ready, the next critical step is to
assemble the core of our Zeppe-Lin system: the root filesystem image.
This image contains the fundamental files and directories that the
operating system needs for chroot installation. The primary tool we
use for this task is called **`mkrootfs`**.

#### 4.3.1. Introduction to `mkrootfs`

`mkrootfs` is a powerful utility that builds a customized root
filesystem for Zeppe-Lin. It operates by calling `pkgman(1)` in the
background to build and install packages into a specified working
directory. After installation, it utilizes `revdep(1)` to check this
directory for any broken libraries (broken `.so` files), ensuring the
integrity of our root filesystem.

**Key Concepts and Features of `mkrootfs`:**

* **Package-Based Installation via `pkgman`:** `mkrootfs` relies on
  `pkgman` to handle the building and installation of packages into
  the root filesystem.
* **Dependency Resolution:** `pkgman` automatically resolves package
  dependencies, ensuring all necessary components are included.
* **Integrity Check with `revdep`:** The `revdep` utility is used to
  verify that no installed libraries have unresolved dependencies,
  which could lead to runtime errors.
* **Configuration File (`/etc/mkrootfs/config`):** The behavior of
  `mkrootfs` is primarily controlled by the configuration file located
  at `/etc/mkrootfs/config`. This file defines several important
  parameters, including:
    * **`ROOTFS_DIR`:** The working directory where the root
      filesystem is built (defaults to `/tmp/rootfs-$(date
      +%F)-$(uname -m)/`). **Caution:** If you are using `/tmp` as a
      `tmpfs` (mounted in memory), be mindful of potential space
      limitations.
    * **`PACKAGES`:** The list of packages to be built and installed
      into the root filesystem (defaults to all packages in the `core`
      `pkgsrc` collection).
    * **`ROOTFS_TAR`:** The filename for the resulting compressed
      tarball of the root filesystem (defaults to
      `$ROOTFS_DIR.tar.xz`).
    * **`PKGMK_CONF`:** An optional path to an alternate configuration
      file for `pkgmk(8)`.
    * **`PKGMAN_CONF`:** An optional path to an alternate
      configuration file for `pkgman(1)`.
* **Command-Line Options:** The `mkrootfs` command itself provides
  several options to override the configuration file settings or
  specify additional actions. Some of the key options include:
    * `-B`: Prepare the rootfs directory.
    * `-C`: Check the rootfs directory for missing libraries (using
      `revdep`).
    * `-T`: Compress the rootfs directory to create the tarball.
    * `-c <conffile>`: Specify an alternate configuration file.
    * `-r <rootfsdir>`: Specify an alternate rootfs directory.
    * `-t <tarball>`: Specify an alternate output tarball filename.
    * `-x <pkgmk_conffile>`: Specify an alternate `pkgmk.conf` file.
    * `-y <pkgman_conffile>`: Specify an alternate `pkgman.conf` file.
    * `<pkgname> ...`: Optionally specify a list of packages to build
      and install instead of relying on the `PACKAGES` setting in the
      configuration file.

**Why `mkrootfs`?**

Using `mkrootfs` automates and simplifies the process of creating a
functional Zeppe-Lin root filesystem. It handles package installation,
dependency resolution, and basic integrity checking, ensuring a
consistent and reliable foundation for your Zeppe-Lin release.

In the next subsection, we will guide you through the step-by-step
process of using `mkrootfs` to create a Zeppe-Lin root filesystem
image for your new release, starting with configuring the
`/etc/mkrootfs/config` file or using command-line options.

#### 4.3.2. Step-by-Step Rootfs Creation

Now that we've been introduced to `mkrootfs`, let's get our hands
dirty and walk through the process of creating a Zeppe-Lin root
filesystem image.

**Steps:**

1. **Configure the `mkrootfs` Configuration File:** The primary way to
   control what goes into our root filesystem is by editing the
   configuration file located at `/etc/mkrootfs/config`. You'll need
   root privileges to modify this file. Open it with your favorite
   text editor.

2. **Define Key Variables:** Inside the configuration file, you'll
    find several variables you can adjust:

   * **`ROOTFS_DIR`:** This specifies the working directory where
     `mkrootfs` will build the filesystem. The default is usually
     `/tmp/rootfs-$(date +%F)-$(uname -m)/`. You can change this if
     you prefer a different location, but be cautious if using `/tmp`
     as a `tmpfs` with limited space.

   * **`ROOTFS_TAR`:** This defines the path and filename of the
     output compressed tarball that will contain your root filesystem.
     It's good practice to choose a descriptive name that includes the
     version and architecture (e.g.,
     `/path/to/output/rootfs-1.0-x86_64.tar.xz`).

   * **`PACKAGES`:** This is where you list the packages that you want
     to be installed into your root filesystem. **For official
     Zeppe-Lin releases, the default setting in `/etc/mkrootfs/config`
     is typically used, which builds and installs all packages from
     the `core` `pkgsrc` collection.** This is usually defined as:

         PACKAGES=$(pkgman printf "%n\n" --no-std-config \
                 --config-set="pkgsrcdir /usr/src/pkgsrc-core")

     Users can customize this variable to include additional packages
     for their own builds, for example:

         PACKAGES="$PACKAGES mycoolpackage1 mycoolpackage2"

     However, for the official Zeppe-Lin release process we are
     documenting here, we generally rely on the default behavior of
     including all of `pkgsrc-core`.

   * **`PKGMK_CONF`** and **`PKGMAN_CONF`:** These optional variables
     allow you to specify alternate configuration files for the
     `pkgmk` and `pkgman` utilities if you have custom build or
     installation settings you want to use for the rootfs creation.

3. **Save the Configuration File:** Once you have made the necessary
   changes, save the `/etc/mkrootfs/config` file.

4. **Run the `mkrootfs` Command:** Open your terminal and execute the
   `mkrootfs` command as root (e.g., using `sudo`):

        sudo mkrootfs -BCT

   `mkrootfs` will then read the configuration file, create the
   working directory (if it doesn't exist), and use `pkgman` to build
   and install the packages listed in the `PACKAGES` variable into
   this directory. You'll see output from `pkgman` as it progresses.
   For this is responsible `-B` option passed to `mkrootfs`.

5. **Monitor the Build Process:** Any errors during the package build
   or installation process will be displayed in the log file specified
   as `ROOTFS_LOG` in `/etc/mkrootfs/config`. You'll need to
   investigate and resolve these issues if they occur.

6. **Library Dependency Check:** After the packages are installed,
   `mkrootfs` will automatically run `revdep` to check for any broken
   shared library dependencies within the newly created root
   filesystem. If any are found, you'll need to address them by
   ensuring the necessary libraries are included in your `PACKAGES`
   list or by fixing the package definitions.
   For this is responsible `-C` option passed to `mkrootfs`.

7. **Create the Tarball:** If the process completes without errors and
   no broken libraries are found, `mkrootfs` will then compress the
   contents of the `ROOTFS_DIR` into a tarball file named as specified
   by the `ROOTFS_TAR` variable.
   For this is responsible `-T` option passed to `mkrootfs`.

8. **Locate the Output Tarball:** Once the command finishes, the
   resulting root filesystem tarball will be located at the path you
   defined in the `ROOTFS_TAR` variable in your configuration file.

**Alternative: Using Command-Line Options:**

You can also use command-line options with `mkrootfs` to override the
configuration file or to specify packages directly. For example:

    sudo mkrootfs -r /my/custom/builddir -t /tmp/myrootfs.tar.xz \
        $(pkgman printf "%n\n" \
            --no-std-config \
            --config-set="pkgsrcdir /usr/src/pkgsrc-core") \
        mypkg1 mypkg2 ...

You can even specify another `pkgsrc` collection to be built and
installed, just add, e.g., `--config-append="pkgsrcdir
/usr/src/pkgsrc-system"` to the example above.

Refer to the `mkrootfs(8)` man page for a complete list of available
command-line options.

With the successful completion of these steps, you will have a
Zeppe-Lin root filesystem tarball ready for the next stages of the
release process!

#### 4.3.3. Understanding the Output Files

Once the `mkrootfs` process has successfully completed, it will have
produced one or more important output files. Let's take a closer look
at what these are:

1. **The Root Filesystem Tarball (`ROOTFS_TAR`):** This is the main
   artifact created by `mkrootfs`. It's a compressed tar archive
   (typically in the `.tar.xz` format as we configured) containing the
   entire root filesystem structure that we just built.

   * **Contents:** Inside this tarball, you'll find a hierarchical
     directory structure starting from the root (`/`). This structure
     includes all the essential directories like `bin`, `sbin`, `etc`,
     `lib`, `usr`, `var`, `tmp`, `proc`, `sys`, and `dev`. It also
     contains the system files, libraries, and applications from all
     the packages that were built and installed from `pkgsrc-core` (or
     any other collections you specified).

   * **Filename:** The name of this tarball is determined by the
     `ROOTFS_TAR` variable in your `/etc/mkrootfs/config` file (e.g.,
     `rootfs-1.0-x86_64.tar.xz`).

   * **Usage:** This tarball is the core of your Zeppe-Lin release. It
     will be used for installation purposes.

2. **The `mkrootfs` Log File (`ROOTFS_LOG`):** As defined by the
   `ROOTFS_LOG` variable in `/etc/mkrootfs/config`, `mkrootfs` also
   generates a log file. By default, this is often located in `/tmp`
   and named something like `rootfs-YYYY-MM-DD-ARCH.log`.

   * **Contents:** This log file contains a detailed record of the
     entire `mkrootfs` process. This includes:
        * The specific `pkgman` commands that were executed to build
          and install each package.
        * Any warnings or error messages that occurred during the
          build or installation.
        * The output from the `revdep` check that verifies the
          integrity of the libraries.
        * Information about the creation of the final tarball.

   * **Usage:** This log file is invaluable for troubleshooting. If
     you encounter any issues with the root filesystem image or if the
     `mkrootfs` process failed, this log file should be your first
     point of reference to understand what went wrong.

**In essence:**

* The **root filesystem tarball** is the final product – the assembled
  core of our Zeppe-Lin system.
* The **`mkrootfs` log file** is the detailed record of how this
  product was created and can be crucial for debugging.

Now that we know what these output files are, are you ready to talk
about an optional cleanup step we can take?

#### 4.3.4. Cleanup (Optional)

Once you have successfully created the root filesystem tarball using
`mkrootfs`, you might want to perform an optional cleanup step. This
primarily involves removing the working directory that `mkrootfs` used
to build the filesystem.

**Why Consider Cleanup?**

* **Disk Space:** The working directory specified by the `ROOTFS_DIR`
  variable in your `/etc/mkrootfs/config` file (typically under
  `/tmp`) can consume a significant amount of disk space, especially
  after building all the packages from `pkgsrc-core`. Removing this
  directory can free up valuable space.
* **Organization:** If you perform multiple `mkrootfs` runs, cleaning
  up the old working directories can help keep your `/tmp` directory
  (or whichever location you used) tidy and prevent confusion.

**How to Perform Cleanup:**

To remove the working directory, you can use the `rm` command with the
`-rf` options. **Be absolutely sure** that the `mkrootfs` process
completed successfully and you have the final `.tar.xz` file before
you proceed with this step, as the working directory will be
permanently deleted.

Assuming you used the default `ROOTFS_DIR`, you would typically run
something like:

    sudo rm -rf /tmp/rootfs-*-$(uname -m)/

**Important Notes:**

* **Verify Success:** Double-check the mkrootfs output and ensure you
  have the root filesystem tarball before running the cleanup command.
* **Custom ROOTFS_DIR:** If you modified the `ROOTFS_DIR` variable in
  your `/etc/mkrootfs/config` file, make sure to adjust the path in
  the `rm` command accordingly.

**When Might You Skip Cleanup?**

There are a few scenarios where you might choose to skip the cleanup
step:

* **Debugging:** If the `mkrootfs` process encountered any errors,
  leaving the working directory intact can be helpful for inspecting
  the partially built filesystem and the `pkgman` logs to diagnose the
  issue.
* **Potential for Incremental Builds (Advanced):** In some advanced
  cases, if you are making small changes and rebuilding the root
  filesystem, you might be able to leverage some of the already built
  packages in the working directory to speed up subsequent runs.
  However, this is not the standard `mkrootfs` workflow and would
  likely require manual intervention and a good understanding of the
  build process.

For most standard release preparations, once you have the final root
filesystem tarball, it's generally safe and recommended to clean up
the working directory to conserve disk space.

### 4.4. Preparing the Official Release for Distribution

#### 4.4.1. Signing the Rootfs Tarball

To ensure the authenticity and integrity of our Zeppe-Lin release, we
need to digitally sign the root filesystem tarball. This allows users
to verify that the file hasn't been tampered with since we created it.
We'll use the `gpg` (GNU Privacy Guard) tool for this.

**Prerequisites:**

* You need to have `gpg` installed on your system. If not, you can
  usually install it using your package manager (e.g.,
  `sudo pkgman install --deps --group gnupg`).
* You need access to the private key that is used to sign Zeppe-Lin
  releases. This key should be securely stored and protected with a
  strong passphrase.

**Steps to Sign the Rootfs Tarball:**

1. **Navigate to the Directory:** Open your terminal and navigate to
   the directory where your root filesystem tarball (`ROOTFS_TAR` from
   your `mkrootfs.config`, e.g., `rootfs-1.0-x86_64.tar.xz`) is
   located.

2. **Sign the Tarball:** Use the following command to create a
   detached ASCII-armored signature file:

        gpg --detach-sig --armor \
            --output rootfs-1.0-x86_64.tar.xz.sig \
            rootfs-1.0-x86_64.tar.xz

   Let's break down this command:
   * `gpg`: Invokes the GNU Privacy Guard tool.
   * `--detach-sig`: Creates a detached signature file, which is
     separate from the data being signed. This is generally preferred
     for distributing signatures of binary files.
   * `--armor`: Generates an ASCII-armored output, making the
     signature file text-based and easier to share.
   * `--output rootfs-1.0-x86_64.tar.xz.sig`: Specifies the name of
     the output signature file. We typically append `.sig` to the
     original tarball name.
   * `rootfs-1.0-x86_64.tar.xz`: The name of the root filesystem
     tarball you created with `mkrootfs`.

   You might be prompted to enter the passphrase for your private key.

3. **Verify the Signature (Optional but Recommended):** You can verify
   that the signature was created correctly using the corresponding
   public key. Assuming you have the Zeppe-Lin public key in your
   keyring, you can use the following command:

        gpg --verify rootfs-1.0-x86_64.tar.xz.sig rootfs-1.0-x86_64.tar.xz

   This command should output a message indicating that the signature
   is good and was made by the key associated with Zeppe-Lin.

4. **Distribute the Signature File:** Along with the
   `rootfs-1.0-x86_64.tar.xz` file, you will also distribute the
   `rootfs-1.0-x86_64.tar.xz.sig` file. Users can then use this
   signature file and the official Zeppe-Lin public key to verify the
   integrity of the downloaded tarball.

**Important Considerations for Zeppe-Lin Releases:**

* **Official Signing Key:** Ensure you are using the correct official
  Zeppe-Lin private key for signing the release.
* **Public Key Availability:** The corresponding public key must be
  readily available on the Zeppe-Lin website
  (`zeppe-lin/zeppe-lin.github.io`) so that users can easily obtain it
  for verification.

Once you have successfully signed the root filesystem tarball, you've
taken a significant step in ensuring the security and trustworthiness
of your Zeppe-Lin release!

#### 4.4.2. Preparing Release Notes

Ahoy, wordsmith! Now that our treasure is secured with a signature,
it's time to chart our voyage and tell the world what wonders await in
this new Zeppe-Lin release! Preparing comprehensive and informative
release notes is crucial for our users. It's their guide to
understanding what's new, improved, or changed in this version.

**Why are Release Notes Important?**

* **Transparency:** They inform users about the changes they can
  expect.
* **Guidance:** They help users understand how to use new features or
  adapt to changes.
* **Attribution:** They provide an opportunity to acknowledge
  contributors and their efforts.
* **Historical Record:** They serve as a record of the evolution of
  Zeppe-Lin.

**What to Include in Zeppe-Lin Release Notes:**

Drawing inspiration from the release notes for **Zeppe-Lin v1.0: The
Maiden Voyage**, your release notes should aim to cover the following
key areas:

1. **Introduction:** Begin with a welcoming overview of the release,
   including the version number, release date, and a catchy name or
   theme if applicable. Briefly highlight the significance of this
   release.

2. **Incompatible Changes:** Clearly list any changes that might break
   compatibility with previous versions and require user intervention
   during upgrades. Provide specific instructions or workarounds if
   necessary.

3. **New Features:** Detail the exciting new features and
   functionalities introduced in this release. Explain their purpose,
   how to use them, and any potential benefits for the user.

4. **Package Changes:** Provide a structured breakdown of changes
   within each of the Zeppe-Lin package source repositories
   (`pkgsrc-core`, `pkgsrc-system`, `pkgsrc-xorg`, `pkgsrc-desktop`,
   and any other relevant unofficial collections). For each
   repository, you should list:
    * **New Packages:** Packages that have been added in this release.
    * **Removed Packages:** Packages that have been removed.
    * **Key Changes:** Highlight any significant updates or
      modifications to existing packages beyond version bumps.

5. **Cover Artwork:** Describe the concept and meaning behind the
   release's visual artwork. Include a link to the artwork if possible
   and mention the licensing terms.

6. **Kernel:** Specify the version of the Linux kernel included in
   this release, along with any notable configurations or patches
   (e.g., LTS status).

7. **Toolchain:** List the versions of the core toolchain components,
   such as `glibc`, `gcc`, and `binutils`.

8. **X11:** If applicable, provide the versions of the X Window System
   components, such as the X server and Mesa.

9. **Changelogs:** Include links to detailed changelogs for each of
   the `pkgsrc` repositories, allowing users to see the complete list
   of changes.

10. **Download:** Provide clear and direct links to the signed root
    filesystem archive, its signature file, and any other relevant
    download files (like binary package archives, if offered).

11. **Checksums:** Include checksums (e.g., SHA256) for all the
    download files to enable users to verify their integrity.

12. **Installation and Upgrade Instructions:** Provide or link to
    clear instructions on how to install the new release or upgrade
    from a previous one (usually to the handbook).

13. **Contributors:** Acknowledge and thank the individuals who
    contributed to the release.

**Format and Location:**

As we discussed earlier, release notes are typically written in
Markdown format and published on the Zeppe-Lin website.
~~A summary or link should also be included in the Git tag message.~~

By following this structure, inspired by the Zeppe-Lin v1.0 release
notes, you can create informative and helpful documentation for your
users.

#### 4.4.3. Creating a Git Tag in `pkgsrc-core`

Once we have prepared our release notes and are satisfied with the
state of our release branch (e.g., `1.x`), the next crucial step is to
create a Git tag in the `pkgsrc-core` repository. This tag acts as a
permanent marker, pointing to the specific commit that represents our
new Zeppe-Lin release.

**Why Create a Git Tag?**

* **Immutable Snapshot:** A tag represents a specific point in the
  history of the repository. Once created and pushed, it should
  generally not be moved or changed, providing a stable reference to
  the release.
* **Release Identification:** Tags provide a human-readable name (the
  version number) for the release, making it easy to refer to and
  check out the exact code that was released.
* **Historical Record:** Tags serve as important milestones in the
  project's history.

**Steps to Create and Push a Git Tag:**

1. **Navigate to `pkgsrc-core`:** Open your terminal and navigate to
   your local clone of the `pkgsrc-core` repository.

2. **Ensure You Are on the Release Branch:** Make sure you have
   checked out the correct release branch (e.g., `1.x`) that contains
   all the changes for this release. It's good practice to ensure your
   local branch is up-to-date with the remote repository.

        git checkout 1.x
        git pull origin 1.x

3. **Create an Annotated Tag:** We will create an annotated tag, which
   includes a message and the tagger information. The tag name should
   typically be the version number of the release, **prefixed with
   `v`** (e.g., `v1.0`).

        git tag -a v1.0 -m "Zeppe-Lin v1.0: The Maiden Voyage - See full release notes at [link to your release notes]"

   Replace `[link to your release notes]` with the actual URL of your
   release notes on the Zeppe-Lin website, e.g.,
   <https://zeppe-lin.github.io/relnotes-v1.0.html>.

   * `-a`: This option tells Git to create an annotated tag.
   * `v1.0`: This is the name of the tag.
   * `-m "..."`: This adds a message to the tag, providing a brief
     description of the release and a link to the full release notes.

4. **Push the Tag to the Remote Repository:** By default, `git push`
   only pushes commits, not tags. You need to explicitly push the
   newly created tag to the remote `pkgsrc-core` repository on GitHub.

        git push origin v1.0

   Alternatively, you can push all local tags that haven't been pushed
   yet using:

        git push origin --tags

**Important Considerations:**

* **Tag Naming Convention:** Be consistent with your tag naming. Using
  `v` followed by the version number is a common and recommended
  practice.
* **Tag Message:** Write a clear and informative tag message.
  Including a link to the release notes is very helpful for anyone
  looking at the tag in the future.
* **Tag the Correct Commit:** Ensure that your release branch is
  pointing to the exact commit you want to associate with the release
  before creating the tag.
* **Immutability of Tags:** Once a tag is created and pushed, it's
  generally considered immutable. If you make a mistake, you would
  typically create a new tag or, with caution, delete and recreate the
  tag (which is generally discouraged for public repositories).

With the Git tag created and pushed, we have officially marked this
version of Zeppe-Lin in our source code history!

#### 4.4.4. Creating the Release Announcement on GitHub

GitHub provides a good platform to announce our new Zeppe-Lin
release to the world. Creating a release on GitHub links our Git tag
with a dedicated page where we can provide release notes, download
links, and more.

**Steps to Create a Release Announcement:**

1. **Navigate to the `pkgsrc-core` Repository:** Go to the Zeppe-Lin
   `pkgsrc-core` repository on GitHub in your web browser.

2. **Go to the "Releases" Section:** On the repository page, look for
   the "Releases" section. It's usually located on the right sidebar
   or under the "Code" tab. Click on it.

3. **Click "Create a new release" or "Draft a new release":** You'll
   likely see a button to create a new release. If you have previous
   releases, it might say "Draft a new release." Click on the
   appropriate button.

4. **Choose Your Tag:** In the "Tag version" dropdown menu, select the
   Git tag you just created and pushed (e.g., `v1.0`).

5. **Give Your Release a Title:** Enter a descriptive title for your
   release. This could be the version number (e.g., `Zeppe-Lin v1.0`)
   or something more evocative like `Zeppe-Lin v1.0: The Maiden
   Voyage`.

6. **Describe Your Release:** In the "Description" field, you can
   provide the full release notes or a summary. Since we've already
   crafted detailed release notes, it's a good idea to provide a
   concise summary here and then link to the full notes on the
   Zeppe-Lin website. You can use Markdown formatting in this section.

   For example, you might write something like:

    ```markdown
    We are proud to announce the release of Zeppe-Lin v1.0, codenamed
    "The Maiden Voyage"! This marks a significant milestone as our
    first stable major release, bringing numerous improvements and new
    features.

    **Key Highlights:**

    * Binary package support for `pkgsrc-core`
    * Enhanced package management with PAX & CAPS in `pkgutils`
    * Standard C compilers as separate packages (`c89`, `c99`, `c17`)
    * Improved desktop experience with `dumb_runtime_dir` PAM module
    * ... (list a few other key highlights)

    For a complete list of changes and download links, please see the
    full release notes on the Zeppe-Lin website: [Link to your full
    release notes]
    ```

7. **Attach Release Files:** You can upload the signed root filesystem
   tarball (`rootfs-1.0-x86_64.tar.xz`) and its signature file
   (`rootfs-1.0-x86_64.tar.xz.sig`) to this release. This makes it
   easy for users to download the official release files directly from
   GitHub. Drag and drop the files or use the "Attach files" option.

8. **Mark as a Pre-release (If Applicable):** If this is a pre-release
   (like an alpha or beta), check the box that says "This is a
   pre-release." For a stable release like v1.0, you'll typically
   leave this unchecked.

9. **Click "Publish release":** Once you've filled in all the details
   and attached the files, click the "Publish release" button.

**Benefits of a GitHub Release:**

* **Easy Discovery:** Makes the release easily discoverable for users
  of the repository.
* **Linked to the Tag:** Clearly associates the release with the
  specific version of the code.
* **Download Management:** Provides a convenient way for users to
  download the release files.
* **Notifications:** GitHub can notify users who are watching the
  repository about new releases.

With our release announced on GitHub, the Zeppe-Lin community can now
easily find and download our latest creation!

#### 4.4.5. Creating the Release Announcement File (`relnotes`)

For Zeppe-Lin, the official release notes are created and managed
within the `zeppe-lin.github.io` repository, which hosts our website.
This allows for richer formatting using Markdown and seamless
integration with our online presence.

**Process for Creating the Release Announcement:**

1. **Navigate to the `zeppe-lin.github.io` Repository:** Open your
   terminal and navigate to your local clone of the
   `zeppe-lin.github.io` repository.

2. **Locate the `/relnotes/` Directory:** Within this repository, you
   will find a directory named `relnotes`. This is where the Markdown
   files for our release notes are stored.

3. **Create a Markdown File:** Create a new Markdown file named
   `relnotes-v<VERSION>.md` (e.g., `relnotes-v1.0.md`) within the
   `/relnotes/` directory. This file will contain the full content of
   your release notes, following the structure we outlined in section
   [4.4.2. Prepare Release Notes](#442-prepare-release-notes).
   You can use Markdown syntax for formatting.

4. **Include a Banner Link:** Within this Markdown file, you will also
   include a link or reference to the release banner artwork.
   Typically, this is done by linking to an HTML file named
   `banner-v<VERSION>.html` (e.g., `banner-v1.0.html`) which resides
   in the same `/relnotes/` directory. This HTML file will then
   contain the necessary code to display the banner image (usually an
   `<img>` tag).

5. **Commit and Push Changes:** Once you have created and populated
   the `relnotes-v<VERSION>.md` file (and the corresponding
   `banner-v<VERSION>.html` file, which we'll discuss in the next
   section), commit these changes to your local repository and push
   them to the remote `zeppe-lin.github.io` repository.

6. **CI/CD Process:** Our Continuous Integration and Continuous
   Deployment (CI/CD) system will automatically detect these changes.
   It will then process the `relnotes-v<VERSION>.md` file, likely
   using a static site generator (like Jekyll or Hugo), to convert it
   into a static HTML page. This page will be published on the
   Zeppe-Lin website at a URL like
   `zeppe-lin.github.io/relnotes-v<VERSION>.html`.

**Example:**

For Zeppe-Lin v1.0, the release notes are in
`/relnotes/relnotes-v1.0.md` and the banner link is in
`/relnotes/banner-v1.0.html`. These are then published on the website.

**Key Update:**

The official release notes for Zeppe-Lin are managed as Markdown files
within the website's repository, allowing for version control and
automated publication to `zeppe-lin.github.io`.

Now that we have the correct understanding of how the release notes
file is created and managed, are you ready to move on to **4.4.6.
Creating the Release Banner (Cover Artwork)**, where we'll likely be
creating that `banner-v<VERSION>.html` file and ensuring our artwork
is ready?

#### 4.4.6. Creating the Release Banner (Cover Artwork)

A visually appealing release banner (or cover artwork) is an important
part of announcing a new Zeppe-Lin release. It helps to create a
distinct identity for the release and can be used in the release
notes, announcements, and on the website.

**Creating the Artwork:**

The creation of the actual artwork is a creative process. The
Zeppe-Lin project has a tradition of unique and symbolic cover art.
The artwork should ideally reflect the theme or key aspects of the
release.

**Integrating with the Website:**

The banner artwork is integrated into the Zeppe-Lin website in a
couple of key places within the `zeppe-lin.github.io` repository:

1. **Release-Specific Banner:** As we discussed, in the `/relnotes/`
   directory, we create a file named `banner-v<VERSION>.html` (e.g.,
   `banner-v1.0.html`). This file contains the HTML to display the
   artwork image. The `relnotes-v<VERSION>.md` file then links to this
   HTML file.

2. **Main Website Banner:** The main page of the Zeppe-Lin website
   (`zeppe-lin.github.io`) features a prominent hero artwork. This is
   controlled by the `/index/banner.html` file. **After the release is
   official, this file needs to be updated to point to the new
   release's artwork.** This typically involves modifying the `src`
   attribute of the `<img>` tag within this file to point to the new
   artwork image (which should also be added to the `artwork`
   repository).

**Steps to Prepare the Banner Artwork:**

1. **Create the Artwork:** Design and create the visual artwork for
   the release. Ensure it is in a web-friendly format (e.g., PNG,
   JPEG).

2. **Store the Artwork:** Place the artwork image file within the
   `artwork` repository.

3. **Create `banner-v<VERSION>.html`:** In the `/relnotes/` directory
   of the `zeppe-lin.github.io` repository, create the HTML file to
   display the release-specific banner, as we discussed before.

4. **Link in Release Notes:** Ensure your `relnotes-v<VERSION>.md`
   file links to the `banner-v<VERSION>.html` file.

5. **Commit and Push:** Commit these changes to the
   `zeppe-lin.github.io` repository and push them.

**Updating the Main Website Banner (Post-Release Step):**

After the release is officially out, remember to **edit the
`/index/banner.html` file** to update the hero artwork on the main
website. This will likely involve changing the path to the new artwork
image.

By taking these steps, we ensure our release has compelling visual
representation across both the release notes and the main Zeppe-Lin
website.

## 4.5. Post-Release Steps

Once the new Zeppe-Lin release is out, our work isn't quite finished.
Here are some important post-release steps to ensure a smooth
experience for our users and to prepare for the future:

##### 4.5.1. Updating the User Handbook

As discussed, the user handbook (`handbook/handbook.md` in the
`zeppe-lin.github.io` repository) needs to be updated to reflect the
new release. This includes verifying generic instructions, updating
version-specific information, adding new content for new features, and
checking download links.

By default, the handbook does not contain release-specific things. But
it never hurts to double-check.

##### 4.5.2. Announcing on GitHub Discussions

To ensure the Zeppe-Lin community is aware of the new release, we
should announce it on our official forum, which is
**GitHub Discussions** located at
[https://github.com/orgs/zeppe-lin/discussions/](https://github.com/orgs/zeppe-lin/discussions/).
A new thread should be started in the **Announcements** category:
[https://github.com/orgs/zeppe-lin/discussions/categories/announcements/](https://github.com/orgs/zeppe-lin/discussions/categories/announcements/).
The announcement should typically include:

* The release name and version number.
* A brief summary of the key highlights and new features.
* A link to the official release notes on the Zeppe-Lin website.
* Links to download the root filesystem archive and its signature from
  the GitHub releases page (and potentially any other mirrors).

Since, our `relnotes-v<VERSION>.md` is already prepared, it can be
just copied there.

##### 4.5.3. **Updating the Main Website's Latest Release Pointer**

The main Zeppe-Lin website (`zeppe-lin.github.io`) has a section that
points to the latest release. This needs to be updated in the
`index/index.md` file within the `zeppe-lin.github.io` repository.
Ensure that the version number and links to the release notes are
correct for the new release.

##### 4.5.4. **Ensuring Accurate Download Links in Release Notes**

Since the Zeppe-Lin website doesn't have a separate download page, all
download links for the root filesystem archive, signature file, and
any other release artifacts are included directly within the
`relnotes-v<VERSION>.md` file. **It is therefore critical to
meticulously double-check that all these links within the release
notes file are correct and point to the actual location of the release
files on GitHub (or any other distribution mirrors).**

##### 4.5.5. Updating Documentation Links

Review all documentation, including the user handbook and this
developer handbook, to ensure that any links to specific releases or
versions are updated to point to the new release where appropriate.
This might involve checking links within the text as well as any
version selection mechanisms on the website.

##### 4.5.6. Monitoring Feedback and Bug Reports

After the release, it's crucial to monitor feedback from users through
GitHub Discussions and the GitHub Issues tracker. Pay close attention
to bug reports and address any critical issues that arise. This might
lead to patch releases or updates in the future.

##### 4.5.7. Starting Development on the Next Release

With the current release successfully launched, the development team
can begin planning and working on the next version of Zeppe-Lin. This
involves discussing new features, bug fixes, and improvements to be
included in the subsequent release cycle.

#### 4.6. Conclusion

Congratulations, Captain! We have now navigated through all the
essential steps for preparing and releasing a new version of
Zeppe-Lin. From the initial preparations in our `pkgsrc` repositories
to the final announcements and post-release tasks, we have a
comprehensive guide to ensure a smooth and successful release process.

Remember that meticulous attention to detail at each stage is crucial
for delivering a stable and well-received release to our users. By
following these guidelines, we can continue to provide a
high-quality operating system to the Zeppe-Lin community.

Fair winds and following seas on your next release voyage!

