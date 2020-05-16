module Weather exposing (..)

import Api.ScalarCodecs exposing (Id)
import Graphql.Http
import RemoteData exposing (RemoteData)


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
    | PlaygroundButton
    | UpdateTextMoisture String
    | UpdateTextCloudy String
    | UpdateTextTemperature String


type Page
    = ResultPage
    | ExtraPage
    | AddWeatherPage
    | PlaygroundPage


type alias Response =
    Maybe (List (Maybe Weather))


type alias Model =
    { data : RemoteData (Graphql.Http.Error Response) Response
    , page : Page
    , inputMoisture : Int -- for input field on UpdateText
    , inputCloudy : Bool
    , inputTemperature : Int
    }
