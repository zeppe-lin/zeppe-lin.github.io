#!/bin/sh

if [ -z "$*" ]; then
	echo "Usage: $0 <file1> <file2> ..." >&2
	exit 1
fi

scripts_dir=$(dirname "$0")

for file in "$@"; do
	case $file in
	*.md)
		awk -f "${scripts_dir}/lib_anchor_id.awk" \
		    -f "${scripts_dir}/markdown_to_toc.awk" "$file"
		smu < "$file" |
		  awk -f "${scripts_dir}/lib_anchor_id.awk" \
		      -f "${scripts_dir}/html_add_header_ids.awk"
		;;
	*.html)
		cat "$file"
		;;
	*)
		echo "$0: error: unknown file type for $file" >&2
		exit 1
		;;
	esac
done

# End of file.
