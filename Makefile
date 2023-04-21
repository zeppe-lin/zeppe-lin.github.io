.POSIX:

include config.mk

PODOPTS = --noindex --css=css/pod2html_min.css --cachedir=/tmp
#PODOPTS = --css=/css/pod2html.css --cachedir=/tmp

manpages:
	$(MAKE) -C man

index.html:
	@pod2html ${PODOPTS} ${INDEX_POD} > $@

check:
	@echo "=======> Check URLs for response code"
	@grep -Eiho "https?://[^\"\\'>< ]+" *.* man/*.*  \
	 | xargs -P10 -I{} curl -o /dev/null             \
	   -sw "[%{http_code}] %{url}\n" '{}'            \
	 | sort -u

clean:
	rm -f index.html
	$(MAKE) -C man clean

.PHONY: manpages index.html clean
