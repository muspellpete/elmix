module Main exposing (..)

import AddWeatherPageContent exposing (pageContent)
import Api.Object
import Api.Object.WeatherType as WeatherType
import Api.Query as Query
import Browser
import DvorakPracticePageContent exposing (pageContent)
import ExtraPageContent exposing (pageContent)
import Graphql.Http exposing (..)
import Graphql.Http.GraphqlError as GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html, button, div, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import PlaygroundPageContent exposing (pageContent)
import Random exposing (Generator)
import RemoteData exposing (RemoteData)
import String exposing (concat)
import Weather exposing (..)
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
        |> Graphql.Http.send (RemoteData.fromResult >> (\x -> { data = x, page = Weather.ResultPage, inputMoisture = 0, inputCloudy = False, inputTemperature = 0, randomFinger = Index Still, randomRow = Home, randomModifier = Still, randomHand = Left }) >> GotResponse)


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { data = RemoteData.Loading, page = Weather.DvorakPracticePage, inputMoisture = 0, inputCloudy = False, inputTemperature = 0, randomFinger = Index Still, randomRow = Home, randomModifier = Still, randomHand = Left }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshData ->
            ( { model | page = Weather.ResultPage }, makeRequest )

        GotResponse response ->
            ( response, Cmd.none )

        Weather.ExtraButton ->
            ( { model | page = Weather.ExtraPage }, Cmd.none )

        Weather.AddWeatherButton ->
            ( { model | page = Weather.AddWeatherPage }, Cmd.none )

        Weather.PlaygroundButton ->
            ( { model | page = Weather.PlaygroundPage }, Cmd.none )

        UpdateTextMoisture newMoisture ->
            -- Add the input to the input string in the model
            ( { model | inputMoisture = getValidWeatherNumber newMoisture model.inputMoisture }, Cmd.none )

        UpdateTextCloudy newCloudy ->
            ( { model | inputCloudy = getValidWeatherBool newCloudy model.inputCloudy }, Cmd.none )

        UpdateTextTemperature newTemperature ->
            ( { model | inputTemperature = getValidWeatherNumber newTemperature model.inputTemperature }, Cmd.none )

        PracticeDvorak ->
            ( { model | page = Weather.DvorakPracticePage }, Random.generate LessonProvider getRandomRow )

        LessonProvider row ->
            ( { model | randomRow = row }, Cmd.none )

        GenerateNewLesson ->
            ( model, Random.generate LessonProvider getRandomRow )


getRandomRow : Generator Row
getRandomRow =
    Random.uniform Thumb [ Top ]


getValidWeatherNumber : String -> Int -> Int
getValidWeatherNumber newString oldNumber =
    if newString == "" then
        0

    else
        case String.toInt newString of
            Just value ->
                value

            Nothing ->
                oldNumber


getValidWeatherBool : String -> Bool -> Bool
getValidWeatherBool newString oldBool =
    if newString == "0" then
        False

    else
        True


view : Model -> Browser.Document Msg
view model =
    --    {title = "SET UP DATA", body = [text "Add data to database, then uncomment this"]}
    case model.page of
        Weather.ResultPage ->
            case model.data of
                RemoteData.NotAsked ->
                    { title = "Elmix", body = [ text "Not asked" ] }

                RemoteData.Loading ->
                    { title = "Elmix", body = [ div [ class "bg-yellow-500" ] [ text "Loading" ] ] }

                RemoteData.Success successResponse ->
                    { title = "Elmix", body = [ createBody successResponse ] }

                RemoteData.Failure message ->
                    { title = "Elmix", body = [ text ("An error occured while fetching data: " ++ stringifyError message) ] }

        Weather.ExtraPage ->
            ExtraPageContent.pageContent model

        -- call with both elements which make up the Model
        Weather.AddWeatherPage ->
            AddWeatherPageContent.pageContent model

        Weather.PlaygroundPage ->
            PlaygroundPageContent.pageContent model

        Weather.DvorakPracticePage ->
            DvorakPracticePageContent.pageContent model


stringifyError : Graphql.Http.Error Response -> String
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
        Nothing ->
            div [] [ text "Nothing" ]

        Just weatherData ->
            ul []
                (button [ onClick Weather.AddWeatherButton, class "bg-green-400 m-4 pl-2 pr-2" ] [ text "Add weather" ]
                    :: button [ onClick Weather.ExtraButton, class "bg-orange-400 m-4 pl-2 pr-2" ] [ text "Extra page" ]
                    :: button [ onClick Weather.PlaygroundButton, class "bg-orange-400 m-4 pl-2 pr-2" ] [ text "Playground page" ]
                    :: (createListNumbers weatherData |> List.map createWeatherLi)
                )


main : Program Flags Model Msg
main =
    Browser.document { init = init, update = update, subscriptions = \_ -> Sub.none, view = view }
