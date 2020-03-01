module AddWeatherPageContent exposing (pageContent)

import Weather exposing (Model, Msg (..))
import Browser
import Html exposing (Html, text, input, div)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, placeholder)

pageContent : Model -> Browser.Document Msg
pageContent model =
    {title = "Elmix", body = bodyContent model }

bodyContent : Model -> List (Html Msg)
bodyContent model = 
    [ div [] [text "Add Weather page"]
    , div [] [input [ placeholder "Write new weather here", value model.inputText, onInput UpdateText ] []]
    ]