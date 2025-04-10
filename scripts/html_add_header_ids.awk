# html_add_header_ids.awk
# This script processes HTML input and adds unique 'id' attributes to
# all heading tags (<h1> to <h6>) based on their text content.

# Include the anchor ID generation function.
#@include "lib_anchor_id.awk"

# This block is executed for each line of input.
{
	# Check if the current line contains an HTML heading tag (h1
	# to h6).
	if (match($0, /<h([1-6])([^>]*)>(.*?)<\/h[1-6]>/, arr) != 0) {
		# If a heading tag is found:

		# Extract the heading level (1 to 6) from the matched
		# pattern.
		level = arr[1];

		# Extract any existing attributes within the heading
		# tag.
		attributes = arr[2];

		# Extract the text content of the heading.
		title = arr[3];

		# Generate a URL-friendly anchor ID from the heading
		# title.
		anchor = generate_anchor_id(title);

		# Construct the new heading tag with the 'id'
		# attribute.
		new_tag = "<h" level;

		# If there were existing attributes, add them to the
		# new tag.
		if (attributes != "") {
			new_tag = new_tag " " attributes;
		}

		# Add the 'id' attribute with the generated anchor
		# value.
		new_tag = new_tag " id=\"" anchor "\">";

		# Replace the original heading tag in the current line
		# with the new tag.
		gsub(/<h[1-6]([^>]*)>/, new_tag, $0);
	}
	# Print the (potentially modified) current line.
	print;
}

# End of file.
