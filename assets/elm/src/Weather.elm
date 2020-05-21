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
    | PracticeDvorak
    | UpdateTextMoisture String
    | UpdateTextCloudy String
    | UpdateTextTemperature String
    | LessonProvider Row
    | GenerateNewLesson


type Page
    = ResultPage
    | ExtraPage
    | AddWeatherPage
    | PlaygroundPage
    | DvorakPracticePage


type Modifier
    = Still
    | Inwards


type Finger
    = Index Modifier
    | Middle
    | Ring
    | Little


type Row
    = Home
    | Top
    | Bottom
    | Thumb


type Hand
    = Left
    | Right


type Gesture
    = Ges Hand Row Finger


type alias Response =
    Maybe (List (Maybe Weather))


type alias Model =
    { data : RemoteData (Graphql.Http.Error Response) Response
    , page : Page
    , inputMoisture : Int -- for input field on UpdateText
    , inputCloudy : Bool
    , inputTemperature : Int
    , randomFinger : Finger
    , randomRow : Row
    , randomModifier : Modifier
    , randomHand : Hand
    }
