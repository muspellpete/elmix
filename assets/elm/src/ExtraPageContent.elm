module ExtraPageContent exposing (pageContent)

import Browser
import Html exposing (button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Weather exposing (Model, Msg(..))


pageContent : Model -> Browser.Document Msg
pageContent model =
    { title = "Elmix"
    , body =
        [ div [] [ button [ onClick Weather.RefreshData, class "bg-blue-400 m-b10" ] [ text "Back" ] ]
        , div [] [ text "Extra Button page" ]
        ]
    }
