module Main exposing (..)

import AddWeatherPageContent
import Api.Object
import Api.Object.WeatherType as WeatherType
import Api.Query as Query
import Browser
import Browser.Events exposing (onKeyDown)
import DvorakPracticePageContent
import ExtraPageContent
import Gesture exposing (Finger(..), Gesture(..), Hand(..), Modifier(..), Row(..))
import Graphql.Http exposing (..)
import Graphql.Http.GraphqlError as GraphqlError
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (Html, button, div, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import PlaygroundPageContent
import Random exposing (Generator)
import RemoteData exposing (RemoteData)
import String exposing (concat)
import Weather exposing (Key(..), LessonMode(..), Model, Msg(..), Page, Response, Weather)
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


makeRequest : Cmd Msg
makeRequest =
    Query.samples samplesInfoSelection
        |> Graphql.Http.queryRequest "/api/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)



--|> Graphql.Http.send (\result -> GotResponse (RemoteData.fromResult result))
--resultExtractor : Result (Error (Response)) (Response) -> Msg
--resultExtractor result =
--    GotResponse (RemoteData.fromResult result)
-- All the crazy redirects should not be necessary, also the anonymous function should just be defined properly for readability


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( getDefaultModel RemoteData.Loading Weather.DvorakPracticePage, Random.generate LessonProvider getRandomGesture )


getDefaultModel : RemoteData (Graphql.Http.Error Response) Response -> Page -> Model
getDefaultModel remoteData page =
    { data = remoteData, page = page, inputMoisture = 0, inputCloudy = False, inputTemperature = 0, randomFinger = Gesture.Index Gesture.Still, randomGesture = Gesture.Ges Gesture.Left Gesture.Top Gesture.Little, lessonMode = TypeGesture }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RefreshData ->
            ( { model | page = Weather.ResultPage }, makeRequest )

        GotResponse response ->
            ( getDefaultModel response Weather.ResultPage, Cmd.none )

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
            ( { model | page = Weather.DvorakPracticePage }, Random.generate LessonProvider getRandomGesture )

        LessonProvider gesture ->
            ( { model | randomGesture = gesture }, Cmd.none )

        GenerateNewLesson ->
            ( model, Random.generate LessonProvider getRandomGesture )

        ChangeLessonMode mode ->
            case mode of
                TypeGesture ->
                    ( { model | lessonMode = mode }, Random.generate LessonProvider getRandomGesture )

                GuessLetter ->
                    ( { model | lessonMode = mode }, Cmd.none )

        UserPressedKey key ->
            if key == Gesture.getKeyForGesture model.randomGesture then
                -- Generate new lesson when you get it right
                ( model, Random.generate LessonProvider getRandomGesture )

            else
                ( model, Cmd.none )



-- Note that Gesture would have worked as a type alias Gesture = {a: Hand, b: Row, c: Finger}
-- The reason for this is that such a type alias for a Record automatically creates a constructor for it.
-- A constructor will take those arguments in the same order.


getRandomGesture : Generator Gesture
getRandomGesture =
    Random.map3
        Gesture.Ges
        (Random.uniform Gesture.Left [ Gesture.Right ])
        (Random.uniform Gesture.Home [ Gesture.Top, Gesture.Bottom ])
        (Random.uniform Gesture.Middle [ Gesture.Ring, Gesture.Little ])


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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Decode.field "key" Decode.string
        |> Decode.map (\m -> UserPressedKey m)
        |> onKeyDown


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
                    :: button [ onClick Weather.PracticeDvorak, class "bg-blue-400 m-4 pl-2 pr-2" ] [ text "Practice DVORAK" ]
                    :: (createListNumbers weatherData |> List.map createWeatherLi)
                )


main : Program Flags Model Msg
main =
    Browser.document { init = init, update = update, subscriptions = subscriptions, view = view }
