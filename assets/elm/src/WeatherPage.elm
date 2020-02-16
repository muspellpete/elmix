module WeatherPage exposing (..)

import Html exposing (Html, div, text, ul, li)
import Html.Attributes exposing (class)
import Weather exposing (Weather, Msg)

createListNumbers : List(Maybe Weather) -> List (Maybe Weather, Int)
createListNumbers weatherList =
    List.map2 (\w n -> (w, n)) weatherList (List.range 1 (List.length weatherList))

createWeatherLi : ((Maybe Weather), Int) -> Html Msg
createWeatherLi (maybeWeather, number) =
    case maybeWeather of
        Nothing -> li [getWeatherStyle False] [String.fromInt number ++ ":" ++ "Empty weather" |> text]
        Just weather -> li [getWeatherStyle True] [ul [] (prettyPrintWeather (weather, number))]

getWeatherStyle : Bool -> Html.Attribute Msg
getWeatherStyle hasData =
    (if hasData then "bg-gray-200" else "bg-red-400")
    ++ " p-4"
    |> class

prettyPrintWeather : (Weather, Int) -> List (Html Msg)
prettyPrintWeather (weather, number) =
    List.map (\header -> header ++ ":") ["Number", "Moisture", "Temperature", "Cloudy"]
    |> List.map2 combineValueWithHeader [number, weather.moisture, weather.temperature, (if weather.cloudy then 1 else 0)]

combineValueWithHeader : Int -> String -> Html Msg
combineValueWithHeader value header =
    prettyPrintAttribute header (div [][text (String.fromInt value)])

prettyPrintAttribute : String -> Html Msg -> Html Msg
prettyPrintAttribute label valueHtml =
    li [class "flex items-center"] [ (div [class "font-bold mr-4"] [text label]), valueHtml]
