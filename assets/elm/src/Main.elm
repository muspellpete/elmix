module Main exposing (..)

--import Html exposing (..)
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Api.Object
import Api.Object.WeatherType as WeatherType
import Api.Query as Query
import Api.ScalarCodecs exposing (Id)

import Browser
--import DateFormat exposing (text)
import Html exposing (Html, a, div, h1, input, label, p, pre, text)
import Html.Attributes exposing (href, type_)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData)
import PrintAny
import Regex

type alias Program flags subModel subMsg =
    Platform.Program flags (ModelTwo subModel) (MsgTwo subMsg)

type MsgTwo subMsg
    = ToggleAliases
    | SubMsg subMsg

type alias ModelTwo subModel =
    { subModel : subModel
    , hideAliases : Bool
    }

document : 
    { initTwo : flags -> ( subModel, Cmd subMsg )
    , updateTwo : subMsg -> subModel -> ( subModel, Cmd subMsg )
    , queryString : String
    }
    -> Program flags subModel subMsg

document { initTwo, updateTwo, queryString } =
    Browser.document
    { init = mapInit initTwo
    , update = mapUpdate updateTwo
    , subscriptions = \_ -> Sub.none
    , view = view queryString
    }

mapInit : (flags -> ( subModel, Cmd subMsg )) -> flags -> ( ModelTwo subModel, Cmd (MsgTwo subMsg))
mapInit subInit flags =
    subInit flags
        |> Tuple.mapFirst (\subModel -> { subModel = subModel, hideAliases = True })
        |> Tuple.mapSecond (Cmd.map SubMsg)

mapUpdate : (subMsg -> subModel -> ( subModel, Cmd subMsg )) -> MsgTwo subMsg -> ModelTwo subModel -> ( ModelTwo subModel, Cmd (MsgTwo subMsg))
mapUpdate subUpdate msg model =
    case msg of
        ToggleAliases ->
            ( { model | hideAliases = not model.hideAliases}, Cmd.none )

        SubMsg subMsg ->
            let 
                (a, b) =
                    subUpdate subMsg model.subModel

            in
            ({model | subModel = a}, b |> Cmd.map SubMsg)

view : String -> ModelTwo a -> Browser.Document (MsgTwo subMsg)
view queryTwo model =
    { title = "Query Explorer"
    , body =
        [ div []
            [ div []
                [ h1 [] [text "Generated Query"]
                , p [] [toggleAliasesCheckbox ]
                , pre []
                    [ (if model.hideAliases then 
                         queryTwo |> stripAliases
                      else
                        queryTwo
                        )
                        |> text

                    ]
                ]
                , div []
                     [ h1 [] [text "Response"]
                     , model.subModel |> PrintAny.view
                     ]
            ]
        ]
    }

toggleAliasesCheckbox : Html (MsgTwo subMsg)
toggleAliasesCheckbox =
    label []
    [ input [type_ "checkbox", onClick ToggleAliases] []
    , text " Show Aliases"
    , a [ href "https://github.com/dillonkearns/elm-graphql/blob/master/FAQ.md#how-do-field-aliases-work-in-dillonkearnselm-graphql" ]
        [ text "(?)"
        ]
    ]

stripAliases : String -> String
stripAliases queryTwo =
    queryTwo
        |> Regex.replace
            (Regex.fromStringWith { multiline = True, caseInsensitive = True }, "^(\\s*)\\w+: "
                |> Maybe.withDefault Regex.never
            )
            (\match -> match.submatches |> List.head |> Maybe.withDefault Nothing |> Maybe.withDefault "")


type alias Response =
    Maybe WeatherTypeTwo

query : SelectionSet Response RootQuery
query =
    Query.samples identity WeatherType

type alias WeatherTypeTwo =
    { cloudy : Bool
    , id : Id
    , moisture : Int
    }

-- weatherTypeInfoSelection : SelectionSet WeatherTypeTwo Api.Object.WeatherType
-- weatherTypeInfoSelection =
--     SelectionSet.map3 WeatherTypeTwo
--         WeatherType.cloudy
--         WeatherType.id
--         WeatherType.moisture

makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "https://localhost:4000/api/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)

type Msg
    = GotResponse Model

type alias Model =
    RemoteData (Graphql.Http.Error Response) Response

type alias Flags =
    ()

init : Flags -> ( Model, Cmd Msg )
init _ =
    ( RemoteData.Loading, makeRequest )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )

main : Program Flags Model Msg
main =
    document
        { initTwo = init
        , updateTwo = update
        , queryString = Document.serializeQuery query
        }