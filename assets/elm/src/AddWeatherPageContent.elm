module AddWeatherPageContent exposing (pageContent)

import Weather exposing (Model, Msg)
import Browser
import Html exposing (text)

pageContent : Model -> Browser.Document Msg
pageContent model =
    {title = "Elmix", body = [text "Add weather page"]}