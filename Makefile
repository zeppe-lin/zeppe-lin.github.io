# Zeppe-Lin documentation build

PANDOC   ?= pandoc
CSS      := style.css
TEMPLATE := template.html.in

FLAGS    := -s \
	--from=markdown-ascii_identifiers \
	--to=html \
	--syntax-highlighting=zenburn \
	--css=$(CSS) \
	--template=$(TEMPLATE) \
	--toc \
	--number-sections=true

MD   := $(filter-out README.md,$(wildcard *.md))
HTML := $(MD:.md=.html)

all: $(HTML)

%.html: %.md $(CSS) $(TEMPLATE)
	@printf '  PANDOC  %s\n' $<
	@$(PANDOC) $(FLAGS) $< -o $@

clean:
	@rm -f $(HTML)

.PHONY: all clean
