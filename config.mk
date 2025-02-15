# favicon image url
FAVICON_URL = https://raw.githubusercontent.com/zeppe-lin/artwork/master/logo-small.png

# path to the mandoc and mandoc options
# used to generate html pages for manuals
MANDOC      = /usr/bin/mandoc
MANDOC_OPTS = -T html -O style=mandoc.css,includes=%N.%S.html,man=%N.%S.html

# path to the pod2html and pod2html options
# used to generate html pages for handbook and index page
POD2HTML = /usr/bin/pod2html
POD2HTML_OPTS = --cachedir=/tmp

# path to the handbook
HANDBOOK = ${CURDIR}/../handbook

# paths to the man pages for conversion to html
MANS = \
       /usr/share/man/man1/bash.1.gz                              \
       /usr/share/man/man1/chmod.1.gz                             \
       /usr/share/man/man1/chown.1.gz                             \
       /usr/share/man/man1/cp.1.gz                                \
       /usr/share/man/man1/curl.1.gz                              \
       /usr/share/man/man1/dash.1.gz                              \
       /usr/share/man/man1/diff.1.gz                              \
       /usr/share/man/man1/fakeroot.1.gz                          \
       /usr/share/man/man1/finddepsdistmeta.1.gz                  \
       /usr/share/man/man1/finddepslinked.1.gz                    \
       /usr/share/man/man1/finddisappeared.1.gz                   \
       /usr/share/man/man1/finddisowned.1.gz                      \
       /usr/share/man/man1/findredundantdeps.1.gz                 \
       /usr/share/man/man1/getfacl.1.gz                           \
       /usr/share/man/man1/git.1.gz                               \
       /usr/share/man/man1/gpg.1.gz                               \
       /usr/share/man/man1/grep.1.gz                              \
       /usr/share/man/man1/killall.1.gz                           \
       /usr/share/man/man1/ldd.1.gz                               \
       /usr/share/man/man1/loadkeys.1.gz                          \
       /usr/share/man/man1/ls.1.gz                                \
       /usr/share/man/man1/make.1.gz                              \
       /usr/share/man/man1/more.1.gz                              \
       /usr/share/man/man1/mv.1.gz                                \
       /usr/share/man/man1/newuidmap.1.gz                         \
       /usr/share/man/man1/pkgdiff.1.gz                           \
       /usr/share/man/man1/pkginfo.1.gz                           \
       /usr/share/man/man1/pkglint.1.gz                           \
       /usr/share/man/man1/pkgman-cat.1.gz                        \
       /usr/share/man/man1/pkgman-current.1.gz                    \
       /usr/share/man/man1/pkgman-dep.1.gz                        \
       /usr/share/man/man1/pkgman-diff.1.gz                       \
       /usr/share/man/man1/pkgman-dsearch.1.gz                    \
       /usr/share/man/man1/pkgman-dumpconfig.1.gz                 \
       /usr/share/man/man1/pkgman-fsearch.1.gz                    \
       /usr/share/man/man1/pkgman-info.1.gz                       \
       /usr/share/man/man1/pkgman-isinst.1.gz                     \
       /usr/share/man/man1/pkgman-list-dup.1.gz                   \
       /usr/share/man/man1/pkgman-list-locked.1.gz                \
       /usr/share/man/man1/pkgman-list-nodependents.1.gz          \
       /usr/share/man/man1/pkgman-list-orphans.1.gz               \
       /usr/share/man/man1/pkgman-list.1.gz                       \
       /usr/share/man/man1/pkgman-ls.1.gz                         \
       /usr/share/man/man1/pkgman-path.1.gz                       \
       /usr/share/man/man1/pkgman-printf.1.gz                     \
       /usr/share/man/man1/pkgman-rdep.1.gz                       \
       /usr/share/man/man1/pkgman-readme.1.gz                     \
       /usr/share/man/man1/pkgman-search.1.gz                     \
       /usr/share/man/man1/pkgman.1.gz                            \
       /usr/share/man/man1/pod2html.1pm.gz                        \
       /usr/share/man/man1/qemu.1.gz                              \
       /usr/share/man/man1/qemuconf-import.1.gz                   \
       /usr/share/man/man1/qemuconf.1.gz                          \
       /usr/share/man/man1/revdep.1.gz                            \
       /usr/share/man/man1/sdiff.1.gz                             \
       /usr/share/man/man1/setfacl.1.gz                           \
       /usr/share/man/man1/setterm.1.gz                           \
       /usr/share/man/man1/sh.1.gz                                \
       /usr/share/man/man1/strip.1.gz                             \
       /usr/share/man/man1/tar.1.gz                               \
       /usr/share/man/man1/vi.1.gz                                \
       /usr/share/man/man1/wget.1.gz                              \
       /usr/share/man/man1p/sh.1p.gz                              \
       /usr/share/man/man1p/strip.1p.gz                           \
       /usr/share/man/man2/chdir.2.gz                             \
       /usr/share/man/man2/chmod.2.gz                             \
       /usr/share/man/man2/creat.2.gz                             \
       /usr/share/man/man2/mkdir.2.gz                             \
       /usr/share/man/man2/mknod.2.gz                             \
       /usr/share/man/man2/open.2.gz                              \
       /usr/share/man/man2/stat.2.gz                              \
       /usr/share/man/man2/umask.2.gz                             \
       /usr/share/man/man3/ExtUtils\:\:MakeMaker.3pm.gz           \
       /usr/share/man/man3/crypt.3.gz                             \
       /usr/share/man/man3/fnmatch.3.gz                           \
       /usr/share/man/man3/libelf.3.gz                            \
       /usr/share/man/man3/putenv.3.gz                            \
       /usr/share/man/man3/regex.3.gz                             \
       /usr/share/man/man5/Pkgfile.5.gz                           \
       /usr/share/man/man5/acl.5.gz                               \
       /usr/share/man/man5/crypttab.5.gz                          \
       /usr/share/man/man5/fstab.5.gz                             \
       /usr/share/man/man5/inittab.5.gz                           \
       /usr/share/man/man5/mkinitramfs.config.5.gz                \
       /usr/share/man/man5/mkrootfs.config.5.gz                   \
       /usr/share/man/man5/pkgadd.conf.5.gz                       \
       /usr/share/man/man5/pkgman.conf.5.gz                       \
       /usr/share/man/man5/pkgmk.conf.5.gz                        \
       /usr/share/man/man5/rc.conf.5.gz                           \
       /usr/share/man/man5/rejmerge.conf.5.gz                     \
       /usr/share/man/man5/revdep.d.5.gz                          \
       /usr/share/man/man5/sysfs.5.gz                             \
       /usr/share/man/man5/tmpfs.5.gz                             \
       /usr/share/man/man7/mkinitramfs.cmdline.7.gz               \
       /usr/share/man/man7/mkinitramfs.hooks.7.gz                 \
       /usr/share/man/man7/mkrootfs.release.7.gz                  \
       /usr/share/man/man7/xattr.7.gz                             \
       /usr/share/man/man8/blkid.8.gz                             \
       /usr/share/man/man8/crond.8.gz                             \
       /usr/share/man/man8/cryptmount.8.gz                        \
       /usr/share/man/man8/cryptsetup.8.gz                        \
       /usr/share/man/man8/init.8.gz                              \
       /usr/share/man/man8/ld.so.8.gz                             \
       /usr/share/man/man8/mkfs.8.gz                              \
       /usr/share/man/man8/mkinitramfs.8.gz                       \
       /usr/share/man/man8/mkrootfs.8.gz                          \
       /usr/share/man/man8/mkswap.8.gz                            \
       /usr/share/man/man8/mount.8.gz                             \
       /usr/share/man/man8/parted.8.gz                            \
       /usr/share/man/man8/pkgadd.8.gz                            \
       /usr/share/man/man8/pkgman-edit.8.gz                       \
       /usr/share/man/man8/pkgman-install.8.gz                    \
       /usr/share/man/man8/pkgman-lock.8.gz                       \
       /usr/share/man/man8/pkgman-remove.8.gz                     \
       /usr/share/man/man8/pkgman-sysup.8.gz                      \
       /usr/share/man/man8/pkgman-unlock.8.gz                     \
       /usr/share/man/man8/pkgman-update.8.gz                     \
       /usr/share/man/man8/pkgmk.8.gz                             \
       /usr/share/man/man8/pkgrm.8.gz                             \
       /usr/share/man/man8/rc.8.gz                                \
       /usr/share/man/man8/reboot.8.gz                            \
       /usr/share/man/man8/rejmerge.8.gz                          \
       /usr/share/man/man8/rfkill.8.gz                            \
       /usr/share/man/man8/seedrng.8.gz                           \
       /usr/share/man/man8/setfont.8.gz                           \
       /usr/share/man/man8/shutdown.8.gz                          \
       /usr/share/man/man8/start-stop-daemon.8.gz                 \
       /usr/share/man/man8/sudo.8.gz                              \
       /usr/share/man/man8/udevd.8.gz                             \
       /usr/share/man/man8/wpa_passphrase.8.gz                    \

# path to the output (generated) html files
DESTDIR = ${CURDIR}/www

# End of file.
