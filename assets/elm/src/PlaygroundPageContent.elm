module PlaygroundPageContent exposing (pageContent)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Weather exposing (Model, Msg(..))


pageContent : Model -> Browser.Document Msg
pageContent model =
    { title = "Elmix"
    , body =
        [ div [] [ button [ onClick Weather.RefreshData, class "bg-blue-400 m-b10" ] [ text "Back" ] ]
        , div [] [ text "Playground page" ]
        ]
    }
