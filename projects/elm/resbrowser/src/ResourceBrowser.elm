-- ------ language="Elm" file="projects/elm/resbrowser/src/ResourceBrowser.elm" project://article.md#96
-- ------ begin <<resbrowser-main>>[0] project://article.md#285
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Resources exposing (Resource)
-- ------ end
-- ------ begin <<resbrowser-main>>[1] project://article.md#295
main = Browser.sandbox
  { init = init
  , update = update
  , view = view
  }
-- ------ end
-- ------ begin <<resbrowser-model>>[0] project://article.md#109
type alias Model = Order
-- ------ end
-- ------ begin <<resbrowser-model>>[1] project://article.md#117
type Order
  = TagName String
  | Name String

init : Model
init = Name ""
-- ------ end
-- ------ begin <<resbrowser-update>>[0] project://article.md#134
type Msg
  = SortBy Order

update : Msg -> Model -> Model
update msg _ =
  case msg of
    SortBy order -> order
-- ------ end
-- ------ begin <<resbrowser-view>>[0] project://article.md#148
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
-- ------ end
-- ------ begin <<resbrowser-view>>[1] project://article.md#169
viewResource : Resource -> Html Msg
viewResource {title, url, tags} =
  let
    res = List.map tagButton tags
  in
    div [ class "resource" ]
      [ div [ class "resource-link" ] [ a [ href url ] [ text title ] ]
      , div [ class "resource-tags" ] res
      ]
-- ------ end
-- ------ begin <<resbrowser-view>>[2] project://article.md#183
tagButton x =
  button
    [ onClick (SortBy (TagName x)), class "resource-tag" ]
    [text ("#" ++ x)]
-- ------ end
-- ------ begin <<resbrowser-view>>[3] project://article.md#243
filterAndSortBy order =
  case order of
    Name "" -> []
    Name name -> List.filter (byOrder order) Resources.resources
              |> List.sortWith (distance name)
    TagName _ -> List.filter (byOrder order) Resources.resources
-- ------ end
-- ------ begin <<resbrowser-view>>[4] project://article.md#255
byOrder order r =
  case order of
    Name name -> String.contains name (String.toLower r.title)
    TagName name -> List.any (\x -> x == name) r.tags
-- ------ end
-- ------ begin <<resbrowser-view>>[5] project://article.md#266
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
-- ------ end
-- ------ end
