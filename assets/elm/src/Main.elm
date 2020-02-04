module Main exposing (..)

import Api.Query as Query
import Api.Object.WeatherType as WeatherType
import Api.Object

import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Graphql.Operation exposing (RootQuery)
import Graphql.Document as Document
import Graphql.Http

import Browser
import Html exposing (Html, text, div, ul)
import Html.Attributes exposing (class)
import RemoteData exposing (RemoteData)

import Weather exposing (Weather, Response, Msg (..), Model)
import WeatherPage exposing (createListNumbers, createWeatherLi)

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
--    {title = "SET UP DATA", body = [text "Add data to database, then uncomment this"]}
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
            createListNumbers weatherData
            |> List.map createWeatherLi)

main : Program Flags Model Msg
main =
    Browser.document {init = init, update = update, subscriptions = \_ -> Sub.none, view = view}
