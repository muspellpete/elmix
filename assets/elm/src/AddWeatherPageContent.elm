module AddWeatherPageContent exposing (pageContent)

import Weather exposing (Model, Msg (..))
import Browser
import Html exposing (Html, text, input, div)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, placeholder, class)

pageContent : Model -> Browser.Document Msg
pageContent model =
    {title = "Elmix", body = bodyContent model }

bodyContent : Model -> List (Html Msg)
bodyContent model = 
    [ div [class "mb-4 font-bold"] [ text "Add weather" ]
    , div [] [ text "Moisture:",
               input [ placeholder "Number", value (String.fromInt model.inputMoisture), onInput UpdateTextMoisture, class "ml-2 border-2 border-gray-600" ] []
             ]
    , div [] [ text "Cloudy:",
               input [ placeholder "Boolean", value (if model.inputCloudy then "true" else "false"), onInput UpdateTextCloudy, class "ml-2 border-2 border-gray-600" ] []
             ]
    , div [] [ text "Temperature:",
               input [ placeholder "Number", value (String.fromInt model.inputTemperature), onInput UpdateTextTemperature, class "ml-2 border-2 border-gray-600" ] []
             ]
    ]

    -- { moisture : Int
    -- , cloudy : Bool
    -- , id : Id
    -- , temperature : Int