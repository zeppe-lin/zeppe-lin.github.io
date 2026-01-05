# Zeppe-Lin documentation build

SITE_DOMAIN = zeppe-lin.org
CSS      := style.css
TEMPLATE := template.html.in
PANDOC   ?= pandoc
PFLAGS   := -s --from=markdown-ascii_identifiers --to=html \
		--syntax-highlighting=zenburn --css=$(CSS) \
		--template=$(TEMPLATE) --toc --number-sections=true
MD       := $(filter-out README.md,$(wildcard *.md))
HTML     := $(MD:.md=.html)
STATIC   := robots.txt sitemap.xml

all: $(HTML) $(STATIC)

%.html: %.md $(CSS) $(TEMPLATE)
	@printf '  PANDOC  %s\n' $<
	@$(PANDOC) $(PFLAGS) $< -o $@

robots.txt: gen_robots.sh
	@./gen_robots.sh $(SITE_DOMAIN)

sitemap.xml: gen_sitemap.sh $(HTML)
	@./gen_sitemap.sh $(SITE_DOMAIN)

clean:
	@rm -f $(HTML) $(STATIC)

.PHONY: all clean
