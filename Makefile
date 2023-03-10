.POSIX:

PODS += $(wildcard ${CURDIR}/../pkgman/*.pod)
PODS += $(wildcard ${CURDIR}/../pkgmk/*.pod)
PODS += $(wildcard ${CURDIR}/../pkgutils/*.pod)
PODS += $(wildcard ${CURDIR}/../rc/*.pod)
PODS += $(wildcard ${CURDIR}/../rejmerge/*.pod)
PODS += $(wildcard ${CURDIR}/../revdep/*.pod)
PODS += $(wildcard ${CURDIR}/../start-stop-daemon/*.pod)
PODS += $(wildcard ${CURDIR}/../handbook/*.pod)
PODS += $(wildcard ${CURDIR}/../mkinitramfs/*.pod)
PODS += $(wildcard ${CURDIR}/../mkrootfs/*.pod)
PODS += $(wildcard ${CURDIR}/../pkgmaint/*.pod)

HTML  = $(PODS:.pod=.html)

all: index.html $(HTML)

%.html: %.pod
	pod2html --css=css/pod2html.css --cachedir=/tmp $^ > $(notdir $@)

$(filter %.html,$(HTML)): %.html: %.pod

index.html: ${CURDIR}/../handbook/handbook.7.html
	cp -f $(notdir $^) $@

check:
	@echo "=======> Check URLs for response code"
	@grep -Eiho "https?://[^\"\\'>< ]+" *.* \
	| xargs -P10 -I{} curl -o /dev/null -sw "[%{http_code}] %{url}\n" '{}' \
	| sort -u

update:
	git add .
	git commit -m "update $(shell date)" .

clean:
	rm -f $(notdir $(HTML)) index.html

webserver:
	python3 -m http.server

.PHONY: index.html
