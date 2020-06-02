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
        [ div [] [ createLesson model.lessonMode model.randomGesture ]
        , div [] [ button [ onClick GenerateNewLesson, class "bg-blue-400" ] [ text "Generate new key" ] ]
        , div [] [ button [ onClick RefreshData, class "bg-gray-400" ] [ text "Back" ] ]
        ]


createLesson : LessonMode -> Gesture -> Html msg
createLesson mode gesture =
    case mode of
        TypeGesture ->
            div []
                [ div [ class "font-bold" ] [ text "Type this key, if you get it right it will change: " ]
                , div [ class "m-4" ] [ gesture |> gestureToString |> text ]
                ]

        GuessLetter ->
            text (gestureToString gesture)


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
