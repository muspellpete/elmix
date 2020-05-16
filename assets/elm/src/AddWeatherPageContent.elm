module AddWeatherPageContent exposing (pageContent)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Weather exposing (Model, Msg(..))


pageContent : Model -> Browser.Document Msg
pageContent model =
    { title = "Elmix", body = bodyContent model }


bodyContent : Model -> List (Html Msg)
bodyContent model =
    [ div [ class "mb-4 font-bold" ] [ text "Add weather" ]
    , div []
        [ text "Moisture:"
        , input [ placeholder "Number", value (String.fromInt model.inputMoisture), onInput UpdateTextMoisture, class "ml-2 border-2 border-gray-600" ] []
        ]
    , div []
        [ text "Cloudy:"
        , input
            [ placeholder "Boolean"
            , value
                (if model.inputCloudy then
                    "true"

                 else
                    "false"
                )
            , onInput UpdateTextCloudy
            , class "ml-2 border-2 border-gray-600"
            ]
            []
        ]
    , div []
        [ text "Temperature:"
        , input [ placeholder "Number", value (String.fromInt model.inputTemperature), onInput UpdateTextTemperature, class "ml-2 border-2 border-gray-600" ] []
        ]
    , div [] [ button [ onClick Weather.RefreshData, class "bg-blue-400 my-2" ] [ text "Back" ] ]
    , div [] [ button [ onClick Weather.RefreshData, class "bg-blue-400 my-2" ] [ text "Add weather" ] ]
    ]



-- { moisture : Int
-- , cloudy : Bool
-- , id : Id
-- , temperature : Int
