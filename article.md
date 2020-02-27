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

PROJECTS := scripts/resbrowser.js

index.html: ${PROJECTS} article.md
	@pandoc ${OPTIONS} ${FILTER} article.md -o index.html
<<resource-browser-makefile>>
<<projects>>
```

There's also custom CSS which is again extended throughout the document.

```{.css file=custom.css}
<<custom-css>>
```

# Trying out Elm

Entry level: beginner

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

Over the years I've stumbled over a number of interesting articles which I've
kept links to in various formats. Now it's time to make the list searchable and
on the web rather than the odd chat history or markdown file.

The "Resource Browser" consists of just four sections of code with not the best
of code until the intended audience of one can update it with a better data
structure and algorithm.

```{.elm file=projects/elm/resbrowser/src/ResourceBrowser.elm}
<<resbrowser-main>>
<<resbrowser-model>>
<<resbrowser-update>>
<<resbrowser-view>>
```

### The Model

First we define the model with a given order to sort the results in. This is all
the state we need for this application as we're only tracking what the user
wants to find.

```{.elm #resbrowser-model}
type alias Model = Order
```

The `Order` is dependent on the search field or the tags depending on which the
user decides to use and the initial model sets this to empty indicating there's
no current search.

```{.elm #resbrowser-model}
type Order
  = TagName String
  | Name String

init : Model
init = Name ""
```

This concludes the model definition.

### Update

Whenever the user types in the input box we'll get a pre-defined event. In this
case we only care of the order they wish to sort and filter by so the update
consists of just setting the new order.

```{.elm #resbrowser-update}
type Msg
  = SortBy Order

update : Msg -> Model -> Model
update msg _ =
  case msg of
    SortBy order -> order
```

And that concludes updating... not much to see here.

### View

```{.elm #resbrowser-view}
view : Model -> Html Msg
view order =
  div []
    [ div []
      [ text "search for resources: "
      , input [ onInput (SortBy << Name) ] []
      , text " or by "
      , List.map tagButton Resources.tags
        |> div [ class "resource-tag-search" ]
        |> \x -> span [ class "resource-tag-container" ] [ text "[tag]", x]
      ]
    , filterAndSortBy order
      |> List.map viewResource
      |> div []
    ]
```

For each resource the title and tags are drawn on the same line with a custom
style.

```{.elm #resbrowser-view}
viewResource : Resource -> Html Msg
viewResource {title, url, tags} =
  let
    res = List.map tagButton tags
  in
    div [ class "resource" ]
      [ div [ class "resource-link" ] [ a [ href url ] [ text title ] ]
      , div [ class "resource-tags" ] res
      ]
```

Tags really only send a `SortBy` message when clicked to update the view.

```{.elm #resbrowser-view}
tagButton x =
  button
    [ onClick (SortBy (TagName x)), class "resource-tag" ]
    [text ("#" ++ x)]
```

But they look a bit plain without a bit of style so lets add some.

```{.css #custom-css}
.resource-tag {
  margin-top: 2px;
  margin-bottom: 2px;
  margin-left: 2px;
  margin-right: 2px;
  border-style: none;
  box-shadow: 1px 2px 4px #ccccc8;
  background-color: #fffff8;
}

.resource-tag-container {
  position: relative;
}

.resource-tag-search {
  display: none;
  position: absolute;
  width: 600px;
  background: #fffff8;
  x: +10%;
}

.resource-tag-container:hover .resource-tag-search {
  display: block;
}

.resource-tags {
  display: flex;
  justify-content: flex-end;
}

.resource {
  display: flex;
  margin-top: 5px;
  justify-content: space-between;
  width: 44em;
}

@media (max-width: 800px) {
  .resource {
    width: 100%;
  }
}
```

#### Sorting & Filtering

Since there's quite a few articles it's better to both filter and sort them but
only if the user searches by title.

```{.elm #resbrowser-view}
filterAndSortBy order =
  case order of
    Name "" -> []
    Name name -> List.filter (byOrder order) Resources.resources
              |> List.sortWith (distance name)
    TagName _ -> List.filter (byOrder order) Resources.resources
```

Filtering out any entries not containing the string brings the focus on a
smaller set of results at the cost of being sensitive to typos.

```{.elm #resbrowser-view}
byOrder order r =
  case order of
    Name name -> String.contains name (String.toLower r.title)
    TagName name -> List.any (\x -> x == name) r.tags
```

After filtering the results it would be good if they were sorted by the closest
so far but we don't really have enough to know what the search is for. Thus we
guess by taking the distance between titles and the search string.

```{.elm #resbrowser-view}
distance from left right =
  let
    index c =
      case String.indices (String.fromChar c) from of
        [] -> 0
        x :: xs -> x
    score c acc = acc + index c
    suml = String.foldl score 0 left.title
    sumr = String.foldl score 0 right.title
  in
    compare sumr suml
```

### Main

Now imports you probably wanted at the start are relatively small except from
`Resources` which isn't shown in this document.

```{.elm #resbrowser-main}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Resources exposing (Resource)
```

Main just packages up the three steps in a `Browser.sandbox`.

```{.elm #resbrowser-main}
main = Browser.sandbox
  { init = init
  , update = update
  , view = view
  }
```

Finally to build the project we add it to the Makefile.

```{.make #resource-browser-makefile}
RESBROWSER := projects/elm/resbrowser/src/ResourceBrowser.elm
scripts/resbrowser.js: ${RESBROWSER}
	cd ./projects/elm/resbrowser/ && \
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

# Zig on the web

Writing web applications is rather comfortable in elm but sometimes it's nice to
try something new and different. Zig is one language I've been interested in for
a while and would like to get to know better as it supports^[LLVM provides most
of the work currently for cross-compilation of zig.] multiple platforms
including freestanding which I've taken more of an interest in within the
context of [unikernels](unikernel.org/projects). Back to the point, I like zig.

So why not try a web application? One of the targets is WebAssembly after all...
and that is how this section came to be.

## Build script for WebAssembly

First, the general structure of zig build scripts involves importing the
`Builder` module which gives access to the various configuration objects used
for setting compiler flags, dependencies, and so on.

```{.zig #zotw-imports}
const Builder = @import("std").build.Builder;
```

We'll also need the `builtin` module since we'll need to refer to WebAssembly
directly as a compilation target rather than the default which is the current
platform zig is compiling on.

```{.zig #zotw-imports}
const builtin = @import("builtin");
```

The structure of the build script itself is just the one function with the
imports at the top^[Imports can be anywhere within a scope and need not be
declared at the top of the file, however, it's cleaner to declare them before
use.] and `build` which takes a build context, configures it, then passes
control back to zig's build system.

```{.zig file=projects/zig/zig-on-the-web/build.zig}
<<zotw-imports>>
pub fn build(b: *Builder) void {
    <<zotw-configure-library-and-abi>>
    <<zotw-add-test-hook>>
}
```

From the reference we get default mode as this application doesn't have any
fancy options and register it as a static library. This is important,
registering this as an application won't yield valid WebAssembly for use in the
example as there's no runtime and thus no logical entry-point.

```{.zig #zotw-configure-library}
const mode = b.standardReleaseOptions();
const lib = b.addStaticLibrary("gamesvonkoch.github.io", "src/web.zig");
```

Then on to setting the configuration where the build mode is left to the
default.

```{.zig #zotw-configure-library}
lib.setBuildMode(mode);
```

Then we declare the target to be `wasm32`^[At the time of writing, most modern
browsers only support wasm32 where wasm64 is experimental and thus needs to be
enabled by the user in their browser configuration. This may be fine for playing
with larger address ranges but in the case of building applications we can use
now this is a bit impractical.] on a `freestanding` platform (no operating
system) and with and ABI of `none` since we don't need to conform to any call
standard outside of our own.

```{.zig #zotw-configure-library}
lib.setTarget(builtin.Arch.wasm32, builtin.Os.freestanding, builtin.Abi.none);
lib.install();
```

Now building an application larger than a file or two without tests ends up
being rather tedious so lets declare some.

Adding tests is pretty similar to registering the shared library with the
exception of allowing us to run the code within test blocks directly.

```{.zig #zotw-add-test-hook}
var main_tests = b.addTest("src/main.zig");
main_tests.setBuildMode(mode);
```

Since `test` isn't a command available to the builder by default we must add it
ourselves by extending the builder with out own test depending on the step
above. Of course tests are rather common in zig and thus we haven't needed to
write our own function for it as it's taken care of above.

```{.zig #zotw-add-test-hook}
const test_step = b.step("test", "Run library tests");
test_step.dependOn(&main_tests.step);
```

And that concludes the build script for zig and WebAssembly.

## No really, on the web

So far we've only seen a build script with relatively little code and there
isn't so much here either.

Starting with the `web` module which only exports the other modules but gives a
good overview of the parts to be implemented in this article.

```{.zig file=projects/zig/zig-on-the-web/src/web.zig}
const window = @import("window.zig");
```



```{.zig file=projects/zig/zig-on-the-web/src/window.zig}
extern fn _alert(msg: [*]const u8, len: usize) void;

pub fn alert(msg: []u8) void {
  _alert(msg, msg.len);
}
```
