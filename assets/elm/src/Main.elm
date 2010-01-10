module Main exposing (..)

import Html exposing (..)
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Api.Interface
import Api.Object.WeatherType as WeatherType
import Api.Query as Query

type alias Response =
    WeatherType

query : SelectionSet Response RootQuery
query =
    Query.samples identity samplesInfoSelection

type alias WeatherType =
    { cloudy: bool
    , id : id
    , moisture : Int
    }

samplesInfoSelection : SelectionSet WeatherType Api.Interface.placeholder
samplesInfoSelection =
    SelectionSet.map3 WeatherType
    WeatherType.name
    WeatherType.id

makeRequest : Cmd type Msg
    = query
    |> Graphql.Http.queryRequest "https://localhost:4000/api/graphql"
    |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)

type Msg
    = GotResponse Model

type alias Model =
    RemoteData (Graphql.Http.Error Response) Response

type alias Flas =
    ()

init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )

main : Helpers.Main.Program Flags Model Msg
main =
    Helpers.Main.document
        { init = init
        , update = update
        , queryString = Document.serializeQuery query
        }