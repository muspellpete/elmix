module Weather exposing (..)

import Api.ScalarCodecs exposing (Id)
import Gesture exposing (Gesture)
import Graphql.Http
import RemoteData exposing (RemoteData)


type Key
    = Character Char
    | Control String


type alias Weather =
    { moisture : Int
    , cloudy : Bool
    , id : Id
    , temperature : Int
    }


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error Response) Response)
    | RefreshData
    | ExtraButton
    | AddWeatherButton
    | PlaygroundButton
    | PracticeDvorak
    | UpdateTextMoisture String
    | UpdateTextCloudy String
    | UpdateTextTemperature String
    | LessonProvider Gesture
    | GenerateNewLesson
    | UserPressedKey String


type Page
    = ResultPage
    | ExtraPage
    | AddWeatherPage
    | PlaygroundPage
    | DvorakPracticePage


type alias Response =
    Maybe (List (Maybe Weather))


type alias Model =
    { data : RemoteData (Graphql.Http.Error Response) Response
    , page : Page
    , inputMoisture : Int -- for input field on UpdateText
    , inputCloudy : Bool
    , inputTemperature : Int
    , randomFinger : Gesture.Finger
    , randomGesture : Gesture
    }
