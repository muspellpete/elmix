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
