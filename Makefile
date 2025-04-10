HTML_FILES = index.html \
	     handbook.html \
	     relnotes-v1.0.html \
	     relnotes-v0.99.1.html \
	     relnotes-v0.99.html \
	     relhistory.html

# The file order matters!
index.html: templates/header.html \
	index/banner.html \
	index/index.md \
	templates/footer.html \
	templates/tail.html

handbook.html: templates/header.html \
	handbook/handbook.md \
	templates/footer.html \
	templates/tail.html

relhistory.html: templates/header.html \
	relhistory/toc.html \
	relhistory/welcome.html \
	relhistory/v1.x-series.html \
	relhistory/v0.x-series.html \
	templates/footer.html \
	templates/tail.html

relnotes-v1.0.html: templates/header.html \
	relnotes/banner-v1.0.html \
	relnotes/relnotes-v1.0.md \
	templates/footer.html \
	templates/tail.html

relnotes-v0.99.1.html: templates/header.html \
	relnotes/banner-v0.99.1.html \
	relnotes/relnotes-v0.99.1.md \
	templates/footer.html \
	templates/tail.html

relnotes-v0.99.html: templates/header.html \
	relnotes/banner-v0.99.html \
	relnotes/relnotes-v0.99.md \
	templates/footer.html \
	templates/tail.html

all: $(HTML_FILES)

%.html:
	./scripts/build_html.sh $^ > $@

clean:
	rm -f $(HTML_FILES)

.PHONY: all clean
