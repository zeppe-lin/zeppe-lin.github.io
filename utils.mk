GREPOPT = --exclude-dir=.git --exclude-dir=.github --exclude-dir=font \
	  --exclude-dir=images -R .

urlcodes:
	@echo "=======> Check URLs for non-200 response code"
	@grep -Eiho "https?://[^\"\\'>< ]+" ${GREPOPT}  \
		| grep -v fileserver.intranet           \
		| httpx -silent -fc 200 -sc

.PHONY: urlcodes
