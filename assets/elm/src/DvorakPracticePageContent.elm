module DvorakPracticePageContent exposing (..)

import Browser
import Gesture exposing (Finger(..), Gesture(..), Hand(..), Modifier(..), Row(..))
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Weather exposing (..)


pageContent : Model -> Browser.Document Msg
pageContent model =
    { title = "Elmix - Dvorak Practice", body = [ body model ] }


body : Model -> Html Msg
body model =
    div []
        [ div [] [ text (gestureToString model.randomGesture) ]
        , div [] [ button [ onClick GenerateNewLesson, class "bg-blue-400" ] [ text "Generate new key" ] ]
        , div [] [ button [ onClick RefreshData, class "bg-gray-400" ] [ text "Back" ] ]
        ]


gestureToString : Gesture -> String
gestureToString gesture =
    case gesture of
        Ges hand row finger ->
            handToString hand ++ " - " ++ rowToString row ++ " - " ++ fingerToString finger


handToString : Hand -> String
handToString hand =
    case hand of
        Left ->
            "Left"

        Right ->
            "Right"


rowToString : Row -> String
rowToString row =
    case row of
        Home ->
            "home"

        Top ->
            "top"

        Bottom ->
            "bottom"


fingerToString : Finger -> String
fingerToString finger =
    case finger of
        Index modifier ->
            case modifier of
                Still ->
                    "index finger"

                Inwards ->
                    "index finger inward"

        Middle ->
            "middle finger"

        Ring ->
            "ring finger"

        Little ->
            "pinky finger"
