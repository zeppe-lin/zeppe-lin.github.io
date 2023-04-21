.POSIX:

include ${CURDIR}/../config.mk

PODS    = $(foreach dir,$(POD_PATH),$(wildcard $(dir)/*.pod))
HTML    = $(PODS:.pod=.html)

FIX1    = ${CURDIR}/../fixmanurls.sh
FIX2    = sed 's|http://HACK4RELURL/||g'
PODOPTS = --css=/css/pod2html.css --cachedir=/tmp

all: $(HTML)

%.html: %.pod
	@${FIX1} $^ | pod2html ${PODOPTS} - | ${FIX2} > $(notdir $@)

$(filter %.html,$(HTML)): %.html: %.pod

clean:
	rm -fv $(notdir $(HTML))

.PHONY: clean
