#!/bin/sh

skeleton="<link rel="stylesheet" href="css/skeleton.css"/>"
normalize="<link rel="stylesheet" href="css/skeleton.css"/>"
site="<link rel="stylesheet" href="css/site.css"/>"
header="${header}${normalize}${site}"

generated="Generated on `date +'%F %H:%M'`"
currentyear=`date +'%Y'`
futuredate=`[ $currentyear -gt 2019 ] && echo " - ${currentyear}"`
footer="<div>Copyright (c) 2019${futuredate} Simon A. Nielsen Knights</div><div>${Generated}</div>"

echo -n "<html><head>${header}</head><h1>Levy's blog</h1><body><div class=\"container\"><ul>" > index.html
for m in `ls md`
do
	name=`echo $m | sed 's,\.[a-z]*$,,'`

	# html
	echo "generating ${name}.html" && \
		pandoc md/$m -o tmp/${name}.html && \
		echo -n "<html><head>${header}</head><body>" > html/${name}.html && \
		cat tmp/${name}.html >> html/${name}.html && \
		echo -n "</body></html>" >> html/${name}.html && \
		rm tmp/*.html

	# pdf
	echo "generating ${name}.pdf" && pandoc md/$m -o pdf/${name}.pdf

	# index
	title=`echo $name | sed -e 's,\([0-9][0-9]*\)-\([0-9][0-9]*\)-\([0-9][0-9]*\),\1/\2/\3 |,' -e 's,-, ,g'`
	echo -n "<li><a href=\"html/${name}.html\">${title}</a></li>" >> index.html
done
echo -n "</ul></div><footer>${footer}</footer></body></html>" >> index.html
