#!/bin/sh

target="md"

######

skeleton="<link rel=\"stylesheet\" href=\"css/skeleton.css\"/>"
site="<link rel=\"stylesheet\" href=\"css/site.css\"/>"
meta="<meta charset=\"UTF-8\">"
fonts="<link href=\"https://fonts.googleapis.com/css?family=IBM+Plex+Mono&display=swap\" rel=\"stylesheet\">"
fonts="${fonts}<link href=\"https://fonts.googleapis.com/css?family=Raleway:300,400&display=swap\" rel=\"stylesheet\">"

generated="Generated on `date +'%F %H:%M'`"
currentyear=`date +'%Y'`
futuredate=`[ $currentyear -gt 2019 ] && echo " - ${currentyear}"`
footer="Copyright (c) 2019${futuredate} Simon A. Nielsen Knights"
header="${meta}${skeleton}${site}${fonts}"

echo -n "<html><head>${header}</head><body><h1>Levy's Articles</h1><div class=\"container\"><ul>" > index.html
echo -n "<h3>Articles</h3>" >> index.html
cat << EOF > README.md
Levy's Articles
===============

A list of partially finished things I'm working on in my spare time.
EOF
for m in `ls ${target}`
do
	name=`echo $m | sed 's,\.[a-z]*$,,'`
	title=`echo $name | sed -e 's,\([0-9][0-9]*\)-\([0-9][0-9]*\)-\([0-9][0-9]*\),\1/\2/\3 |,' -e 's,-, ,g'`

	# html
	echo "generating ${name}.html" && \
		pandoc ${target}/$m -o tmp/${name}.html -F diagrams-pandoc && \
		echo -n "<html><head>${header}</head><body>" \
		| sed 's:\(css/[a-z.]*\):../\1:g' \
		> html/${name}.html && \
		cat tmp/${name}.html \
		| sed 's:\(images/[a-z0-9.]*\):../\1:g' \
		>> html/${name}.html && \
		echo -n "<footer>${footer}</footer></body></html>" >> html/${name}.html


	echo "- [${title}](https://tauoverpi.github.com/html/${name}.html)" >> README.md

	# pdf
	# echo "generating ${name}.pdf" && pandoc ${target}/$m -o pdf/${name}.pdf -F diagrams-pandoc

	# index
	echo -n "<li><a href=\"html/${name}.html\">${title}</a></li>" >> index.html
done

echo -n "<h3>Projects</h3>" >> index.html

rm tmp/*.html
echo "" >> README.md
echo "${footer}" >> README.md
echo -n "</ul></div><footer>${footer}</footer></body></html>" >> index.html
