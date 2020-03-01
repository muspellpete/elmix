module Main exposing (..)

import Api.Query as Query
import Api.Object.WeatherType as WeatherType
import Api.Object

import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Graphql.Operation exposing (RootQuery)
import Graphql.Http exposing (..)
import Graphql.Http.GraphqlError as GraphqlError

import Browser
import Html exposing (Html, text, div, ul, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData)

import Weather exposing (Weather, Response, Msg (..), Model)
import WeatherPage exposing (createListNumbers, createWeatherLi)
import ExtraPageContent exposing (pageContent)
import AddWeatherPageContent exposing (pageContent)

import String exposing (concat)

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
        |> Graphql.Http.send (RemoteData.fromResult >> (\x -> {data = x, page = Weather.ResultPage, inputText = ""}) >> GotResponse)

init : Flags -> (Model, Cmd Msg)
init _ =
    ({ data = RemoteData.Loading, page = Weather.ResultPage, inputText = "" }, makeRequest)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        RefreshData -> 
            ( { model | page = Weather.ResultPage }, makeRequest)
        GotResponse response ->
            ( response, Cmd.none)
        Weather.ExtraButton -> 
            ( { model | page = Weather.ExtraPage }, Cmd.none )
        Weather.AddWeatherButton ->
            ( { model | page = Weather.AddWeatherPage }, Cmd.none )
        UpdateText newText -> -- Add the input to the input string in the model
            ( { model | inputText = newText }, Cmd.none)

view : Model -> Browser.Document Msg
view model =
--    {title = "SET UP DATA", body = [text "Add data to database, then uncomment this"]}
    case model.page of
        Weather.ResultPage ->
            case model.data of
                RemoteData.NotAsked -> {title = "Elmix", body = [text "Not asked"]}
                RemoteData.Loading -> {title = "Elmix", body = [div [class "bg-yellow-500"][text "Loading"]]}
                RemoteData.Success successResponse -> {title = "Elmix", body = [createBody successResponse]}
                RemoteData.Failure message -> {title = "Elmix", body = [text ("An error occured while fetching data: " ++ stringifyError message)]}
        Weather.ExtraPage ->
            ExtraPageContent.pageContent model -- call with both elements which make up the Model
        Weather.AddWeatherPage ->
            AddWeatherPageContent.pageContent model

stringifyError: Graphql.Http.Error Response -> String
stringifyError error =
    case error of
        HttpError x ->
            case x of
                BadUrl url ->
                    "Bad URL: " ++ url
                Timeout ->
                    "Timeout"
                NetworkError ->
                    "Network error"
                BadStatus _ str ->
                    "Bad status: " ++ str
                BadPayload _ ->
                    "Bad payload"
        GraphqlError _ graphqlError ->
            "GraphQL Error: " ++ concat (List.map stringifygraphqlError graphqlError) 

stringifygraphqlError : GraphqlError.GraphqlError -> String
stringifygraphqlError error =
    error.message
    

createBody : Response -> Html Msg
createBody response =
    case response of
        Nothing -> div [] [text "Nothing"]
        Just weatherData -> ul [] (
            button [onClick Weather.AddWeatherButton, class "bg-green-400 m-4 pl-2 pr-2"] [text "Add weather"] :: 
            button [onClick Weather.ExtraButton, class "bg-orange-400 m-4 pl-2 pr-2"] [text "Extra page"] :: 
            (createListNumbers weatherData |> List.map createWeatherLi))

main : Program Flags Model Msg
main =
    Browser.document {init = init, update = update, subscriptions = \_ -> Sub.none, view = view}
