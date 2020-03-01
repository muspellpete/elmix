module ExtraPageContent exposing (pageContent)

import Weather exposing (Model, Msg (..))
import Browser

import Html exposing (text, button, div)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)

pageContent : Model -> Browser.Document Msg
pageContent model =
    { title = "Elmix", body = 
        [ div [] [button [onClick Weather.RefreshData, class "bg-blue-400 m-b10"] [text "Back"]]
        , div [] [text "Extra Button page"]
        ]
    }