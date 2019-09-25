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
import Html exposing (Html, div, text)
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
        RemoteData.NotAsked -> {title = "This is my title", body = [text "Not asked"]}
        RemoteData.Loading -> {title = "This is my title", body = [text "Loading"]}
        RemoteData.Success successResponse -> {title = "This is my title", body = [div [class "text-5xl"] [extractData successResponse |> text]]}
        RemoteData.Failure message -> {title = "This is my title", body = [text "An error occured while fetching data"]}

extractData : Response -> String
extractData response =
    case response of
        Nothing -> "Nothing"
        Just weatherData -> stringify weatherData

stringify : List (Maybe Weather) -> String
stringify weatherData =
        "Number of samples are: " ++ String.fromInt (List.length weatherData)

main : Program Flags Model Msg
main =
    Browser.document {init = init, update = update, subscriptions = \_ -> Sub.none, view = view}
