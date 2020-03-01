module Weather exposing (..)

import Api.ScalarCodecs exposing (Id)
import RemoteData exposing (RemoteData)
import Graphql.Http

type alias Weather =
    { moisture : Int
    , cloudy : Bool
    , id : Id
    , temperature : Int
    }

type Msg 
    = GotResponse Model
    | RefreshData
    | ExtraButton
    | AddWeatherButton

type Page
    = ResultPage
    | ExtraPage
    | AddWeatherPage

type alias Response =
    Maybe (List (Maybe Weather))

type alias Model =
    ( RemoteData (Graphql.Http.Error Response) Response
    , Page
    )