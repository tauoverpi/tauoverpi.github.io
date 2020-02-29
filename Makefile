## ------ language="Make" file="Makefile" project://article.md#12
## ------ begin <<makefile-pandoc-filters>>[0] project://article.md#22
FILTER := --filter pandoc-crossref
FILTER += --filter pandoc-sidenote
FILTER += --filter pandoc-filter-graphviz
FILTER += --filter pandoc-citeproc
## ------ end
## ------ begin <<makefile-pandoc-options>>[0] project://article.md#29
OPTIONS := --standalone
OPTIONS += --table-of-contents
OPTIONS += --number-sections
OPTIONS += --reference-links
OPTIONS += --csl ieee.csl
OPTIONS += --metadata-file=metadata.yaml
OPTIONS += --highlight-style monochrome

HTMLOPTIONS := --section-divs
HTMLOPTIONS += --css tufte.css
HTMLOPTIONS += --css custom.css

PDFOPTIONS := --template=handout.tex
## ------ end
## ------ begin <<makefile-projects>>[0] project://article.md#45
PROJECTS := scripts/resbrowser.js
## ------ end
## ------ begin <<makefile-html>>[0] project://article.md#49
.PHONY: all
all:: index.html
index.html: ${PROJECTS} article.md Makefile metadata.yaml
	pandoc ${OPTIONS} ${HTMLOPTIONS} ${FILTER} article.md -o index.html

#index.pdf: article.md Makefile metadata.yaml
#	pandoc ${OPTIONS} ${PDFOPTIONS} ${FILTER} article.md -o index.pdf
## ------ begin <<resource-browser-makefile>>[0] project://article.md#305
RESBROWSER := projects/elm/resbrowser/src/ResourceBrowser.elm
scripts/resbrowser.js: ${RESBROWSER}
	cd ./projects/elm/resbrowser/ && \
		elm make src/ResourceBrowser.elm \
			--optimize --output=../../../scripts/resbrowser.js
## ------ end
## ------ end
## ------ end
