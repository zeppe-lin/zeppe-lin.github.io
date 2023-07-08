GREPOPT = --exclude-dir=.git --exclude-dir=.github --exclude-dir=font \
	  --exclude-dir=images -R .

deadlinks:
	@echo "=======> Check for dead links"
	@grep -Eiho "https?://[^\"\\'>< ]+" ${GREPOPT}  \
		| grep -Ev "https?://www.gnu.org/software/somelib/index.html" \
		| grep -v fileserver.intranet           \
		| httpx -silent -fc 200 -sc

.PHONY: deadlinks
