## ------ language="Make" file="Makefile" project://article.md#12
FILTER := --filter pandoc-crossref
FILTER += --filter pandoc-sidenote
FILTER += --filter pandoc-filter-graphviz
FILTER += --filter pandoc-citeproc

OPTIONS := --standalone
OPTIONS += --table-of-contents
OPTIONS += --number-sections
OPTIONS += --section-divs
OPTIONS += --reference-links
OPTIONS += --css tufte.css
OPTIONS += --css custom.css
OPTIONS += --csl ieee.csl
OPTIONS += --metadata-file=references.yaml
OPTIONS += --highlight-style monochrome

PROJECTS := scripts/resbrowser.js

index.html: ${PROJECTS} article.md
	@pandoc ${OPTIONS} ${FILTER} article.md -o index.html
## ------ begin <<resource-browser-makefile>>[0] project://article.md#282
RESBROWSER := projects/elm/resbrowser/src/ResourceBrowser.elm
scripts/resbrowser.js: ${RESBROWSER}
	cd ./projects/elm/resbrowser/ && \
		elm make src/ResourceBrowser.elm \
			--optimize --output=../../../scripts/resbrowser.js
## ------ end

## ------ end
