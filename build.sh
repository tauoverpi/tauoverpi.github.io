#!/bin/sh

skeleton="<link rel=\"stylesheet\" href=\"css/skeleton.css\"/>"
site="<link rel=\"stylesheet\" href=\"css/site.css\"/>"
meta="<meta charset=\"UTF-8\">"
fonts="<link href=\"https://fonts.googleapis.com/css?family=IBM+Plex+Mono&display=swap\" rel=\"stylesheet\">"
fonts="${fonts}<link href=\"https://fonts.googleapis.com/css?family=Raleway:300,400&display=swap\" rel=\"stylesheet\">"

header="${meta}${skeleton}${site}${fonts}"

generated="Generated on `date +'%F %H:%M'`"
currentyear=`date +'%Y'`
futuredate=`[ $currentyear -gt 2019 ] && echo " - ${currentyear}"`
footer="<div>Copyright (c) 2019${futuredate} Simon A. Nielsen Knights</div><div>${Generated}</div>"

background="<div class=\"stripe\"></div>"

echo -n "<html><head>${header}</head><body>${background}<h1>Levy's blog</h1><div class=\"container\"><ul>" > index.html
for m in `ls md`
do
	name=`echo $m | sed 's,\.[a-z]*$,,'`

	# html
	echo "generating ${name}.html" && \
		pandoc md/$m -o tmp/${name}.html -F diagrams-pandoc && \
		echo -n "<html><head>${header}</head><body>" \
		| sed 's:\(css/[a-z.]*\):../\1:g' \
		> html/${name}.html && \
		cat tmp/${name}.html \
		| sed 's:\(images/[a-z0-9.]*\):../\1:g' \
		>> html/${name}.html && \
		echo -n "<footer>${footer}</footer></body></html>" >> html/${name}.html && \
		rm tmp/*.html

	# pdf
	echo "generating ${name}.pdf" && pandoc md/$m -o pdf/${name}.pdf -F diagrams-pandoc

	# index
	title=`echo $name | sed -e 's,\([0-9][0-9]*\)-\([0-9][0-9]*\)-\([0-9][0-9]*\),\1/\2/\3 |,' -e 's,-, ,g'`
	echo -n "<li><a href=\"html/${name}.html\">${title}</a></li>" >> index.html
done
echo -n "</ul></div><footer>${footer}</footer></body></html>" >> index.html
