.POSIX:

PODS += $(wildcard /usr/src/zeppe-lin/core/pkgman/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/pkgmk/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/pkgutils/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/rc/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/rejmerge/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/revdep/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/core/start-stop-daemon/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/system/handbook/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/system/mkinitramfs/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/system/mkrootfs/src/*.pod)
PODS += $(wildcard /usr/src/zeppe-lin/system/pkgmaint/src/*.pod)

HTML  = $(PODS:.pod=.html)

all: index.html $(HTML)

%.html: %.pod
	pod2html --css=css/pod2html.css --cachedir=/tmp $^ > $(notdir $@)

$(filter %.html,$(HTML)): %.html: %.pod

index.html: /usr/src/zeppe-lin/system/handbook/src/handbook.7.html
	cp -f $(notdir $^) $@

update:
	git add .
	git commit -m "update $(shell date)" .

clean:
	rm -f $(notdir $(HTML)) index.html

webserver:
	python3 -m http.server

.PHONY: index.html
