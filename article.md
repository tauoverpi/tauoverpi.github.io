---
title: Tau's Articles
...

# The setup

Everything is built by a single Makefile invoking language specific
build-systems. The file is extended throughout the document with instructions
for each listed project in their respective section.

```{.make file=Makefile}
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

.PHONY: blog
blog: resbrowser
	@pandoc ${OPTIONS} ${FILTER} article.md -o index.html
<<resource-browser-makefile>>
```

There's also custom CSS which is again extended throughout the document.

```{.css file=custom.css}
<<custom-css>>
```

# Trying out Elm

There are a lot of programming languages out there with flashy features and meta
programming capabilities embedding the whole language within itself. This isn't
about those languages, this is about Elm.

Elm is a language I've avoided for a while due to a number of reasons:

1. It's a front-end language which I tend not to need as most projects reside
   outside of a browser.
2. It doesn't have type-classes and thus I assumed I'd need to write the same
   code for several different types over and over again.
3. An endless pursuit of suckless[@catvh] qualities for software since complex software
   is the enemy of correctness.

Despite those I eventually decided Elm would be the language for a future
project.

## Building a resource browser

```{.elm file=projects/elm/resbrowser/src/ResourceBrowser.elm}
<<resbrowser-main>>
<<resbrowser-model>>
<<resbrowser-update>>
<<resbrowser-view>>
```

### The Model

```{.elm #resbrowser-model}
type Order
  = TagName String
  | Name String

type alias Model =
  { resources: List Resource
  , order: Order
  }

init : Model
init =
  { resources = Resources.resources
  , order = Name ""
  }
```

### Update

```{.elm #resbrowser-update}
type Msg
  = SortBy Order

update : Msg -> Model -> Model
update msg model =
  case msg of
    SortBy order -> { model | order = order }
```

### View

```{.elm #resbrowser-view}
view : Model -> Html Msg
view {resources, order} =
  let
    byOrder r =
      case order of
        Name name -> String.contains name (String.toLower r.title)
        TagName name -> List.any (\x -> x == name) r.tags
    hidden =
      case order of
        Name "" -> True
        _       -> False
    sorted =
      if hidden
        then []
        else List.filter byOrder resources
  in
    section []
      [ div []
        [ text "search for resources: "
        , input [ onInput (SortBy << Name) ] []
        ]
      , div [] (List.map viewResource sorted)
      ]
```

```{.elm #resbrowser-view}
viewResource : Resource -> Html Msg
viewResource {title, url, tags} =
  let
    tag x =
      button
        [ onClick (SortBy (TagName x))
        , class "resource-tag"
        ]
        [text ("#" ++ x)]
    res = List.map tag tags
  in
    div [ class "resource" ]
      [ div [ class "resource-link" ] [ a [ href url ] [ text title ] ]
      , div [ class "resource-tags" ] res
      ]
```

But they look a bit plain without a bit of style so lets add some.

```{.css #custom-css}
.resource-tag {
  margin-left: 2px;
  margin-right: 2px;
  border-style: none;
  box-shadow: 1px 2px 4px #ccccc8;
  background-color: #fffff8;
}

.resource {
  display: flex;
  width: 55%;
  margin-top: 5px;
  justify-content: space-between;
}
```

### Main

```{.elm #resbrowser-main}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Resources exposing (Resource)
```

```{.elm #resbrowser-main}
main = Browser.sandbox
  { init = init
  , update = update
  , view = view
  }
```

Finally to build the project

```{.make #resource-browser-makefile}
.PHONY: resbrowser
resbrowser:
	@cd ./projects/elm/resbrowser/ && \
		elm make src/ResourceBrowser.elm \
			--optimize --output=../../../scripts/resbrowser.js
```

And here it is! Try entering "category theory" or similar and watch the results
roll-in.

<div id="resbrowser"></div>
<script src="scripts/resbrowser.js"></script>
<script>
var resbrowser = Elm.Main.init({
	node: document.getElementById("resbrowser")
});
</script>

# Zig in the browser

```{.zig file=projects/zig/ziginbrowser/src/main.zig}
const std = @import("std");
```
