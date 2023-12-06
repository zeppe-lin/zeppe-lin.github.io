include config.mk

HTMLS = $(MANS:.gz=.html)

all: $(HTMLS) index.html handbook.7.html

%.html: %.gz
	@echo "GEN $(notdir $@)"
	@${MANDOC} ${MANDOC_OPTS} $^ > $(notdir $@)

$(filter %.html,$(HTMLS)): %.html: %.gz

index.html:
	@echo "GEN $@"
	@${POD2HTML} --noindex --css=pod2html_min.css ${POD2HTML_OPTS} index.pod > $@
	@sed -i "/<link rel=\"stylesheet\" .*/a <link rel=\"shortcut icon\" href=\"${FAVICON_URL}\">" $@

handbook.7.html:
	@echo "GEN $@"
	@$(MAKE) --quiet -C ${HANDBOOK} pod
	@perl -pe 's,L<((.+?)\(([0-9pm]+?)\))>,L<$$1|http://localhost:8000/$$2.$$3.html>,g' \
	 ${HANDBOOK}/handbook.7.pod | ${POD2HTML} --css=pod2html.css ${POD2HTML_OPTS} -     \
	 | sed 's|http://localhost:8000/||g' > $@
	@$(MAKE) --quiet -C ${HANDBOOK} clean
	@sed -i "/<link rel=\"stylesheet\" .*/a <link rel=\"shortcut icon\" href=\"${FAVICON_URL}\">" $@

check:
	@echo "=======> Check URLs for response code"
	@grep -Eiho "https?://[^\"\\'>< ]+" *.*  \
	 | xargs -P10 -I{} curl -o /dev/null     \
	   -sw "[%{http_code}] %{url}\n" '{}'    \
	 | sort -u

webserver:
	python3 -m http.server

clean:
	rm -f index.html handbook.7.html $(notdir $(HTMLS))

.PHONY: all index.html handbook.7.html clean
