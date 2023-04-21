.POSIX:

CURRENT_RELEASE_VERSION = $(shell git -C /usr/src/pkgsrc describe --tags --abbrev=0)
CURRENT_RELEASE_URL = https://github.com/zeppe-lin/pkgsrc/releases/latest

PODS += $(wildcard /usr/src/cryptmount/*.pod)
PODS += $(wildcard /usr/src/handbook/*.pod)
PODS += $(wildcard /usr/src/mkinitramfs/*.pod)
PODS += $(wildcard /usr/src/mkrootfs/*.pod)
PODS += $(wildcard /usr/src/pkgmaint/*.pod)
PODS += $(wildcard /usr/src/pkgman/*.pod)
PODS += $(wildcard /usr/src/pkgmk/*.pod)
PODS += $(wildcard /usr/src/pkgutils/*.pod)
PODS += $(wildcard /usr/src/rc/*.pod)
PODS += $(wildcard /usr/src/rejmerge/*.pod)
PODS += $(wildcard /usr/src/revdep/*.pod)
PODS += $(wildcard /usr/src/start-stop-daemon/*.pod)

HTML  = $(PODS:.pod=.html)

all: index.html $(HTML)

%.html: %.pod
	./fixmanurls.sh $^ \
		| pod2html --css=css/pod2html.css --cachedir=/tmp - \
		| sed 's|http:///HACK4RELURL\/||g' \
		> $(notdir $@)

$(filter %.html,$(HTML)): %.html: %.pod

index.html:
	./fixmanurls.sh index.pod \
		| sed -e "s|@CURRENT_RELEASE_VERSION@|${CURRENT_RELEASE_VERSION}|g" \
		      -e "s|@CURRENT_RELEASE_URL@|${CURRENT_RELEASE_URL}|g" \
		| pod2html --noindex --css=css/pod2html_min.css --cachedir=/tmp - \
		| sed 's|http:///HACK4RELURL/||g' \
		> $@

check:
	@echo "=======> Check URLs for response code"
	@grep -Eiho "https?://[^\"\\'>< ]+" *.* \
	| xargs -P10 -I{} curl -o /dev/null -sw "[%{http_code}] %{url}\n" '{}' \
	| sort -u

update:
	git add .
	git commit -m "Regenerate HTML from PODs: $(shell date)" .

clean:
	rm -f $(notdir $(HTML)) index.html

webserver:
	python3 -m http.server

.PHONY: index.html
