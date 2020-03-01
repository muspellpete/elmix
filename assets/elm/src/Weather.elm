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
    | UpdateText String

type Page
    = ResultPage
    | ExtraPage
    | AddWeatherPage

type alias Response =
    Maybe (List (Maybe Weather))

type alias Model =
    { data: RemoteData (Graphql.Http.Error Response) Response
    , page: Page
    , inputText: String -- for input field on UpdateText
    }