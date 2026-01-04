#!/bin/sh
# gen-release-changes.sh - Zeppe-Lin Release Changes generator
# Usage: ./gen-release-changes.sh TAG

set -eu

NEW_TAG="${1}"
if [ -z "${NEW_TAG}" ]; then
	echo "Usage: $0 TAG" >&2
	exit 1
fi

SRCDIR="${SRCDIR:-"/usr/src"}"
REPOS="${REPOS:-"pkgsrc-core pkgsrc-system pkgsrc-xorg pkgsrc-desktop"}"

# --- Per-repo changes ---
for repo in $REPOS; do
	case "$REPOS" in
	*' '*)
		echo
		echo "#### $repo"
		echo
		;;
	esac

	PREV_TAG=$(git -C "$SRCDIR/$repo" describe --tags --abbrev=0 "${NEW_TAG}"'^' 2>/dev/null ||
		git -C "${SRCDIR}/$repo" rev-list --max-parents=0 HEAD || true)
	CHANGES=$(git -C "$SRCDIR/$repo" diff --name-status --diff-filter=AD $PREV_TAG..$NEW_TAG |
		grep '/Pkgfile' || true)
	ADDED=$(echo "${CHANGES}" | awk '$1 == "A" {print $2}' | cut -d/ -f1 | sort -u || true)
	REMOVED=$(echo "${CHANGES}" | awk '$1 == "D" {print $2}' | cut -d/ -f1 | sort -u || true)

	if [ -n "$ADDED" ]; then
		printf '%s: ' '- New'
		for p in $ADDED; do
			printf "\`%s\` " "$p"
		done
		printf "\n"
	else
		printf '%s: *None*\n' '- New'
	fi

	if [ -n "$REMOVED" ]; then
		printf '%s: ' '- Removed'
		for p in $REMOVED; do
			printf "\`%s\` " "$p"
		done
		printf "\n"
	else
		printf '%s: *None*\n' '- Removed'
	fi
done

# End of file.
