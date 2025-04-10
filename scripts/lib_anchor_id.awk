# lib_anchor_id.awk
# This file defines a reusable function to generate a URL-friendly
# anchor ID from a given text string.

function generate_anchor_id(text, id) {
	# Input: text - The string from which to generate the anchor ID.
	# Output: The generated anchor ID (returned by the function).

	# Steps:
	# 1. Convert the text to lowercase.
	id = tolower(text);
	# 2. Replace all spaces with hyphens.
	gsub(/ /, "-", id);
	# 3. Remove any characters that are not lowercase letters,
	# numbers, or hyphens.
	gsub(/[^a-z0-9-]/, "", id);
	# 4. Replace one or more consecutive hyphens with a single
	# hyphen.
	gsub(/-+/, "-", id);

	# Return the generated anchor ID.
	return id;
}

# End of file.
