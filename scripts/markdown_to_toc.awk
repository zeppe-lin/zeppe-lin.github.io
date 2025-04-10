# markdown_to_toc.awk
# This script processes Markdown input to generate an unordered list
# (<ul>) representing a table of contents (TOC).  It extracts headings
# (lines starting with '#') and creates links to them using generated
# anchor IDs.

# Include the anchor ID generation function.
#@include "lib_anchor_id.awk"

# BEGIN block: Executed once at the start of processing.
BEGIN {
	# Set the field separator to '#' for easier extraction of
	# heading text.
	FS = "#";

	# Print the opening tag of the unordered list for the TOC.
	print "<ul id=\"index\">";

	# Let "Back Home" be first item on the list, pointing to home.
	print "  <li><a href=\"index.html\">Home</a>";
}

# This block is executed for each line of input.
/^#+/ {
	# If the line starts with one or more '#' (indicating a
	# heading):

	# Store the entire line in the 'title' variable.
	title = $0;

	# Remove the leading '#' characters and any following
	# whitespace.
	sub(/^#+\s*/, "", title);

	# Remove any leading or trailing whitespace from the title.
	gsub(/^\s+|\s+$/, "", title);

	# Generate a URL-friendly anchor ID from the heading title.
	anchor_id = generate_anchor_id(title);

	# Print an <li> element with a link (<a> tag) to the generated
	# anchor ID.
	print "  <li><a href=\"#" anchor_id "\">" title "</a></li>";
}

# END block: Executed once at the end of processing.
END {
	# Print the closing tag of the unordered list for the TOC.
	print "</ul>";
}

# End of file.
