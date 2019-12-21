#!/bin/sh

source="md"
target="html"
title="Levy's Articles"

currentyear=`date +'%Y'`
futuredate=`[ $currentyear -gt 2019 ] && echo " - ${currentyear}"`

cat << EOF > header.html
		<meta charset="UTF-8">
		<link href="https://fonts.googleapis.com/css?family=IBM+Plex+Mono&display=swap" rel="stylesheet">
		<link href="https://fonts.googleapis.com/css?family=Raleway:300,400&display=swap" rel="stylesheet">
EOF

cat << EOF > index.html
<html>
	<head>
`cat header.html`
	</head>
	<body>
		<header>
			<link rel="stylesheet" href="css/skeleton.css"/>
			<link rel="stylesheet" href="css/site.css"/>
			<h1 class="title">${title}</h1>
		</header>
		<main class="container">
			<div class="row">
				<div class="six columns">
					<h3>Articles</h3>
					<ul>
EOF

for article in `ls ${source} | sort -r`
do
	echo "given article ${article}"
	name=`echo $article | sed 's,\.[a-z]*$,,'`
	title=`echo $name | sed \
		-e 's,\([0-9][0-9]*\)-\([0-9][0-9]*\)-\([0-9][0-9]*\),\1/\2/\3 |,' \
		-e 's,-, ,g'`
	echo "title is: ${title}"
	echo "name is: ${name}"

	tage=`stat -f %m ${target}/${name}.html`
	oage=`stat -f %m ${source}/${article}`
	[ -z "$tage" ] && tage=0 && oage=1
	if [ $oage -gt $tage ]
	then
		echo "generating ${name}.html"
		pandoc -t html5 -o ${target}/${name}.html ${source}/${article} \
			--section-divs \
			--css ../css/normalize.css \
			--highlight-style=monochrome \
			--css ../css/skeleton.css \
			--css ../css/site.css \
			--include-in-header header.html \
			--mathml
	fi

	cat << EOF >> index.html
						<li><a href="${target}/${name}.html">${title}</a></li>
EOF
done

cat << EOF >> index.html
						</ul>
					</div>
				<div class="six columns">
					<h3>Projects</h3>
					<ul>
						<li><a href="projects/BackEndLexicon2019/index.html">
							Lexicon 2019 - ASP.NET Core Assignments
						</a></li>
					</ul>
					<h3>Slides</h3>
				</div>
			</div>
		</main>
		<footer>
			Copyright (c) 2019${futuredate} Simon A. Nielsen Knights
		</footer>
	</body>
</html>
EOF
