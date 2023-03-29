#!/bin/sh
#
# Convert pod links without urls to pod links with urls.
#

# Hack for relative urls.
WEBSITE="http:///HACK4RELURL/"
# The site that provides a man-pages which is not shipped by Zeppe-Lin website.
MANKIER="https://www.mankier.com"

sed	\
	-e "s,L<cryptmount(8)>,L<cryptmount(8)|${WEBSITE}/cryptmount.8.html>,g" \
	-e "s,L<crypttab(5)>,L<crypttab(5)|${WEBSITE}/crypttab.5.html>,g" \
	\
	-e "s,L<rc.conf(5)>,L<rc.conf(5)|${WEBSITE}/rc.conf.5.html>,g" \
	\
	-e "s,L<handbook(7)>,L<handbook(7)|${WEBSITE}/handbook.7.html>,g" \
	\
	-e "s,L<rejmerge(8)>,L<rejmerge(8)|${WEBSITE}/rejmerge.8.html>,g" \
	-e "s,L<rejmerge.conf(5)>,L<rejmerge.conf(5)|${WEBSITE}/rejmerge.conf.5.html>,g" \
	\
	-e "s,L<pkgadd(8)>,L<pkgadd(8)|${WEBSITE}/pkgadd.8.html>,g" \
	-e "s,L<pkgadd.conf(5)>,L<pkgadd.conf(5)|${WEBSITE}/pkgadd.conf.5.html>,g" \
	-e "s,L<pkgrm(8)>,L<pkgrm(8)|${WEBSITE}/pkgrm.8.html>,g" \
	-e "s,L<pkginfo(1)>,L<pkginfo(1)|${WEBSITE}/pkginfo.1.html>,g" \
	\
	-e "s,L<pkgmk(8)>,L<pkgmk(8)|${WEBSITE}/pkgmk.8.html>,g" \
	-e "s,L<pkgmk.conf(5)>,L<pkgmk.conf(5)|${WEBSITE}/pkgmk.conf.5.html>,g" \
	-e "s,L<Pkgfile(5)>,L<Pkgfile(5)|${WEBSITE}/Pkgfile.5.html>,g" \
	\
	-e "s,L<revdep(1)>,L<revdep(1)|${WEBSITE}/revdep.1.html>,g" \
	\
	-e "s,L<finddeps-distmeta(1)>,L<finddeps-distmeta(1)|${WEBSITE}/finddeps-distmeta.1.html>,g" \
	-e "s,L<finddeps-linked(1)>,L<finddeps-linked(1)|${WEBSITE}/finddeps-linked.1.html>,g" \
	-e "s,L<finddisappeared(1)>,L<finddisappeared(1)|${WEBSITE}/finddisappeared.1.html>,g" \
	-e "s,L<finddisowned(1)>,L<finddisowned(1)|${WEBSITE}/finddisowned.1.html>,g" \
	-e "s,L<findredundantdeps(1)>,L<findredundantdeps(1)|${WEBSITE}/findredundantdeps.1.html>,g" \
	\
	-e "s,L<pkgman(1)>,L<pkgman(1)|${WEBSITE}/pkgman.1.html>,g" \
	-e "s,L<pkgman-cat(1)>,L<pkgman-cat(1)|${WEBSITE}/pkgman-cat.1.html>,g" \
	-e "s,L<pkgman-current(1)>,L<pkgman-current(1)|${WEBSITE}/pkgman-current.1.html>,g" \
	-e "s,L<pkgman-dep(1)>,L<pkgman-dep(1)|${WEBSITE}/pkgman-dep.1.html>,g" \
	-e "s,L<pkgman-diff(1)>,L<pkgman-diff(1)|${WEBSITE}/pkgman-diff.1.html>,g" \
	-e "s,L<pkgman-dsearch(1)>,L<pkgman-dsearch(1)|${WEBSITE}/pkgman-dsearch.1.html>,g" \
	-e "s,L<pkgman-dumpconfig(1)>,L<pkgman-dumpconfig(1)|${WEBSITE}/pkgman-dumpconfig.1.html>,g" \
	-e "s,L<pkgman-edit(8)>,L<pkgman-edit(8)|${WEBSITE}/pkgman-edit.8.html>,g" \
	-e "s,L<pkgman-fsearch(1)>,L<pkgman-fsearch(1)|${WEBSITE}/pkgman-fsearch.1.html>,g" \
	-e "s,L<pkgman-info(1)>,L<pkgman-info(1)|${WEBSITE}/pkgman-info.1.html>,g" \
	-e "s,L<pkgman-install(8)>,L<pkgman-install(8)|${WEBSITE}/pkgman-install.8.html>,g" \
	-e "s,L<pkgman-isinst(1)>,L<pkgman-isinst(1)|${WEBSITE}/pkgman-isinst.1.html>,g" \
	-e "s,L<pkgman-list-dup(1)>,L<pkgman-list-dup(1)|${WEBSITE}/pkgman-list-dup.1.html>,g" \
	-e "s,L<pkgman-list-locked(1)>,L<pkgman-list-locked(1)|${WEBSITE}/pkgman-list-locked.1.html>,g" \
	-e "s,L<pkgman-list-nodependents(1)>,L<pkgman-list-nodependents(1)|${WEBSITE}/pkgman-list-nodependents.1.html>,g" \
	-e "s,L<pkgman-list-orphans(1)>,L<pkgman-list-orphans(1)|${WEBSITE}/pkgman-list-orphans.1.html>,g" \
	-e "s,L<pkgman-list(1)>,L<pkgman-list(1)|${WEBSITE}/pkgman-list.1.html>,g" \
	-e "s,L<pkgman-lock(8)>,L<pkgman-lock(8)|${WEBSITE}/pkgman-lock.8.html>,g" \
	-e "s,L<pkgman-ls(1)>,L<pkgman-ls(1)|${WEBSITE}/pkgman-ls.1.html>,g" \
	-e "s,L<pkgman-path(1)>,L<pkgman-path(1)|${WEBSITE}/pkgman-path.1.html>,g" \
	-e "s,L<pkgman-printf(1)>,L<pkgman-printf(1)|${WEBSITE}/pkgman-printf.1.html>,g" \
	-e "s,L<pkgman-rdep(1)>,L<pkgman-rdep(1)|${WEBSITE}/pkgman-rdep.1.html>,g" \
	-e "s,L<pkgman-readme(1)>,L<pkgman-readme(1)|${WEBSITE}/pkgman-readme.1.html>,g" \
	-e "s,L<pkgman-remove(8)>,L<pkgman-remove(8)|${WEBSITE}/pkgman-remove.8.html>,g" \
	-e "s,L<pkgman-search(1)>,L<pkgman-search(1)|${WEBSITE}/pkgman-search.1.html>,g" \
	-e "s,L<pkgman-sysup(8)>,L<pkgman-sysup(8)|${WEBSITE}/pkgman-sysup.8.html>,g" \
	-e "s,L<pkgman-unlock(8)>,L<pkgman-unlock(8)|${WEBSITE}/pkgman-unlock.8.html>,g" \
	-e "s,L<pkgman-update(8)>,L<pkgman-update(8)|${WEBSITE}/pkgman-update.8.html>,g" \
	-e "s,L<pkgman.conf(5)>,L<pkgman.conf(5)|${WEBSITE}/pkgman.conf.5.html>,g" \
	\
	-e "s,L<mkrootfs(8)>,L<mkrootfs(8)|${WEBSITE}/mkrootfs.8.html>,g" \
	-e "s,L<mkrootfs.config(5)>,L<mkrootfs.config(5)|${WEBSITE}/mkrootfs.config.5.html>,g" \
	-e "s,L<mkrootfs.release(7)>,L<mkrootfs.release(7)|${WEBSITE}/mkrootfs.release.7.html>,g" \
	\
	-e "s,L<mkinitramfs(8)>,L<mkinitramfs(8)|${WEBSITE}/mkinitramfs.8.html>,g" \
	-e "s,L<mkinitramfs.config(5)>,L<mkinitramfs.config(5)|${WEBSITE}/mkinitramfs.config.5.html>,g" \
	-e "s,L<mkinitramfs.cmdline(7)>,L<mkinitramfs.cmdline(7)|${WEBSITE}/mkinitramfs.cmdline.7.html>,g" \
	-e "s,L<mkinitramfs.hooks(7)>,L<mkinitramfs.hooks(7)|${WEBSITE}/mkinitramfs.hooks.7.html>,g" \
	\
	-e "s,L<aria2c(1)>,L<aria2c(1)|${MANKIER}/1/aria2c>,g" \
	-e "s,L<blkid(8)>,L<blkid(8)|${MANKIER}/8/blkid>,g" \
	-e "s,L<chown(1)>,L<chown(1)|${MANKIER}/1/chown>,g" \
	-e "s,L<crypt(3)>,L<crypt(3)|${MANKIER}/3/crypt>,g" \
	-e "s,L<cryptsetup(8)>,L<cryptsetup(8)|${MANKIER}/8/cryptsetup>,g" \
	-e "s,L<curl(1)>,L<curl(1)|${MANKIER}/1/curl>,g" \
	-e "s,L<fakeroot(1)>,L<fakeroot(1)|${MANKIER}/1/fakeroot>,g" \
	-e "s,L<fnmatch(3)>,L<fnmatch(3)|${MANKIER}/3/fnmatch>,g" \
	-e "s,L<fstab(5)>,L<fstab(5)|${MANKIER}/5/fstab#Description-The_fourth_field_(fs_mntops).>,g" \
	-e "s,L<git(1)>,L<git(1)|${MANKIER}/1/git>,g" \
	-e "s,L<gpg(1)>,L<gpg(1)|${MANKIER}/1/gpg>,g" \
	-e "s,L<grep(1)>,L<grep(1)|${MANKIER}/1/grep>,g" \
	-e "s,L<killall(1)>,L<killall(1)|${MANKIER}/1/killall>,g" \
	-e "s,L<ld.so(8)>,L<ld.so(8)|${MANKIER}/8/ld.so>,g" \
	-e "s,L<ldd(1)>,L<ldd(1)|${MANKIER}/1/ldd>,g" \
	-e "s,L<loadkeys(1)>,L<loadkeys(1)|${MANKIER}/1/loadkeys>,g" \
	-e "s,L<make(1)>,L<make(1)|${MANKIER}/1/make>,g" \
	-e "s,L<mkfs(8)>,L<mkfs(8)|${MANKIER}/8/mkfs>,g" \
	-e "s,L<mkswap(8)>,L<mkswap(8)|${MANKIER}/8/mkswap>,g" \
	-e "s,L<parted(8)>,L<parted(8)|${MANKIER}/8/parted>,g" \
	-e "s,L<pod2html(1pm)>,L<pod2html(1pm)|${MANKIER}/1/pod2html>,g" \
	-e "s,L<regex(3)>,L<regex(3)|${MANKIER}/3/regex>,g" \
	-e "s,L<rfkill(8)>,L<rfkill(8)|${MANKIER}/8/rfkill>,g" \
	-e "s,L<setfont(8)>,L<setfont(8)|${MANKIER}/8/setfont>,g" \
	-e "s,L<sh(1)>,L<sh(1)|${MANKIER}/1/dash>,g" \
	-e "s,L<sh(1p)>,L<sh(1p)|${MANKIER}/1p/sh>,g" \
	-e "s,L<strip(1p)>,L<strip(1p)|${MANKIER}/1p/strip>,g" \
	-e "s,L<sudo(8)>,L<sudo(8)|${MANKIER}/8/sudo>,g" \
	-e "s,L<sysfs(5)>,L<sysfs(5)|${MANKIER}/5/sysfs>,g" \
	-e "s,L<tmpfs(5)>,L<tmpfs(5)|${MANKIER}/5/tmpfs>,g" \
	-e "s,L<udevd(8)>,L<udevd(8)|${MANKIER}/8/udevd>,g" \
	-e "s,L<wget(1)>,L<wget(1)|${MANKIER}/1/wget>,g" \
	-e "s,L<wpa_passphrase(8)>,L<wpa_passphrase(8)|${MANKIER}/8/wpa_passphrase>,g" \
	\
	-e "s,L<inittab(5)>,L<inittab(5)|https://manpages.debian.org/unstable/sysvinit-core/inittab.5.en.html>,g" \
	\
$@

# End of file.
