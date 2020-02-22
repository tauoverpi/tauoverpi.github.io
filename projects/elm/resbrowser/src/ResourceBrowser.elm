-- ------ language="Elm" file="projects/elm/resbrowser/src/ResourceBrowser.elm" project://article.md#61
-- ------ begin <<resbrowser-main>>[0] project://article.md#166
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Browser
import Resources exposing (Resource)
-- ------ end
-- ------ begin <<resbrowser-main>>[1] project://article.md#174
main = Browser.sandbox
  { init = init
  , update = update
  , view = view
  }
-- ------ end
-- ------ begin <<resbrowser-model>>[0] project://article.md#70
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
-- ------ end
-- ------ begin <<resbrowser-update>>[0] project://article.md#89
type Msg
  = SortBy Order

update : Msg -> Model -> Model
update msg model =
  case msg of
    SortBy order -> { model | order = order }
-- ------ end
-- ------ begin <<resbrowser-view>>[0] project://article.md#101
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
-- ------ end
-- ------ begin <<resbrowser-view>>[1] project://article.md#127
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
-- ------ end
-- ------ end
