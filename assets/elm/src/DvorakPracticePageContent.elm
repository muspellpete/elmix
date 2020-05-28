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
        [ div [] [ text (getKeyForGesture model.randomGesture) ]
        , div [] [ button [ onClick GenerateNewLesson, class "bg-blue-400" ] [ text "Generate new key" ] ]
        , div [] [ button [ onClick RefreshData, class "bg-gray-400" ] [ text "Back" ] ]
        ]


getKeyForGesture : Gesture -> String
getKeyForGesture gesture =
    case gesture of
        Ges Left height finger ->
            getKeyForLeftHand height finger

        Ges Right height finger ->
            getKeyForRightHand height finger


getKeyForLeftHand : Row -> Finger -> String
getKeyForLeftHand row finger =
    case row of
        Home ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "u"

                        Inwards ->
                            "i"

                Middle ->
                    "e"

                Ring ->
                    "o"

                Little ->
                    "a"

        Top ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "p"

                        Inwards ->
                            "y"

                Middle ->
                    "."

                Ring ->
                    ","

                Little ->
                    "'"

        Bottom ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "k"

                        Inwards ->
                            "x"

                Middle ->
                    "j"

                Ring ->
                    "q"

                Little ->
                    ";"


getKeyForRightHand : Row -> Finger -> String
getKeyForRightHand row finger =
    case row of
        Home ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "h"

                        Inwards ->
                            "d"

                Middle ->
                    "t"

                Ring ->
                    "n"

                Little ->
                    "s"

        Top ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "g"

                        Inwards ->
                            "f"

                Middle ->
                    "c"

                Ring ->
                    "r"

                Little ->
                    "l"

        Bottom ->
            case finger of
                Index modifier ->
                    case modifier of
                        Still ->
                            "m"

                        Inwards ->
                            "b"

                Middle ->
                    "w"

                Ring ->
                    "v"

                Little ->
                    "z"
