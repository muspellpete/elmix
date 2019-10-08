module WeatherCreator exposing (..)

import Weather exposing (Msg(..))
import Html exposing (Html, button, text, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

createButton : Html Msg
createButton =
    button [(class "bg-blue-200 m-4"), (onClick AddWeather)][div [class "mx-2 my-1"] [text "Click me"]]