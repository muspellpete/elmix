module Gesture exposing (..)


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


type Hand
    = Left
    | Right


type Gesture
    = Ges Hand Row Finger


getKeyForGesture : Gesture -> String
getKeyForGesture gesture =
    case gesture of
        Ges Left row finger ->
            getKeyForLeftHand row finger

        Ges Right row finger ->
            getKeyForRightHand row finger


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
