.POSIX:

include ../config.mk

CSS = style.css tango.css zenburn.css

all:

install:
	mkdir -p $(DESTDIR)$(WWWDIR)/css
	cp -f $(CSS) $(DESTDIR)$(WWWDIR)/css

uninstall:
	cd $(DESTDIR)$(WWWDIR)/css && rm -f $(CSS)

clean:

.PHONY: all install uninstall clean
