.POSIX:

include ../config.mk

MD = codebook.md handbook.md index.md \
     v0.99.md v0.99.1.md v1.0.md v1.1.md v1.2.md

HTML = $(MD:.md=.html)

all: $(HTML)

%.html: %.md template.html.in
	$(PANDOC) $(PFLAGS) $< -o $@

install: all
	mkdir -p $(DESTDIR)$(WWWDIR)/
	cp -f $(HTML) $(DESTDIR)$(WWWDIR)/

uninstall:
	cd $(DESTDIR)$(WWWDIR) && rm -f $(HTML)

clean:
	rm -f $(HTML)

.PHONY: all install uninstall clean
