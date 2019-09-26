import Api.Object
import Api.Object.WeatherType as WeatherType
import Api.Query as Query
import Browser
import Graphql.Http
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Graphql.Operation exposing (RootQuery)
import Graphql.Document as Document
import RemoteData exposing (RemoteData)
import Api.ScalarCodecs exposing (Id)
import Html exposing (Html, div, text, ul, li)
import Html.Attributes exposing (..)

type Msg =
    GotResponse Model

type alias Response =
    Maybe (List (Maybe Weather))

type alias Model =
    RemoteData (Graphql.Http.Error Response) Response

type alias Weather =
    { moisture : Int
    , cloudy : Bool
    , id : Id
    , temperature : Int
    }

type alias Flags =
    ()

samplesInfoSelection : SelectionSet Weather Api.Object.WeatherType
samplesInfoSelection =
    SelectionSet.map4 Weather
        (WeatherType.moisture |> SelectionSet.nonNullOrFail)
        (WeatherType.cloudy |> SelectionSet.nonNullOrFail)
        (WeatherType.id |> SelectionSet.nonNullOrFail)
        (WeatherType.temperature |> SelectionSet.nonNullOrFail)

query : SelectionSet Response RootQuery
query = 
    Query.samples samplesInfoSelection

makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "/api/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)

init : Flags -> (Model, Cmd Msg)
init _ =
    (RemoteData.Loading, makeRequest)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none)

view : Model -> Browser.Document Msg
view model =
    case model of
        RemoteData.NotAsked -> {title = "Elmix", body = [text "Not asked"]}
        RemoteData.Loading -> {title = "Elmix", body = [div [class "bg-yellow-500"][text "Loading"]]}
        RemoteData.Success successResponse -> {title = "Elmix", body = [createBody successResponse]}
        RemoteData.Failure message -> {title = "Elmix", body = [text "An error occured while fetching data"]}

createBody : Response -> Html Msg
createBody response =
    case response of
        Nothing -> div [] [text "Nothing"]
        Just weatherData -> ul [] (
            insertIndex weatherData
            |> List.map extractWeather)

insertIndex : List(Maybe Weather) -> List (Maybe Weather, Int)
insertIndex weatherList =
    List.map2 (\w n -> (w, n)) weatherList (List.range 1 (List.length weatherList))

extractWeather : ((Maybe Weather), Int) -> Html Msg
extractWeather (maybeWeather, number) =
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
    [
        prettyPrintAttribute "Number:" (String.fromInt number),
        prettyPrintAttribute "Moisture:" (String.fromInt weather.moisture),
        prettyPrintAttribute "Temperature:" (String.fromInt weather.temperature),
        prettyPrintAttribute "Cloudy:" (if weather.cloudy then "True" else "False")
    ]

prettyPrintAttribute : String -> String -> Html msg
prettyPrintAttribute label value =
    li [class "flex items-center"] [ (div [class "font-bold mr-4"] [label |> text]), (div [][value |> text])]

main : Program Flags Model Msg
main =
    Browser.document {init = init, update = update, subscriptions = \_ -> Sub.none, view = view}
