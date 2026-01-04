#!/bin/sh
# gen-release-components.sh - Zeppe-Lin Release Components generator

set -eu

TAG="${1}"
shift || :

COMPONENTS="$*"

if [ -z "${TAG}" ]; then
	echo "Usage: $0 TAG [component]" >&2
	echo "Available components: kernel toolchain x11" >&2
	exit 1
fi

SRCDIR="${SRCDIR:-"/usr/src"}"
REPOS="${REPOS:-"pkgsrc-core pkgsrc-system pkgsrc-xorg pkgsrc-desktop"}"
COMPONENTS="kernel toolchain x11"

if [ $# -ne 0 ]; then
	COMPONENTS="$*"
fi

# Extract version from Pkgfile at tag
pkgver() {
	repo="$1"
	pkg="$2"
	file="$SRCDIR/$repo/$pkg/Pkgfile"
	if git -C "$SRCDIR/$repo" cat-file -e "$TAG:$pkg/Pkgfile" 2>/dev/null; then
		git -C "$SRCDIR/$repo" show "$TAG:$pkg/Pkgfile" |
			awk -F= '/^version=/ {print $2; exit}' || echo "n/a"
	else
		echo "n/a"
	fi
}

# --- System components ---
for c in $COMPONENTS; do
	case "$COMPONENTS" in
	*' '*)
		case "$c" in
		kernel) echo "#### Kernel" ;;
		toolchain) echo "#### Toolchain" ;;
		x11) echo "#### X11" ;;
		esac
		echo
		;;
	esac

	case "$c" in
	kernel)
		cat <<EOF
- \`linux\` $(pkgver pkgsrc-system linux)
- \`linux-firmware\` $(pkgver pkgsrc-system linux-firmware)
EOF
		;;
	toolchain)
		cat <<EOF
- \`glibc\` $(pkgver pkgsrc-core glibc)
- \`gcc\` $(pkgver pkgsrc-core gcc)
- \`binutils\` $(pkgver pkgsrc-core binutils)
EOF
		;;
	x11)
		cat <<EOF
- \`Xorg\` $(pkgver pkgsrc-xorg xorg)
- \`xorg-server\` $(pkgver pkgsrc-xorg xorg-server)
- \`mesa\` $(pkgver pkgsrc-xorg mesa)
- \`amdgpu\` $(pkgver pkgsrc-xorg xorg-xf86-video-amdgpu)
- \`ati\` $(pkgver pkgsrc-xorg xorg-xf86-video-ati)
- \`intel\` $(pkgver pkgsrc-xorg xorg-xf86-video-intel)
- \`nouveau\` $(pkgver pkgsrc-xorg xorg-xf86-video-nouveau)
- \`vesa\` $(pkgver pkgsrc-xorg xorg-xf86-video-vesa)
EOF
		;;
	*)
		echo "$0: error: Unknown component $c" >&2
		exit 1
		;;
	esac
	echo
done

# End of file.
